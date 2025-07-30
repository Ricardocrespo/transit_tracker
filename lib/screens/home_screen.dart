import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transit_tracker/app.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/models/zone.dart';
import 'package:transit_tracker/screens/map_screen.dart';
import 'package:transit_tracker/screens/settings_screen.dart';
import 'package:transit_tracker/utils/bounds.dart';
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
    _loadZonesAndPoint();
  }

  Future<void> _loadZonesAndPoint() async {
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

    // Save fallback in case the ID wasn’t already stored
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

  void _onMapReady() {
    // Any actions once map fully loads
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedPoint == null || zones.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final selected = _selectedPoint!;
    return Scaffold(
      drawer: NavDrawer(
        zones: zones,
        selected: selected,
        onSelect: _onSelect,
        onSettingsTap: _onSettingsTap,
      ),
      body: Stack(
        children: [
          MapScreen(
            key: ValueKey(selected.id),
            center: selected.location,
            bounds: expandBoundsAround(selected.location, meters: 1000),
            onMapReady: _onMapReady,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    mini: true,
                    child: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
