import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const LatLng crossingCenter = LatLng(31.759195054758752, -106.45245281786063);

  static const double mileInDegrees = 0.0145;

  @override
  Widget build(BuildContext context) {
    final bounds = LatLngBounds(
      LatLng(crossingCenter.latitude - mileInDegrees, crossingCenter.longitude - mileInDegrees),
      LatLng(crossingCenter.latitude + mileInDegrees, crossingCenter.longitude + mileInDegrees),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transit Tracker'),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: crossingCenter,
          initialZoom: 16.0,
          minZoom: 16.0,
          maxZoom: 18.0,
          cameraConstraint: CameraConstraint.contain(bounds: bounds)
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.transittracker.mobile',
          ),
        ],
      ),
    );
  }
}