import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

LatLngBounds expandBoundsAround(LatLng center, {double meters = 1000}) {
  final Distance distance = const Distance();

  final north = distance.offset(center, meters, 0);    // 0° = north
  final south = distance.offset(center, meters, 180);  // 180° = south
  final east  = distance.offset(center, meters, 90);   // 90° = east
  final west  = distance.offset(center, meters, 270);  // 270° = west

  return LatLngBounds.fromPoints([north, south, east, west]);
}