import 'dart:async';
import 'dart:ui' as ui;
import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:transit_tracker/services/cached_tile_provider.dart';

import 'cached_tile_provider_test.mocks.dart';

// Mocks
//class MockCacheManager extends Mock implements BaseCacheManager {}

@GenerateMocks([BaseCacheManager, File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CachedTileProvider', () {
    late CachedTileProvider provider;

    setUp(() {
      provider = CachedTileProvider();
    });

    test('throws ArgumentError if urlTemplate is null', () {
      final options = TileLayer(urlTemplate: null);
      final coordinates = TileCoordinates(1, 2, 3);

      expect(() => provider.getImage(coordinates, options), throwsArgumentError);
    });

    test('returns NetworkImageWithCache with correct url', () {
      final options = TileLayer(urlTemplate: 'https://example.com/{z}/{x}/{y}.png');
      final coordinates = TileCoordinates(1, 2, 3);

      final imageProvider = provider.getImage(coordinates, options);

      expect(imageProvider, isA<NetworkImageWithCache>());
      final networkImage = imageProvider as NetworkImageWithCache;
      expect(networkImage.url, 'https://example.com/3/1/2.png');
    });
  });

  group('NetworkImageWithCache', () {
    late MockBaseCacheManager mockCacheManager;
    late NetworkImageWithCache imageProvider;
    late MockFile mockFile;
    late String testUrl;

    setUp(() {
      testUrl = 'https://example.com/3/1/2.png';
      mockCacheManager = MockBaseCacheManager();
      imageProvider = NetworkImageWithCache(testUrl, mockCacheManager);
      mockFile = MockFile();
    });

    test('obtainKey returns itself', () async {
      final key = await imageProvider.obtainKey(const ImageConfiguration());
      expect(key, imageProvider);
    });

    test('loadImage override calls cacheManager.getSingleFile and reads bytes', () async {
      final fakeBytes = Uint8List.fromList([1, 2, 3, 4]);
      when(mockCacheManager.getSingleFile(testUrl)).thenAnswer((_) async => mockFile);
      when(mockFile.readAsBytes()).thenAnswer((_) async => fakeBytes);

      // The decode callback is required by loadImage.
      Future<ui.Codec> fakeDecode(
        ui.ImmutableBuffer buffer, {
        ui.TargetImageSizeCallback? getTargetSize,
      }) async {
        // Optionally convert buffer to bytes for assertions
        // final bytes = await buffer.toUint8List(); // if available in your Flutter version
        throw UnimplementedError();
      }

      final completer = imageProvider.loadImage(imageProvider, fakeDecode);

      // Listen for errors on the stream
      final errorCompleter = Completer<void>();
      completer.addListener(ImageStreamListener(
        (image, sync) {},
        onError: (error, stackTrace) {
          errorCompleter.complete();
          expect(error, isA<UnimplementedError>());
        },
      ));

      // Call loadImage and expect it to eventually throw (because of fakeDecode)
      await errorCompleter.future;

      verify(mockCacheManager.getSingleFile(testUrl)).called(1);
      verify(mockFile.readAsBytes()).called(1);
    });
    
  });
}
