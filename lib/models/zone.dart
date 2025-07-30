import 'point.dart';

class Zone {
  final int id;
  final List<Point> points;

  Zone({required this.id, required this.points});

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json['id'],
        points: (json['points'] as List)
            .map((p) => Point.fromJson(p))
            .toList(),
      );
}