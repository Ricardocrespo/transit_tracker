import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapContainer extends StatelessWidget {
  final LatLng center;
  final LatLngBounds? bounds;
  final VoidCallback onMapReady;
  final TileLayer tileLayer;
  final List<Widget> additionalLayers;
  final MapController mapController;

  const MapContainer({
    super.key,
    required this.center,
    required this.bounds,
    required this.onMapReady,
    required this.tileLayer,
    required this.additionalLayers,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
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
        RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'MapTiler © OpenStreetMap contributors',
                onTap: () => launchUrl(
                  Uri.parse('https://www.openstreetmap.org/copyright'),
                ),
              ),
            ],
          )
      ],
    );
  }
}
