import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:transit_tracker/models/point.dart';

Future<List<Point>> loadPortsFromJson() async {
  final String jsonString = await rootBundle.loadString('assets/config/points.json');
  final List<dynamic> decoded = jsonDecode(jsonString);
  return decoded.map((e) => Point.fromJson(e)).toList();
}
