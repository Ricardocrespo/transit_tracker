import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapContainer extends StatelessWidget {
  final LatLng center;
  final LatLngBounds? bounds;
  final VoidCallback onMapReady;
  final TileLayer tileLayer;
  final List<Widget> additionalLayers;

  const MapContainer({
    super.key,
    required this.center,
    required this.bounds,
    required this.onMapReady,
    required this.tileLayer,
    required this.additionalLayers,
  });

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();

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
        tileLayer,
        ...additionalLayers,
      ],
    );
  }
}
