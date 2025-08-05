import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements GeolocatorPlatform {
  late Position mockPosition;

  MockGeolocatorPlatform() {
    mockPosition = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 0.0,
      speed: 0.0,
      speedAccuracy: 1.0,
      heading: 0.0,
      isMocked: true,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  MockGeolocatorPlatform.mockPosition(Position position) {
    mockPosition = position;
  }

  @override
  Future<LocationPermission> checkPermission() => super.noSuchMethod(
    Invocation.method(#checkPermission, []),
    returnValue: Future.value(LocationPermission.whileInUse),
  );

  @override
  Future<LocationPermission> requestPermission() => super.noSuchMethod(
    Invocation.method(#requestPermission, []),
    returnValue: Future.value(LocationPermission.whileInUse),
  );

  @override
  Future<bool> isLocationServiceEnabled() => super.noSuchMethod(
    Invocation.method(#isLocationServiceEnabled, []),
    returnValue: Future.value(true),
  );

  @override
  Future<Position> getLastKnownPosition({bool forceLocationManager = false}) =>
      Future.value(mockPosition);

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) =>
      super.noSuchMethod(
        Invocation.method(
          #getCurrentPosition,
          [],
          locationSettings != null
              ? {#locationSettings: locationSettings}
              : <Symbol, Object?>{},
        ),
        returnValue: Future.value(mockPosition),
      );

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return super.noSuchMethod(
      Invocation.method(#getServiceStatusStream, null),
      returnValue: Stream.value(ServiceStatus.enabled),
    );
  }

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    return super.noSuchMethod(
      Invocation.method(#getPositionStream, null, <Symbol, Object?>{
        #desiredAccuracy: locationSettings?.accuracy ?? LocationAccuracy.best,
        #distanceFilter: locationSettings?.distanceFilter ?? 0,
        #timeLimit: locationSettings?.timeLimit ?? 0,
      }),
      returnValue: Stream.value(mockPosition),
    );
  }

  @override
  Future<bool> openAppSettings() => Future.value(true);

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) => Future.value(LocationAccuracyStatus.reduced);

  @override
  Future<bool> openLocationSettings() => Future.value(true);

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) => 42;

  @override
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) => 42;
}
