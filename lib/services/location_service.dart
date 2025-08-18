import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus { granted, disabled, denied, deniedForever }

class LocationService {
  static Future<LocationPermissionStatus> checkPermissionStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionStatus.disabled;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    return LocationPermissionStatus.granted;
  }

  static Future<Position?> getCurrentLocation() async {
   try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      // Handle the case where the location is not available
      debugPrint('Error getting current location: $e');
      return null;
    }
  }
}
