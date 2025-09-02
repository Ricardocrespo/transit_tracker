import 'dart:ui' show Color;

/// Palette (tweak as you wish). Use opaque colors; set transparency at call site.
abstract class Palette {
  static const red     = Color(0xFFE53935); // 0–5
  static const orange  = Color(0xFFF57C00); // 5–15
  static const yellow  = Color(0xFFFBC02D); // 15–25
  static const green   = Color(0xFF43A047); // 25–35
  static const blue    = Color(0xFF1E88E5); // 35–45
  static const purple  = Color(0xFF8E24AA); // 45-55
  static const indigo = Color(0xFF3949AB); // 55m+
}