import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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

  static Future<LatLng?> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high
      ),
    );
    return LatLng(position.latitude, position.longitude);
  }
}
