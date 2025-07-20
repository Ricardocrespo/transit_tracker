import 'package:latlong2/latlong.dart';

class Point {
  final int id;
  final LatLng location;

  const Point({required this.id, required this.location});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      location: LatLng(json['lat'], json['lon']),
    );
  }
}
