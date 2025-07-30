import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:transit_tracker/models/zone.dart';

Future<List<Zone>> loadZonesFromJson() async {
  final String jsonString = await rootBundle.loadString('assets/config/zones.json');
  final List<dynamic> decoded = jsonDecode(jsonString);
  return decoded.map((e) => Zone.fromJson(e)).toList();
}
