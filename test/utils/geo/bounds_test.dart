import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/utils/geo/bounds.dart';

void main() {
  group('expandBoundsAround', () {
    test('returns a LatLngBounds containing the center', () {
      final center = LatLng(37.7749, -122.4194); // San Francisco
      final bounds = expandBoundsAround(center);

      expect(bounds.contains(center), isTrue);
    });

    test('expands bounds by approximately the given meters', () {
      final center = LatLng(0, 0);
      final meters = 1000.0;
      final bounds = expandBoundsAround(center, meters: meters);

      final north = bounds.north;
      final south = bounds.south;
      final east = bounds.east;
      final west = bounds.west;
      final tolerance = 0.001; // Allowable error margin
      final approxDegreeDiff = 0.009; // Approximate degree difference for 1000 meters

      // The latitude difference for 1000 meters is about 0.009 degrees
      expect((north - center.latitude).abs(), closeTo(approxDegreeDiff, tolerance));
      expect((center.latitude - south).abs(), closeTo(approxDegreeDiff, tolerance));
      // The longitude difference for 1000 meters at the equator is about 0.009 degrees
      expect((east - center.longitude).abs(), closeTo(approxDegreeDiff, tolerance));
      expect((center.longitude - west).abs(), closeTo(approxDegreeDiff, tolerance));
    });

    test('returns different bounds for different radii', () {
      final center = LatLng(51.5074, -0.1278); // London
      final bounds1 = expandBoundsAround(center, meters: 500);
      final bounds2 = expandBoundsAround(center, meters: 2000);

      expect(bounds1.north < bounds2.north, isTrue);
      expect(bounds1.south > bounds2.south, isTrue);
      expect(bounds1.east < bounds2.east, isTrue);
      expect(bounds1.west > bounds2.west, isTrue);
    });
  });
}