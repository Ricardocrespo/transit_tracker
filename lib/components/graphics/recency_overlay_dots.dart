import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:transit_tracker/utils/draw/dot_sizer.dart';
import 'package:transit_tracker/utils/draw/geo_cluster_cell.dart';
import 'package:transit_tracker/utils/draw/recency_scale.dart';
import 'package:transit_tracker/utils/geo/mock_reports.dart';

class RecencyDotsOverlay extends StatefulWidget {
  final double clusterRadiusMeters;
  final double minRadiusPx;
  final double maxRadiusPx;
  final double borderOpacity;

  const RecencyDotsOverlay({
    super.key,
    this.clusterRadiusMeters = 20,
    this.minRadiusPx = 6,
    this.maxRadiusPx = 18,
    this.borderOpacity = 0.25,
  });

  @override
  State<RecencyDotsOverlay> createState() => _RecencyDotsOverlayState();
}

class _RecencyDotsOverlayState extends State<RecencyDotsOverlay> {
  final _repo = ReportsLoader();
  Timer? _minuteTicker;

  List<CircleMarker> _markers = const [];

  @override
  void initState() {
    super.initState();
    _refresh();
    _minuteTicker = Timer.periodic(const Duration(minutes: 1), (_) => _refreshColorsOnly());
  }

  @override
  void dispose() {
    _minuteTicker?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    final reports = await _repo.getActiveReportsShifted();
    final clusterer = GeoGridCluster(cellMeters: widget.clusterRadiusMeters);
    final clusters = clusterer.cluster(reports);

    // sort older→newer so newer draws on top
    clusters.sort((a, b) => a.latestTimestamp.compareTo(b.latestTimestamp));

    final scale = RecencyScale();
    final sizer = DotSizer(minR: widget.minRadiusPx, maxR: widget.maxRadiusPx);

    _markers = clusters.map((c) {
     return CircleMarker(
      point: LatLng(c.centerLat, c.centerLng),
      radius: sizer.radiusForCount(c.count),
      color: scale.colorFor(c.latestTimestamp).withValues(alpha: 0.6),
      // Border: present when color != null and borderStrokeWidth > 0
      borderColor: Color.fromRGBO(0, 0, 0, widget.borderOpacity), // replaces withOpacity
      borderStrokeWidth: 1.2,
    );
    }).toList();

    if (mounted) setState(() {});
  }

  void _refreshColorsOnly() {
    if (_markers.isEmpty) return;
    // Just rebuild; RecencyScale computes color using now().
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (_markers.isEmpty) return const SizedBox.shrink();
    return CircleLayer(circles: _markers);
  }
}
