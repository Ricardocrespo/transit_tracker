import 'package:shared_preferences/shared_preferences.dart';

class PointPreferences {
  static const _key = 'selected_point_id';

  static Future<void> savePoint(int pointId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, pointId);
  }

  static Future<int?> loadPoint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key);
  }
}
