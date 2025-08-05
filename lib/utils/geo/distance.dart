import 'package:latlong2/latlong.dart';

class DistanceUtils {
  static double inMiles(LatLng a, LatLng b) {
    return const Distance().as(LengthUnit.Mile, a, b);
  }

  static bool isWithinMiles(LatLng a, LatLng b, double miles) {
    return inMiles(a, b) <= miles;
  }
}
