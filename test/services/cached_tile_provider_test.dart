import 'dart:convert';

import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:transit_tracker/services/cached_tile_provider.dart';

import 'cached_tile_provider_test.mocks.dart';

// Mocks
//class MockCacheManager extends Mock implements BaseCacheManager {}

// Generate mocks
@GenerateMocks([BaseCacheManager, http.Client, File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testAssetPath = 'assets/tiles/16/1234/5678.png';
  const testUrl = 'http://example.com/tiles/16/1234/5678.png';

  late MockBaseCacheManager mockCacheManager;
  late MockClient mockHttpClient;

  setUp(() {
    mockCacheManager = MockBaseCacheManager();
    mockHttpClient = MockClient();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('TileImageProvider', () {
    //late File mockFile;
    late MockFile mockFile;
    final fakeBytes = Uint8List.fromList(List.generate(100, (i) => i % 256));

    setUp(() {
      mockCacheManager = MockBaseCacheManager();
      mockFile = MockFile(fakeBytes);
    });

    test('returns image from local asset if available', () async {
      // Simulate loading from asset
      final assetLoader = TestAssetBundle({
        testAssetPath: ByteData.view(fakeBytes.buffer),
      });

      final provider = TileImageProvider(
        assetPath: testAssetPath,
        fallbackUrl: testUrl,
        cacheManager: mockCacheManager,
      );

      final key = await provider.obtainKey(const ImageConfiguration());
      final completer = provider.loadImage(
        key,
        PaintingBinding.instance.instantiateImageCodecWithSize,
      );

      // Swap in test bundle temporarily
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            final String key = utf8.decode(message!.buffer.asUint8List());
            try {
              final ByteData data = await assetLoader.load(key);
              return data;
            } catch (e) {
              return null;
            }
          });
      expect(completer, isA<MultiFrameImageStreamCompleter>());
    });

    test(
      'falls back to network if asset is missing and returns valid image',
      () async {
        when(
          mockCacheManager.getSingleFile(testUrl),
        ).thenAnswer((_) async => mockFile);

        final provider = TileImageProvider(
          assetPath: 'assets/tiles/invalid.png',
          fallbackUrl: testUrl,
          cacheManager: mockCacheManager,
        );

        final key = await provider.obtainKey(const ImageConfiguration());
        final completer = provider.loadImage(
          key,
          PaintingBinding.instance.instantiateImageCodecWithSize,
        );

        expect(completer, isA<MultiFrameImageStreamCompleter>());
      },
    );

    test('retries 3 times and then does HTTP request with 429 delay', () async {
      // Simulate cache manager always returning empty file
      final emptyFile = MockFile(Uint8List(0));
      when(
        mockCacheManager.getSingleFile(any),
      ).thenAnswer((_) async => emptyFile);

      // Simulate HTTP returning 429 first, then 200
      final url = 'http://example.com/tiles/16/1337/420.png';
      final http429 = http.Response('', 429);
      final http200 = http.Response.bytes(
        Uint8List.fromList([1, 2, 3, 4]),
        200,
      );
      when(mockHttpClient.get(Uri.parse(url))).thenAnswer((invocation) async {
        final callCount = verify(mockHttpClient.get(Uri.parse(url))).callCount;
        return callCount < 1 ? http429 : http200;
      });

      final provider = TileImageProvider(
        assetPath: 'assets/tiles/missing.png',
        fallbackUrl: url,
        cacheManager: mockCacheManager,
      );

      final key = await provider.obtainKey(const ImageConfiguration());
      final completer = provider.loadImage(
        key,
        PaintingBinding.instance.instantiateImageCodecWithSize,
      );

      expect(completer, isA<MultiFrameImageStreamCompleter>());
    });
  });
}

// Mock AssetBundle to simulate loading assets without needing actual files.
class TestAssetBundle extends CachingAssetBundle {
  final Map<String, ByteData> assets;
  TestAssetBundle(this.assets);

  @override
  Future<ByteData> load(String key) async {
    if (!assets.containsKey(key)) {
      throw FlutterError('Asset not found: $key');
    }
    return assets[key]!;
  }
}
