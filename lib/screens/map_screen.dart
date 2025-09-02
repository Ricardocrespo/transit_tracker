import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:transit_tracker/components/legend/legend_launcher.dart';
import 'package:transit_tracker/components/legend/legend_sheet_content.dart';
import 'package:transit_tracker/components/map/map_container.dart';
import 'package:transit_tracker/components/graphics/recency_overlay_dots.dart';
import 'package:transit_tracker/components/reporting/report_controller.dart';
import 'package:transit_tracker/models/location/point.dart';
import 'package:transit_tracker/services/cached_tile_provider.dart';
import 'package:transit_tracker/utils/draw/recency_scale.dart';
import 'package:transit_tracker/utils/geo/bounds.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class MapScreen extends StatelessWidget {
  final Point selectedPoint;
  final MapController _mapController = MapController();

  MapScreen({super.key, required this.selectedPoint});

  void _onMapReady() {
    // hook for future live fetch or cache invalidation
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapContainer(
          key: ValueKey(selectedPoint.id),
          mapController: _mapController,
          center: selectedPoint.location,
          bounds: expandBoundsAround(selectedPoint.location, meters: 2000),
          onMapReady: _onMapReady,
          tileLayer: TileLayer(
            urlTemplate:
                '${const String.fromEnvironment('MAP_TILE_URL', defaultValue: 'http://10.0.2.2:3000/tiles/')}{z}/{x}/{y}',
            tileProvider: CachedTileProvider(),
            userAgentPackageName: 'com.transittracker.app',
          ),
          additionalLayers: const [
            RecencyDotsOverlay(
              clusterRadiusMeters: 20, // tweak 15–30m to taste
              minRadiusPx: 6,
              maxRadiusPx: 18,
            ),
          ],
        ),
        // Bottom-left toggleable legend
        Positioned(
          left: 12,
          bottom: 12 + MediaQuery.of(context).padding.bottom,
          child: LegendLauncher(
            //enabled: _mode != _ReportMode.placing, // hide/disable during placement
            buildLegendSheet: (ctx) {
              final l10n = AppLocalizations.of(ctx);
              final scale = RecencyScale();
              final legendKeys = scale.legendKeys();
              return LegendSheetContent(
                colors: scale.legendColors(),
                verbose: legendKeys.map((key) => l10n.translate(key)).toList(),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: SafeArea(
            child: FloatingActionButton(
              mini: true,
              heroTag: 'navigation_drawer',
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.menu),
            ),
          ),
        ),
        ReportController(
          selectedPoint: selectedPoint,
          mapController: _mapController,
        ),
      ],
    );
  }
}
