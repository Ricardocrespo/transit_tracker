import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/utils/geo/distance.dart';

void main() {
  group('DistanceUtils', () {
    final pointA = LatLng(37.7749, -122.4194); // San Francisco
    final pointB = LatLng(34.0522, -118.2437); // Los Angeles
    final pointC = LatLng(37.7749, -122.4194); // Same as pointA

    test('inMiles returns 0 for identical points', () {
      expect(DistanceUtils.inMiles(pointA, pointC), closeTo(0.0, 0.0001));
    });

    test('inMiles returns correct distance between SF and LA', () {
      final miles = DistanceUtils.inMiles(pointA, pointB);
      // Actual distance is about 347 miles
      expect(miles, closeTo(347, 2));
    });

    test('isWithinMiles returns true if within range', () {
      // SF to LA is about 347 miles, so 400 should be true
      expect(DistanceUtils.isWithinMiles(pointA, pointB, 400), isTrue);
    });

    test('isWithinMiles returns false if not within range', () {
      // SF to LA is about 347 miles, so 300 should be false
      expect(DistanceUtils.isWithinMiles(pointA, pointB, 300), isFalse);
    });

    test('isWithinMiles returns true for identical points and zero miles', () {
      expect(DistanceUtils.isWithinMiles(pointA, pointC, 0), isTrue);
    });
  });
}