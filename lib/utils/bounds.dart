import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Expands a bounding box around a central coordinate by a specified radius.
///
/// This function calculates a rectangular bounding box around the given
/// `center` coordinate by offsetting it in the cardinal directions (north,
/// south, east, and west) by the specified `meters` distance. The default
/// radius is 1000 meters, which is a common value for geospatial queries.
///
/// The function uses the `Distance` class to compute the offsets, ensuring
/// accurate geodesic calculations.
///
/// Parameters:
/// - [center]: The central coordinate around which the bounding box is expanded.
/// - [meters]: The radius in meters to expand the bounding box. Defaults to 1000.
///
/// Returns:
/// A `LatLngBounds` object representing the expanded bounding box.
LatLngBounds expandBoundsAround(LatLng center, {double meters = 1000}) {
  final Distance distance = const Distance();

  final north = distance.offset(center, meters, 0);    // 0° = north
  final south = distance.offset(center, meters, 180);  // 180° = south
  final east  = distance.offset(center, meters, 90);   // 90° = east
  final west  = distance.offset(center, meters, 270);  // 270° = west

  return LatLngBounds.fromPoints([north, south, east, west]);
}