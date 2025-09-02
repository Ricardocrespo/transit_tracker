import 'dart:math' as math;
import 'package:transit_tracker/models/reporting/report.dart';

/// Output container for a clustered group of nearby reports.
class ClusterCell {
  ClusterCell({
    required this.centerLat,
    required this.centerLng,
    required this.count,
    required this.latestTimestamp,
  });

  double centerLat;          // running-mean latitude of all points in this cell
  double centerLng;          // running-mean longitude of all points in this cell
  int count;                 // number of merged reports
  DateTime latestTimestamp;  // most recent timestamp among merged reports
}

/// Grid-based spatial clusterer (fast O(n)):
/// - Snaps reports to a meter-sized grid cell
/// - Aggregates points per cell
/// - Maintains running center and latest timestamp per cell
class GeoGridCluster {
  GeoGridCluster({this.cellMeters = 20});

  /// Size of each grid cell in meters (controls clustering resolution).
  final double cellMeters;

  // ---- cached scale factors (computed from the first report's latitude) ----
  double? _mPerDegLat;
  double? _mPerDegLng;

  /// Main entry: cluster a list of reports into grid cells.
  List<ClusterCell> cluster(List<Report> reports) {
    if (reports.isEmpty) return const [];

    _ensureScaleForLatitude(reports.first.lat);

    final Map<String, ClusterCell> cells = {};

    for (final r in reports) {
      final key = _gridKey(r.lat, r.lng);
      final existing = cells[key];
      if (existing == null) {
        cells[key] = ClusterCell(
          centerLat: r.lat,
          centerLng: r.lng,
          count: 1,
          latestTimestamp: r.timestamp,
        );
      } else {
        _mergeIntoCell(existing, r);
      }
    }

    return cells.values.toList();
  }

  /// Compute meters-per-degree scale for this latitude once per run.
  void _ensureScaleForLatitude(double lat) {
    if (_mPerDegLat != null && _mPerDegLng != null) return;
    const metersPerDegLat = 111_320.0; // ~constant
    final cosLat = math.cos(lat.abs() * math.pi / 180.0);
    _mPerDegLat = metersPerDegLat;
    _mPerDegLng = metersPerDegLat * cosLat;
  }

  /// Convert (lat, lng) to an integer grid key at the configured cell size.
  String _gridKey(double lat, double lng) {
    // scale degrees → meters, then divide by cell size to get grid coords
    final x = (lng * _mPerDegLng!) / cellMeters; // horizontal index
    final y = (lat * _mPerDegLat!) / cellMeters; // vertical index
    return '${x.floor()}_${y.floor()}';
  }

  /// Merge a report into an existing cell:
  /// - update running mean for center
  /// - increment count
  /// - track the most recent timestamp
  void _mergeIntoCell(ClusterCell cell, Report r) {
    final n1 = cell.count.toDouble(); // current population before merge
    cell.centerLat = (cell.centerLat * n1 + r.lat) / (n1 + 1);
    cell.centerLng = (cell.centerLng * n1 + r.lng) / (n1 + 1);
    cell.count += 1;
    if (r.timestamp.isAfter(cell.latestTimestamp)) {
      cell.latestTimestamp = r.timestamp;
    }
  }
}
