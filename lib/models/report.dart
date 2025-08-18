class Report {
  final DateTime timestamp;
  final double lat;
  final double lng;

  Report({
    required this.timestamp,
    required this.lat,
    required this.lng,
  });

  factory Report.fromJson(Map<String, dynamic> j) => Report(
        timestamp: DateTime.parse(j['timestamp']).toUtc(),
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
      );

  Report copyWith({DateTime? timestamp, double? lat, double? lng}) => Report(
      timestamp: timestamp ?? this.timestamp,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
}
