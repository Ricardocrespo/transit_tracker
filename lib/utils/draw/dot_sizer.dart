import 'dart:math' as math;

class DotSizer {
  final double minR;
  final double maxR;

  DotSizer({this.minR = 6, this.maxR = 18});

  double radiusForCount(int n) {
    final k = (maxR - minR) / math.sqrt(9); // sublinear growth ~cap near n≈10
    final r = minR + k * math.sqrt(math.max(0, n - 1).toDouble());
    return r.clamp(minR, maxR);
  }
}
