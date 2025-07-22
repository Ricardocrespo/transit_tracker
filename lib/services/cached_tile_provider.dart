import 'dart:math';
import 'dart:math' as math;
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
      httpClient: http.Client(),
    );
  }
}

class TileImageProvider extends ImageProvider<TileImageProvider> {
  final String assetPath;
  final String fallbackUrl;
  final BaseCacheManager cacheManager;
  final http.Client httpClient;

  const TileImageProvider({
    required this.assetPath,
    required this.fallbackUrl,
    required this.cacheManager,
    required this.httpClient,
  });

  @override
  Future<TileImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    TileImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  /*
  * Attempts to load the image from the asset first, and if it fails,
  * it will try to fetch it from the cache manager or HTTP fallback.
  * If the asset is not found, it will retry fetching from the cache
  * up to 3 times with exponential backoff and jitter.
  * If all retries fail, it will fetch the image from the HTTP URL.
  * Returns a valid image if successful, or throws an error if all attempts fail.
  *
  * @param key The TileImageProvider key containing the asset path and fallback URL.
  * @param decode The callback to decode the image bytes into a codec.
  * @return A Future that resolves to a ui.Codec for the image.
  */
  Future<ui.Codec> _loadAsync(TileImageProvider key, ImageDecoderCallback decode) async {
    Uint8List bytes;

    try {
      // Attempt to load from local asset
      final assetBytes = await rootBundle.load(key.assetPath);
      bytes = assetBytes.buffer.asUint8List();
    } catch (_) {
      // Asset not found, fallback to cache manager or fetched tile
      bytes = await _fetchWithRetry(key.fallbackUrl);
    }

    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  /*
  * Fetches the image bytes from the cache manager with retry logic.
  * If the cache fetch fails, it will retry up to 3 times with exponential backoff and jitter.
  * If all retries fail, it will fetch the image from the HTTP URL.
  * @param url The URL to fetch the image from.
  * @param retries The number of retry attempts (default is 3).
  * @return A Future that resolves to the image bytes.
  */
  Future<Uint8List> _fetchWithRetry(String url, {int retries = 3}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        final bytes = await _tryFetchFromCache(url);
        if (bytes != null && bytes.isNotEmpty) return bytes;
      } catch (e) {
        debugPrint('Cache fetch failed on attempt $attempt: $e');
      }
      await _applyBackoffWithJitter(attempt);
    }
    return await _fetchFromHttpWithRetry(url);
  }

  Future<Uint8List?> _tryFetchFromCache(String url) async {
    final file = await cacheManager.getSingleFile(url);
    return file.readAsBytes();
  }

  Future<void> _applyBackoffWithJitter(int attempt) async {
    final random = Random();
    final baseDelay = Duration(seconds: math.pow(2, attempt).toInt()); // Exponential backoff
    // Add jitter to avoid thundering herd problem
    final jitter = Duration(milliseconds: random.nextInt(1000));
    final totalDelay = baseDelay + jitter;

    debugPrint('Retry $attempt failed. Delaying ${totalDelay.inMilliseconds}ms before next attempt...');

    await Future.delayed(totalDelay);
  }

  Future<Uint8List> _fetchFromHttpWithRetry(String url, {int maxAttempts = 3}) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final response = await httpClient.get(Uri.parse(url));
        if (response.statusCode == 429) {
          debugPrint('Received 429. Delaying 5s before final retry...');
          await Future.delayed(const Duration(seconds: 5));
          return await _fetchFromHttpWithRetry(url); 
        } else if (response.statusCode != 200) {
          throw Exception('Tile fetch failed with status ${response.statusCode}: $url');
        }
        return response.bodyBytes;
      } catch (e) {
        debugPrint('HTTP fetch failed on attempt $attempt: $e');
        if (attempt == maxAttempts - 1) rethrow;
      }
    }
    throw Exception('HTTP fetch failed after $maxAttempts attempts: $url');
  }

}
