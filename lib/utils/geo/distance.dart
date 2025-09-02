import 'package:latlong2/latlong.dart';

class DistanceUtils {
  static double inKilometers(LatLng a, LatLng b) {
    return const Distance().as(LengthUnit.Kilometer, a, b);
  }

  static bool isWithinKilometers(LatLng a, LatLng b, double km) {
    return inKilometers(a, b) <= km;
  }
}
