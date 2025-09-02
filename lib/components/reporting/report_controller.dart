import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

import 'package:transit_tracker/components/reporting/center_pin.dart';
import 'package:transit_tracker/components/reporting/placement_sheet.dart';
import 'package:transit_tracker/components/reporting/recenter_gps_button.dart';

import 'package:transit_tracker/models/location/point.dart';
import 'package:transit_tracker/models/reporting/report_submission.dart';
import 'package:transit_tracker/services/location_service.dart';
import 'package:transit_tracker/services/report_service.dart';
import 'package:transit_tracker/utils/device.dart';
import 'package:transit_tracker/utils/geo/distance.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

enum _ReportMode { idle, placing, submitting }

class ReportController extends StatefulWidget {
  final Point selectedPoint;
  final MapController mapController;

  const ReportController({
    super.key,
    required this.selectedPoint,
    required this.mapController,
  });

  @override
  State<ReportController> createState() => _ReportControllerState();
}

class _ReportControllerState extends State<ReportController> {
  _ReportMode _mode = _ReportMode.idle;

  /// Runs permission + availability + range checks.
  /// Returns a Position on success, or null on failure.
  Future<bool> _prechecks() async {
    final l10n = AppLocalizations.of(context);

    final perm = await LocationService.checkPermissionStatus();
    if (perm != LocationPermissionStatus.granted) {
      switch (perm) {
        case LocationPermissionStatus.disabled:
          _showSnackbar(l10n.translate('location.disabled'));
          return false;
        case LocationPermissionStatus.denied:
        case LocationPermissionStatus.deniedForever:
          _showSnackbar(l10n.translate('location.permanentlyDenied'));
          return false;
        default:
          return false;
      }
    } else {
      return true; // permission granted
    }
  }

  Future<void> _startPlacing() async {
    if (_mode != _ReportMode.idle) return;
    setState(() => _mode = _ReportMode.placing);
    final ok = await _prechecks();
    if (!ok) {
      _cancelPlacing();
      return;
    }
    await _recenterToGPS();
  }

  /// Recenter button: prefer using the cached fix first (no extra GPS call),
  /// then fall back to fetching a fresh fix if cache is missing.
  Future<void> _recenterToGPS() async {
    final l10n = AppLocalizations.of(context);

    // if no cached fix yet (unlikely here), fetch one
    Position? pos = await LocationService.getCurrentLocation();
    if (pos == null) {
      _showSnackbar(l10n.translate('location.unavailable'));
      return;
    }

    final ok = DistanceUtils.isWithinKilometers(
      widget.selectedPoint.location,
      LatLng(pos.latitude, pos.longitude),
      2.0,
    );
    if (!ok) {
      _showSnackbar(l10n.translate('location.outOfRange'));
      return;
      // lenient: still allow placing so user can nudge into range
    }

    final target = LatLng(pos.latitude, pos.longitude);
    final currentZoom = widget.mapController.camera.zoom;
    try {
      widget.mapController.move(target, currentZoom);
    } catch (e) {
      _showSnackbar(l10n.translate('location.reportFailed'));
    }
  }

  Future<void> _confirmAndSubmit() async {
    if (_mode != _ReportMode.placing) return;

    setState(() => _mode = _ReportMode.submitting);
    final l10n = AppLocalizations.of(context);

    final LatLng center = widget.mapController.camera.center;

    try {
      final report = ReportSubmission(
        latitude: center.latitude,
        longitude: center.longitude,
        timestamp: DateTime.now(),
        zoneId: widget.selectedPoint.zoneId,
        pointId: widget.selectedPoint.id,
        deviceId: await DeviceUtils.getHashedDeviceId(),
        source: "user",
        accuracy: null,
        platform: await DeviceUtils.getPlatform(),
        appVersion: await DeviceUtils.getAppVersion(),
      );

      final Response resp = await ReportService.reportUserArrival(report);
      if (resp.statusCode == 200) {
        _showSnackbar(l10n.translate('location.reported'));
      } else {
        _showSnackbar(l10n.translate('location.reportFailed'));
      }
    } catch (_) {
      _showSnackbar(l10n.translate('location.reportFailed'));
    } finally {
      if (mounted) setState(() => _mode = _ReportMode.idle);
    }
  }

  void _cancelPlacing() {
    if (_mode != _ReportMode.placing) return;
    setState(() => _mode = _ReportMode.idle);
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _mode == _ReportMode.idle;
    final isBusy = _mode == _ReportMode.submitting;

    return Stack(
      children: [
        if (_mode == _ReportMode.placing) ...[
          const CenterPin(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recenter button with left alignment
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 16),
                    child: RecenterGpsButton(onPressed: _recenterToGPS),
                  ),

                  // Placement sheet
                  PlacementSheet(
                    onConfirm: _confirmAndSubmit,
                    onCancel: _cancelPlacing,
                  ),
                ],
              ),
            ),
          ),
        ],
        if (showFab || isBusy)
          Positioned(
            bottom: 12,
            right: 12,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                heroTag: 'report_arrival',
                onPressed: (isBusy) ? null : _startPlacing,
                child: (isBusy || _mode == _ReportMode.placing)
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.add_location_alt),
              ),
            ),
          ),
      ],
    );
  }

}
