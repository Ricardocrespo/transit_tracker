import 'dart:ui' show Color;

class Bucket {
  final double minInclusive;
  final double? maxExclusive; // null = open ended (60m+)
  final String key;           // i18n key like "legend.0_5"
  final Color color;

  const Bucket({
    required this.minInclusive,
    required this.maxExclusive,
    required this.key,
    required this.color,
  });

  bool contains(double minutes) {
    final geMin = minutes >= minInclusive;
    final ltMax = maxExclusive == null ? true : minutes < maxExclusive!;
    return geMin && ltMax;
  }
}