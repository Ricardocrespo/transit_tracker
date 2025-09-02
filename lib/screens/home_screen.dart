import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transit_tracker/app.dart';
import 'package:transit_tracker/models/location/point.dart';
import 'package:transit_tracker/models/location/zone.dart';
import 'package:transit_tracker/screens/map_screen.dart';
import 'package:transit_tracker/screens/settings_screen.dart';
import 'package:transit_tracker/utils/point_preferences.dart';
import './nav_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Zone> zones = [];
  Point? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _loadZonesAndStartingPoint();
  }

  Future<void> _loadZonesAndStartingPoint() async {
    final jsonString = await rootBundle.loadString('assets/config/zones.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final loadedZones = jsonData.map((z) => Zone.fromJson(z)).toList();
    final allPoints = loadedZones.expand((z) => z.points).toList();

    final savedId = await PointPreferences.loadPoint();
    final initialPoint = allPoints.firstWhere(
      (p) => p.id == savedId,
      orElse: () => allPoints.first,
    );

    setState(() {
      zones = loadedZones;
      _selectedPoint = initialPoint;
    });

    await PointPreferences.savePoint(initialPoint.id);
  }

  void _onSelect(Point point) {
    setState(() {
      _selectedPoint = point;
    });
    PointPreferences.savePoint(point.id);
  }

  void _onSettingsTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onLanguageChange: (locale) {
            App.of(context)?.setLocale(locale);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedPoint == null || zones.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      drawer: NavDrawer(
        zones: zones,
        selected: _selectedPoint!,
        onSelect: _onSelect,
        onSettingsTap: _onSettingsTap,
      ),
      body: MapScreen(selectedPoint: _selectedPoint!),
    );
  }
}
