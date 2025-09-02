import 'package:flutter/material.dart';
import 'package:transit_tracker/models/graphics/bucket.dart';
import 'package:transit_tracker/models/graphics/palette.dart';

/// Fixed, discrete recency buckets and colors.
/// Newest (0–5m) is RED → Oldest (60m+) is PURPLE.
class RecencyScale {
  RecencyScale({DateTime? now}) : _now = (now ?? DateTime.now().toUtc());

  final DateTime _now;

  /// Buckets in minutes since `now`.
  /// We include 35–45 to keep a continuous rainbow.
  static const List<Bucket> _buckets = [
    Bucket(minInclusive: 0,  maxExclusive: 5,   key: 'legend.0_5',   color: Palette.red),
    Bucket(minInclusive: 5,  maxExclusive: 15,  key: 'legend.5_15',  color: Palette.orange),
    Bucket(minInclusive: 15, maxExclusive: 25,  key: 'legend.15_25', color: Palette.yellow),
    Bucket(minInclusive: 25, maxExclusive: 35,  key: 'legend.25_35', color: Palette.green),
    Bucket(minInclusive: 35, maxExclusive: 45,  key: 'legend.35_45', color: Palette.blue),
    Bucket(minInclusive: 45, maxExclusive: 55,  key: 'legend.45_55', color: Palette.purple),
    Bucket(minInclusive: 55, maxExclusive: null,key: 'legend.older', color: Palette.indigo), 
  ];

  /// Returns the bucket for a given timestamp.
  Bucket bucketFor(DateTime ts) {
    final ageMin = _now.difference(ts).inMinutes.toDouble();
    for (final b in _buckets) {
      if (b.contains(ageMin)) return b;
    }
    // Fallback (shouldn’t happen): treat as oldest.
    return _buckets.last;
  }

  /// Color for a timestamp using fixed buckets.
  Color colorFor(DateTime ts) => bucketFor(ts).color;

  /// Color for an age in minutes (if you already computed ages).
  Color colorForAgeMinutes(double minutes) {
    for (final b in _buckets) {
      if (b.contains(minutes)) return b.color;
    }
    return _buckets.last.color;
  }

  /// Legend colors in Newest → Oldest order.
  List<Color> legendColors() {
    return _buckets.map((b) => b.color).toList();
  }

  /// Legend i18n keys in the same order as [legendColors].
  List<String> legendKeys() {
    return _buckets.map((b) => b.key).toList();
  }
}
