import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/services/location_service.dart';

import 'geolocator_platform_mock.dart';

void main() {
  late MockGeolocatorPlatform mockGeolocatorPlatform;

  void setUpGeolocator({
    required bool serviceEnabled,
    LocationPermission permission = LocationPermission.always,
    LocationPermission? requestPermissionResult,
  }) {
    when(mockGeolocatorPlatform.isLocationServiceEnabled()).thenAnswer((_) async => serviceEnabled);
    when(mockGeolocatorPlatform.checkPermission()).thenAnswer((_) async => permission);

    if (requestPermissionResult != null) {
      when(mockGeolocatorPlatform.requestPermission())
          .thenAnswer((_) async => requestPermissionResult);
    }
  }

  group('LocationService', () {
    group('checkPermissionStatus', () {
      setUp(() {
        mockGeolocatorPlatform = MockGeolocatorPlatform();
        GeolocatorPlatform.instance = mockGeolocatorPlatform;
      });
      test('returns disabled when location service is disabled', () async {

        setUpGeolocator(
          serviceEnabled: false, 
          permission: LocationPermission.denied
        );

        final result = await LocationService.checkPermissionStatus();
        expect(result, LocationPermissionStatus.disabled);
      });

      test('returns denied when permission is denied', () async {
        setUpGeolocator(
          serviceEnabled: true,
          permission: LocationPermission.denied,
          requestPermissionResult: LocationPermission.denied,
        );

        final result = await LocationService.checkPermissionStatus();
        expect(result, LocationPermissionStatus.denied);
      });

      test('returns deniedForever when permission is deniedForever', () async {
        setUpGeolocator(
          serviceEnabled: true,
          permission: LocationPermission.deniedForever,
        );

        final result = await LocationService.checkPermissionStatus();
        expect(result, LocationPermissionStatus.deniedForever);
      });

      test('returns granted when permission is granted', () async {
        setUpGeolocator(
          serviceEnabled: true,
          permission: LocationPermission.always,
        );

        final result = await LocationService.checkPermissionStatus();
        expect(result, LocationPermissionStatus.granted);
      });
    });

    group('getCurrentLocation', () {
      final position = Position(
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      setUp(() {
        mockGeolocatorPlatform = MockGeolocatorPlatform.mockPosition(position);
        GeolocatorPlatform.instance = mockGeolocatorPlatform;
      });

      test('returns LatLng with correct coordinates', () async {
        final locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high
      );

        when(mockGeolocatorPlatform.getCurrentPosition(
          locationSettings: locationSettings,
        )).thenAnswer((_) async => position);

        final result = await LocationService.getCurrentLocation();
        expect(result, isA<LatLng>());
        expect(result!.latitude, 10.0);
        expect(result.longitude, 20.0);
      });
    });
  });
}
