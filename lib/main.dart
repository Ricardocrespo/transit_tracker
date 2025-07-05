import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const TransitTracker());
}

class TransitTracker extends StatelessWidget {
  const TransitTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransitTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}