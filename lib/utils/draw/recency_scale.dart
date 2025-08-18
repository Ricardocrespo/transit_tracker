import 'package:flutter/material.dart';
import 'package:transit_tracker/models/report.dart';

class RecencyScale {
  final DateTime _now;
  late final double _minAge;
  late final double _denom;

  RecencyScale._(this._now, this._minAge, this._denom);

  factory RecencyScale.fromReports(List<Report> reports, {DateTime? now}) {
    final n = now ?? DateTime.now().toUtc();

    final ages = reports // Compute age in minutes for each report
        .map((r) => n.difference(r.timestamp).inMinutes.toDouble())
        .toList();
    if (ages.isEmpty) { // If there are no ages (no reports), return a scale that won't fail
      return RecencyScale._(n, 0, 1);
    }

    double minAge = ages.first, maxAge = ages.first;
    // Iterate over ages to find min/max
    for (final a in ages) {
      if (a < minAge) minAge = a;
      if (a > maxAge) maxAge = a;
    }
    // If all reports are from the same minute, avoid division by zero
    // This will be used as the denominator to normalize all ages into [0.0, 1.0]
    final span = (maxAge - minAge).abs();
    return RecencyScale._(n, minAge, span == 0 ? 1.0 : span);
  }

  /// Maps a specific timestamp to a color along the red→purple gradient.
  /// Newest timestamps (age near _minAge) are red, oldest (age near _minAge + _denom) are purple.
  Color colorFor(DateTime ts) {
    final age = _now.difference(ts).inMinutes.toDouble(); // Age in minutes
    // Subtract _minAge so the youngest report has t = 0.0
    // Divide by _denom to spread ages evenly across the gradient range
    // Clamp to [0.0, 1.0] so outliers don't break the color mapping.
    final t = ((age - _minAge) / _denom).clamp(0.0, 1.0);
    final hue = 0 + 260 * t;
    return HSVColor.fromAHSV(1, hue, 0.9, 0.95).toColor();
  }

  /// Generates a discrete set of colors for a legend bar,
  /// going from oldest (purple) to newest (red) when displayed left-to-right.
  List<Color> legendGradient({int steps = 6}) {
    return List<Color>.generate(
        steps, (i) => HSVColor.fromAHSV(1, 260 * i / (steps - 1), 0.9, 0.95).toColor())
      .reversed
      .toList(); // newest on left
  }
}
