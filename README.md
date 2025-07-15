# Transit Tracker

A cross-platform Flutter app for visualizing transit activity using map tiles. Designed for predictable, constrained use cases where tile regions are known in advance and caching can be heavily optimized.

## Features

- Displays an interactive map focused on defined regions  
- Restricts panning and zooming to a bounded area  
- Uses a local proxy service to fetch and cache tiles efficiently  
- Supports development and production build flavors  
- Ready for future support of multilingual UI  

## Architecture

This app delegates tile fetching to a separate proxy service: [tile-proxy](https://github.com/Ricardocrespo/tile-proxy).  
That service caches tiles on disk and prevents unnecessary requests to third-party providers. The Flutter app also uses in-app caching to reduce image reloads and improve performance.

Both caches are intentional. The proxy ensures server-side control and bandwidth reduction; the in-app cache handles fast rendering and offline resilience.

## Setup

1. **Install Flutter**  
   Follow instructions at [flutter.dev](https://flutter.dev/docs/get-started/install).

2. **Clone this repository**

   ```bash
   git clone https://github.com/Ricardocrespo/transit_tracker
   cd transit_tracker
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

4. **Set up flavors**  
   The project uses [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr) to manage environment-based configurations.

   Available flavors:
   - `dev`: local tile proxy (`http://10.0.2.2:3000/tiles`)
   - `prod`: production tile proxy for store app launch

5. **Run the app**

   - Development build:

     ```bash
     ./run.sh dev
     ```

   - Production build:

     ```bash
     ./run.sh prod
     ```

## Configuration

Environment variables are defined per flavor in the `pubspec.yaml` under the `flavorizr` section. These include the base tile URL and application ID. Secrets like production tile endpoints should be manually excluded before committing.

## Debugging with VS Code

To debug in VS Code, add the following to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--flavor", "dev",
        "--dart-define=flavor=dev"
      ]
    },
    {
      "name": "Flutter Prod",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--flavor", "prod",
        "--dart-define=flavor=prod"
      ]
    }
  ]
}
```

## Testing

### Unit Tests

A basic example is included to test tile caching behavior using `mockito`.

Run all tests:

```bash
flutter test
```

Planned expansions include integration tests for map interactions and flavor-specific configuration validation.
