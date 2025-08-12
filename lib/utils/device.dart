import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceUtils {
  static const _storageKey = 'device_unique_id';
  static final _secureStorage = FlutterSecureStorage();
  static String? _cachedId;
  static const List<int> saltCharCodes = [
    0x61, 0x70, 0x70, 0x53, 0x61, 0x6c, 0x74, 0x21, 0x40, 0x23 // Replace on launch
  ];

  static Future<String> getHashedDeviceId() async {
    if (_cachedId != null) return _cachedId!;

    final existing = await _secureStorage.read(key: _storageKey);
    if (existing != null) {
      _cachedId = existing;
      return existing;
    }

    final rawId = await _generateDeviceFingerprint();
    final salt = String.fromCharCodes(saltCharCodes);
    final bytes = utf8.encode('$salt:$rawId');
    final hash = sha256.convert(bytes).toString();

    await _secureStorage.write(key: _storageKey, value: hash);
    _cachedId = hash;
    return hash;
  }

  static Future<String> _generateDeviceFingerprint() async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      final info = await deviceInfo.webBrowserInfo;
      return '${info.vendor}-${info.userAgent}-${info.hardwareConcurrency}';
    } else {
      final info = await deviceInfo.deviceInfo;
      final data = info.data;
      return '${data['model']}-${data['id']}';
    }
  }

  static Future<String> getPlatform() async {
    if (kIsWeb) return "Web";

    final info = await DeviceInfoPlugin().deviceInfo;
    final type = info.runtimeType.toString();

    if (type.contains('Android')) return "Android";
    if (type.contains('Ios')) return "iOS";
    if (type.contains('Mac')) return "macOS";
    if (type.contains('Linux')) return "Linux";
    if (type.contains('Windows')) return "Windows";

    return "Unknown";
  }

  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "${info.version}+${info.buildNumber}";
  }
}
