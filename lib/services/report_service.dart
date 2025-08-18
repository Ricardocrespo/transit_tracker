import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:transit_tracker/models/report.dart';
import 'package:transit_tracker/models/report_submission.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportService {
  static final url = Uri.parse(dotenv.env['MAP_API_URL'] ?? 'http://10.0.2.2:3000/api/');

  static const _assetPath = 'assets/mock_reports.json';

  Future<List<Report>> fetchReports() async {
    final s = await rootBundle.loadString(_assetPath);
    final List data = json.decode(s);
    final reports = data.map((e) => Report.fromJson(e)).toList().cast<Report>();
    return reports;
  }

  static Future<http.Response> reportUserArrival(ReportSubmission report) async {
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(report.toJson()),
    );
  }
}
