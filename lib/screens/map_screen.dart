import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:transit_tracker/components/floating_button.dart';
import 'package:transit_tracker/components/map_container.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/services/cached_tile_provider.dart';
import 'package:transit_tracker/services/location_service.dart';
import 'package:transit_tracker/services/report_service.dart';
import 'package:transit_tracker/utils/geo/bounds.dart';
import 'package:transit_tracker/utils/geo/distance.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class MapScreen extends StatefulWidget {
  final Point selectedPoint;

  const MapScreen({super.key, required this.selectedPoint});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isReporting = false;

  Future<void> _handleReportArrival() async {
    if (_isReporting) return;

    final permission = await LocationService.checkPermissionStatus();
    if (permission != LocationPermissionStatus.granted) return;

    if (!mounted) return;
    final localization = AppLocalizations.of(context);
    switch (permission) {
      case LocationPermissionStatus.disabled:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localization.translate('location.disabled'))),
        );
        return;
      case LocationPermissionStatus.denied:
      case LocationPermissionStatus.deniedForever:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localization.translate('location.permanentlyDenied')),
          ),
        );
        return;
      case LocationPermissionStatus.granted:
        break; // proceed to get location
    }
    setState(() => _isReporting = true);

    try {
      final location = await LocationService.getCurrentLocation();
      if (location == null) return;

      if (!DistanceUtils.isWithinMiles(widget.selectedPoint.location, location, 2.0)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('location.outOfRange'),
            ),
          ),
        );
        return;
      }

      final reported = await ReportService.reportUserArrival(location);

      if (!reported || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('location.reported'),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isReporting = false);
      }
    }
  }

  void _onMapReady() {
    // Future: trigger heatmap rendering
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapContainer(
          key: ValueKey(widget.selectedPoint.id),
          center: widget.selectedPoint.location,
          bounds: expandBoundsAround(
            widget.selectedPoint.location,
            meters: 1000,
          ),
          onMapReady: _onMapReady,
          tileLayer: TileLayer(
            urlTemplate:
                '${const String.fromEnvironment('MAP_BASE_URL', defaultValue: 'http://10.0.2.2:3000')}/tiles/{z}/{x}/{y}',
            tileProvider: CachedTileProvider(),
            userAgentPackageName: 'com.transittracker.app',
          ),
          additionalLayers: const [],
        ),
        FloatingButton(
          alignment: Alignment.bottomRight,
          heroTag: 'report_arrival',
          icon: _isReporting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.add_location_alt),
          onPressed: _handleReportArrival,
          isDisabled: _isReporting,
        ),
        FloatingButton(
          alignment: Alignment.topLeft,
          heroTag: 'navigation_drawer',
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ],
    );
  }
}
