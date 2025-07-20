// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/utils/bounds.dart';
import 'package:transit_tracker/utils/points_loader.dart';
import 'package:transit_tracker/screens/map_screen.dart';
import 'package:transit_tracker/screens/nav_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Point>> _pointsFuture;
  late Point _selectedPoint;

  @override
  void initState() {
    super.initState();
    _pointsFuture = loadPortsFromJson().then((points) {
      _selectedPoint = points.first;
      return points;
    });
  }

  void _onSelect(Point point) {
    setState(() {
      _selectedPoint = point;
    });
  }

  void _onMapReady() {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Point>>(
      future: _pointsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final ports = snapshot.data!;

        return Scaffold(
          drawer: NavDrawer(
            ports: ports,
            selected: _selectedPoint,
            onSelect: _onSelect,
          ),
          body: Stack(
            children: [
              MapScreen(
                key: ValueKey(_selectedPoint.id),
                center: _selectedPoint.location,
                bounds: expandBoundsAround(_selectedPoint.location, meters: 1000),
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
      },
    );
  }
}
