import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/components/floating_button.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/models/report_submission.dart';
import 'package:transit_tracker/services/location_service.dart';
import 'package:transit_tracker/services/report_service.dart';
import 'package:transit_tracker/utils/device.dart';
import 'package:transit_tracker/utils/geo/distance.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class ReportController extends StatefulWidget {
  final Point selectedPoint;

  const ReportController({super.key, required this.selectedPoint});

  @override
  State<ReportController> createState() => _ReportControllerState();
}

class _ReportControllerState extends State<ReportController> {
  bool _isReporting = false;

  Future<void> _startReportFlow() async {
    if (_isReporting) return;

    setState(() => _isReporting = true);
    final context = this.context;
    final localization = AppLocalizations.of(context);

    final permission = await LocationService.checkPermissionStatus();
    if (permission != LocationPermissionStatus.granted) {
      _handlePermissionFailure(permission, localization);
      setState(() => _isReporting = false);
      return;
    }

    Position? currentPosition = await LocationService.getCurrentLocation();
    if (currentPosition == null) {
      _showSnackbar(localization.translate('location.unavailable'));
      setState(() => _isReporting = false);
      return;
    }

    final isCloseEnough = DistanceUtils.isWithinMiles(
      widget.selectedPoint.location,
      LatLng(currentPosition.latitude, currentPosition.longitude),
      2.0,
    );
    if (!isCloseEnough) {
      _showSnackbar(localization.translate('location.outOfRange'));
      setState(() => _isReporting = false);
      return;
    }

    final report = ReportSubmission(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
      timestamp: DateTime.now(),
      zoneId: widget.selectedPoint.zoneId,
      pointId: widget.selectedPoint.id,
      deviceId: await DeviceUtils.getHashedDeviceId(),
      source: "user",
      accuracy: currentPosition.accuracy, // optional accuracy
      platform: await DeviceUtils.getPlatform(),
      appVersion: await DeviceUtils.getAppVersion(),
    );

    try {
      Response reported = await ReportService.reportUserArrival(report);
      if (reported.statusCode == 200) {
        _showSnackbar(localization.translate('location.reported'));
      } else {
        _showSnackbar(localization.translate('location.reportFailed'));
      }
    } catch (e) {
      _showSnackbar(localization.translate('location.reportFailed'));
    } finally {
      // Reset reporting state regardless of success or failure
      setState(() => _isReporting = false);
    }
  }

  void _handlePermissionFailure(
    LocationPermissionStatus status,
    AppLocalizations localization,
  ) {
    switch (status) {
      case LocationPermissionStatus.disabled:
        _showSnackbar(localization.translate('location.disabled'));
        break;
      case LocationPermissionStatus.denied:
      case LocationPermissionStatus.deniedForever:
        _showSnackbar(localization.translate('location.permanentlyDenied'));
        break;
      default:
        break;
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
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
      onPressed: _startReportFlow,
      isDisabled: _isReporting,
    );
  }
}
