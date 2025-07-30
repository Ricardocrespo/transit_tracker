import 'package:latlong2/latlong.dart';

class Point {
  final int id;
  final LatLng location;
  final int zoneId;

  const Point({required this.id, required this.location, required this.zoneId});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      location: LatLng(json['lat'], json['lon']),
      zoneId: json['zoneId'],
    );
  }
}
