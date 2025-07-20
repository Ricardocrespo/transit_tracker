import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class CachedTileProvider extends TileProvider {
  final _cache = DefaultCacheManager();
  final String assetRoot;

  CachedTileProvider({this.assetRoot = 'assets/tiles'});

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final z = coordinates.z.round();
    final x = coordinates.x.round();
    final y = coordinates.y.round();

    final assetPath = '$assetRoot/$z/$x/$y.png';

    return TileImageProvider(
      assetPath: assetPath,
      fallbackUrl: options.urlTemplate!
          .replaceAll('{z}', '$z')
          .replaceAll('{x}', '$x')
          .replaceAll('{y}', '$y'),
      cacheManager: _cache,
    );
  }
}

class TileImageProvider extends ImageProvider<TileImageProvider> {
  final String assetPath;
  final String fallbackUrl;
  final BaseCacheManager cacheManager;

  const TileImageProvider({
    required this.assetPath,
    required this.fallbackUrl,
    required this.cacheManager,
  });

  @override
  Future<TileImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(TileImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(TileImageProvider key, ImageDecoderCallback decode) async {
    Uint8List bytes;

    try {
      // Attempt to load from local asset
      final assetBytes = await rootBundle.load(key.assetPath);
      bytes = assetBytes.buffer.asUint8List();
    } catch (_) {
      // Asset not found, fallback to cached or fetched tile
      bytes = await _fetchWithRetry(key.fallbackUrl);
    }

    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  Future<Uint8List> _fetchWithRetry(String url, {int retries = 3}) async {
    int attempt = 0;
    while (attempt < retries) {
      final file = await cacheManager.getSingleFile(url);
      final bytes = await file.readAsBytes();
      if (bytes.isNotEmpty) return bytes;

      await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      attempt++;
    }

    // As fallback, try fetching manually with http to inspect 429
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 429) {
      await Future.delayed(const Duration(seconds: 5));
      return _fetchWithRetry(url, retries: 1); // one final attempt
    } else if (response.statusCode != 200) {
      throw Exception('Failed to load tile: $url (status ${response.statusCode})');
    }

    return response.bodyBytes;
  }
}
