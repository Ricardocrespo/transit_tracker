import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transit_tracker/models/report.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportService {
  static final url = Uri.parse(dotenv.env['MAP_API_URL'] ?? 'http://10.0.2.2:3000/api/');

  static Future<http.Response> reportUserArrival(Report report) async {  
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(report.toJson()),
    );
  }
}
