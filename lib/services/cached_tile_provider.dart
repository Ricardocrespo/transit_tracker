import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/widgets.dart';

class CachedTileProvider extends TileProvider {
  final _cache = DefaultCacheManager();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final urlTemplate = options.urlTemplate;
    if (urlTemplate == null) {
      throw ArgumentError('urlTemplate cannot be null');
    }
    final url = urlTemplate
        .replaceAll('{z}', coordinates.z.round().toString())
        .replaceAll('{x}', coordinates.x.round().toString())
        .replaceAll('{y}', coordinates.y.round().toString());

    return NetworkImageWithCache(url, _cache);
  }
}

class NetworkImageWithCache extends ImageProvider<NetworkImageWithCache> {
  final String url;
  final BaseCacheManager cacheManager;

  NetworkImageWithCache(this.url, this.cacheManager);

  @override
  Future<NetworkImageWithCache> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<NetworkImageWithCache>(this);

  @override
  ImageStreamCompleter loadImage(NetworkImageWithCache key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(NetworkImageWithCache key, ImageDecoderCallback decode) async {
    final file = await cacheManager.getSingleFile(url);
    final bytes = await file.readAsBytes();
    final buffer = await ui.ImmutableBuffer.fromUint8List(Uint8List.fromList(bytes));
    return decode(buffer);
  }
}
