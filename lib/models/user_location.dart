import 'package:latlong2/latlong.dart';

class UserLocation {
  final LatLng coordinates;
  final double accuracy;

  UserLocation({required this.coordinates, required this.accuracy});
}
