import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;
import 'package:transit_tracker/models/reporting/report.dart';
import 'package:transit_tracker/services/report_service.dart';

class ReportsLoader {

  late ReportService _service;

  ReportsLoader(){ _service = ReportService();}

  static Future<List<Report>> loadFromAssets(String path) async {
    final s = await rootBundle.loadString(path);
    final List data = json.decode(s);
    final reports = data.map((e) => Report.fromJson(e)).toList().cast<Report>();
    reports.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // oldest -> newest
    return reports;
  }

  Future<List<Report>> getActiveReports() async {
    var reports = await _service.fetchReports();
    if (reports.isEmpty) return reports;

    reports.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Shift static mocks forward so newest ≈ now - 5m.
    final now = DateTime.now().toUtc();
    final newestTs = reports.last.timestamp;
    final shift = now.subtract(const Duration(minutes: 5)).difference(newestTs);

    // Only shift if data is older than ~1m (avoids jitter if you later use live data)
    if (shift.inSeconds.abs() > 60) {
      reports = reports
          .map((r) => r.copyWith(timestamp: r.timestamp.add(shift)))
          .toList();
    }

    return reports;
  }

  Future<List<Report>> getActiveReportsShifted() async {
    var reports = await _service.fetchReports();
    if (reports.isEmpty) return reports;
    reports.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final now = DateTime.now().toUtc();
    final newest = reports.last.timestamp;
    final shift = now.subtract(const Duration(minutes: 5)).difference(newest);

    if (shift.inSeconds.abs() > 60) {
      reports = reports
          .map((r) => r.copyWith(timestamp: r.timestamp.add(shift)))
          .toList();
    }
    return reports;
  }
}


