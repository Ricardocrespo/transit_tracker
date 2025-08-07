import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:transit_tracker/components/floating_button.dart';
import 'package:transit_tracker/components/map_container.dart';
import 'package:transit_tracker/components/report_controller.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/services/cached_tile_provider.dart';
import 'package:transit_tracker/utils/geo/bounds.dart';


class MapScreen extends StatefulWidget {
  final Point selectedPoint;

  const MapScreen({super.key, required this.selectedPoint});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  void _onMapReady() {
    // Future: trigger heatmap rendering
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapContainer(
          key: ValueKey(widget.selectedPoint.id),
          center: widget.selectedPoint.location,
          bounds: expandBoundsAround(
            widget.selectedPoint.location,
            meters: 1000,
          ),
          onMapReady: _onMapReady,
          tileLayer: TileLayer(
            urlTemplate:
                '${const String.fromEnvironment('MAP_TILE_URL', defaultValue: 'http://10.0.2.2:3000/tiles/')}{z}/{x}/{y}',
            tileProvider: CachedTileProvider(),
            userAgentPackageName: 'com.transittracker.app',
          ),
          additionalLayers: const [],
        ),
        ReportController(selectedPoint: widget.selectedPoint),
        FloatingButton(
          alignment: Alignment.topLeft,
          heroTag: 'navigation_drawer',
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ],
    );
  }
}
