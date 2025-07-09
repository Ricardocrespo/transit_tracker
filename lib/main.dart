import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/map_screen.dart';

void main() async {
  await dotenv.load();
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