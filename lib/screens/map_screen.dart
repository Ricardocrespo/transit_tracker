// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/services/cached_tile_provider.dart';

class MapScreen extends StatelessWidget {
  final LatLng center;
  final LatLngBounds? bounds;
  final VoidCallback onMapReady;

  const MapScreen({
    super.key,
    required this.center,
    required this.bounds,
    required this.onMapReady,
  });

  @override
  Widget build(BuildContext context) {
    final mapController = MapController(); // Fresh controller per mount

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 16,
        minZoom: 16,
        maxZoom: 18,
        cameraConstraint: bounds != null
            ? CameraConstraint.contain(bounds: bounds!)
            : CameraConstraint.unconstrained(),
        onMapReady: onMapReady,
      ),
      children: [
        TileLayer(
          urlTemplate:
              '${const String.fromEnvironment('MAP_BASE_URL', defaultValue: 'http://10.0.2.2:3000')}/tiles/{z}/{x}/{y}',
          tileProvider: CachedTileProvider(),
          userAgentPackageName: 'com.transittracker.app',
        ),
      ],
    );
  }
}
