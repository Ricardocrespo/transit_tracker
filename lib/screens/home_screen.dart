import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/app.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/models/zone.dart';
import 'package:transit_tracker/screens/map_screen.dart';
import 'package:transit_tracker/screens/settings_screen.dart';
import 'package:transit_tracker/utils/app_localizations.dart';
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
  LatLng? _currentPosition;

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

  Future<bool> _checkAndRequestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('location.disabled'))),
        );
      }
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).translate('location.permanentlyDenied'))),
        );
      }
      return false;
    }
    return true;
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'report_arrival',
                  onPressed: () async {
                    final hasPermission = await _checkAndRequestPermission();
                    if (!hasPermission || !mounted) return;

                    final position = await Geolocator.getCurrentPosition();
                    _currentPosition = LatLng(
                      position.latitude,
                      position.longitude,
                    );

                    final distance = const Distance().as(
                      LengthUnit.Mile,
                      selected.location,
                      _currentPosition!,
                    );

                    if (distance > 2.0) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context).translate('location.outOfRange'),
                          ),
                        ),
                      );
                      return;
                    }

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        
                        content: Text(
                          AppLocalizations.of(context).translate('location.reported'),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add_location_alt),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    mini: true,
                    heroTag: 'navigation_drawer',
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
