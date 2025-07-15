import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/services/cached_tile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const LatLng crossingCenter = LatLng(31.759195054758752, -106.45245281786063);

  static const double mileInDegrees = 0.0145;
  
  static final mapApiKey = dotenv.env['MAP_API_KEY'];

  static final mapBaseUrl = dotenv.env['MAP_BASE_URL'];

  @override
  Widget build(BuildContext context) {
    if (mapBaseUrl == null) {
      throw StateError('MAP_BASE_URL must be set in the environment');
    }
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
            urlTemplate: '$mapBaseUrl/tiles/{z}/{x}/{y}',
            tileProvider: CachedTileProvider(),
            userAgentPackageName: 'com.transittracker.app',
          ),
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
      ),
    );
  }
}