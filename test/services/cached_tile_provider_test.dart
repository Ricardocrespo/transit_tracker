import 'dart:async';
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

@GenerateMocks([BaseCacheManager, http.Client, File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testAssetPath = 'assets/tiles/16/1234_5678.png';
  const testUrl = 'http://10.0.2.2:3000/tiles/16/1234_5678.png';

  late MockBaseCacheManager mockCacheManager;
  late MockClient mockHttpClient;
  late MockFile mockFile;
  final fakeBytes = Uint8List.fromList(List.generate(100, (i) => i % 256));

  setUp(() {
    mockCacheManager = MockBaseCacheManager();
    mockHttpClient = MockClient();
    mockFile = MockFile(fakeBytes);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('TileImageProvider', () {
    group('loadImage', () {
      test('loads image from local asset without fetching cache or network', () async {
        final assetLoader = TestAssetBundle({
          testAssetPath: ByteData.view(fakeBytes.buffer),
        });

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message,) async {
            final String key = utf8.decode(message!.buffer.asUint8List());
            try {
              final ByteData data = await assetLoader.load(key);
              return data;
            } catch (e) {
              return null;
            }
          });

        final provider = TileImageProvider(
          assetPath: testAssetPath,
          fallbackUrl: testUrl,
          cacheManager: mockCacheManager,
          httpClient: mockHttpClient,
        );
        when(mockCacheManager.getSingleFile(testUrl),).thenAnswer((_) async => mockFile);
        when(mockFile.readAsBytes()).thenAnswer((_) async => fakeBytes);

        final key = await provider.obtainKey(const ImageConfiguration());
        final completer = provider.loadImage(
          key,
          PaintingBinding.instance.instantiateImageCodecWithSize,
        );

        verifyNever(mockCacheManager.getSingleFile(any));
        verifyNever(mockHttpClient.get(any));
        expect(completer, isA<MultiFrameImageStreamCompleter>());
      });

      test('falls back to cache manager if local asset is missing and returns valid image', () async {
        when(mockCacheManager.getSingleFile(testUrl)).thenAnswer((_) async => mockFile);
        when(mockFile.readAsBytes()).thenAnswer((_) async => fakeBytes);

        final provider = TileImageProvider(
          assetPath: 'assets/tiles/invalid.png',
          fallbackUrl: testUrl,
          cacheManager: mockCacheManager,
          httpClient: mockHttpClient,
        );

        final key = await provider.obtainKey(const ImageConfiguration());
        final completer = provider.loadImage(
          key,
          PaintingBinding.instance.instantiateImageCodecWithSize,
        );

        verifyNever(mockHttpClient.get(any));
        expect(completer, isA<MultiFrameImageStreamCompleter>());
      });

      test('falls back to HTTP after cache retries and returns valid image', () async {
        final emptyFile = MockFile(Uint8List(0));
        when(emptyFile.readAsBytes()).thenAnswer((_) async => Uint8List(0));
        when(mockCacheManager.getSingleFile(testUrl)).thenAnswer((_) async => emptyFile);

        final fileBytes = (await rootBundle.load(
          'test/assets/tiles/16/1337_420.png',
        )).buffer.asUint8List();
        final http200 = http.Response.bytes(fileBytes, 200);
        when(
          mockHttpClient.get(Uri.parse(testUrl)),
        ).thenAnswer((_) async => http200);

        final provider = TileImageProvider(
          assetPath: 'assets/tiles/missing.png',
          fallbackUrl: testUrl,
          cacheManager: mockCacheManager,
          httpClient: mockHttpClient,
        );

        final key = await provider.obtainKey(const ImageConfiguration());
        final completer = provider.loadImage(key, (buffer, {getTargetSize}) {
          return PaintingBinding.instance.instantiateImageCodecWithSize(
            buffer,
            getTargetSize: getTargetSize,
          );
        });

        await waitForImageLoad(completer);
        verify(mockCacheManager.getSingleFile(testUrl)).called(greaterThanOrEqualTo(3));
        verify(mockHttpClient.get(Uri.parse(testUrl))).called(1);
        expect(completer, isA<MultiFrameImageStreamCompleter>());
      });
    });
  });
}

/// A mock asset bundle for testing purposes.
/// It allows us to simulate loading assets without relying on the actual file system.
/// [assets] A map of asset paths to their corresponding ByteData.
/// [TestAssetBundle] implements the [CachingAssetBundle] interface to provide
/// caching capabilities for the assets.
/// 
/// [load] method takes a key (asset path) and returns the ByteData for that asset.
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

/// Waits for the image to load completely, handling both success and error cases.
/// Returns a Future that completes when the image is loaded or fails after a timeout.
/// If the image fails to load, it will print the error and stack trace to the debug console.
/// [completer] The ImageStreamCompleter to wait for.
/// 
/// Returns a Future that resolves when the image is loaded or fails.
Future<void> waitForImageLoad(ImageStreamCompleter completer) {
  final completerFinished = Completer<void>();
  final stream = ImageStream();

  final listener = ImageStreamListener(
    (_, __) => completerFinished.complete(),
    onError: (e, stack) {
      completerFinished.completeError(e, stack);
      debugPrint('Image load error: $e\n$stack');
    },
  );

  stream.setCompleter(completer);
  stream.addListener(listener);

  return completerFinished.future
      .timeout(const Duration(seconds: 25))
      .whenComplete(() => stream.removeListener(listener));
}
