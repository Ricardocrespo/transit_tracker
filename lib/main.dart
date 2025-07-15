
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavors.dart';
import 'app.dart';

/* Main entry point for the Transit Tracker application.
 * It initializes the Flutter binding, loads the environment variables from asset files based on the app flavor,
 * and runs the app.
 *
 * Usage:
 * flutter run --flavor dev --dart-define=flavor=dev
 * flutter run --flavor prod --dart-define=flavor=prod
 */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String env = String.fromEnvironment('flavor');
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == env,
    orElse: () => Flavor.dev,
  );

  final assetEnvFile = 'assets/env/.env.${F.appFlavor.name}';
  await dotenv.load(fileName: assetEnvFile);

  runApp(const App());
}
