import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/utils/geo/distance.dart';

void main() {
  group('DistanceUtils', () {
    final pointA = LatLng(37.7749, -122.4194); // San Francisco
    final pointB = LatLng(34.0522, -118.2437); // Los Angeles
    final pointC = LatLng(37.7749, -122.4194); // Same as pointA

    test('inKilometers returns 0 for identical points', () {
      expect(DistanceUtils.inKilometers(pointA, pointC), closeTo(0.0, 0.0001));
    });

    test('inKilometers returns correct distance between SF and LA', () {
      final kilometers = DistanceUtils.inKilometers(pointA, pointB);
      // Actual distance is about 347 kilometers
      expect(kilometers, closeTo(347, 2));
    });

    test('isWithinKilometers returns true if within range', () {
      // SF to LA is about 347 kilometers, so 400 should be true
      expect(DistanceUtils.isWithinKilometers(pointA, pointB, 400), isTrue);
    });

    test('isWithinKilometers returns false if not within range', () {
      // SF to LA is about 347 kilometers, so 300 should be false
      expect(DistanceUtils.isWithinKilometers(pointA, pointB, 300), isFalse);
    });

    test('isWithinKilometers returns true for identical points and zero kilometers', () {
      expect(DistanceUtils.isWithinKilometers(pointA, pointC, 0), isTrue);
    });
  });
}