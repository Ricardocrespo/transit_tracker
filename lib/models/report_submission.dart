class ReportSubmission {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final int zoneId;
  final int pointId;
  final String source;
  final String deviceId;      // hashed + salted
  final String platform;
  final String appVersion;
  final double? accuracy;     // optional, useful for filtering

  ReportSubmission({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.zoneId,
    required this.pointId,
    required this.source,
    required this.deviceId,
    required this.platform,
    required this.appVersion,
    this.accuracy,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'zoneId': zoneId,
    'pointId': pointId,
    'source': source,
    'deviceId': deviceId,
    'platform': platform,
    'appVersion': appVersion,
    if (accuracy != null) 'accuracy': accuracy,
  };
}
