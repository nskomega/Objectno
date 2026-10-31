import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SessionVault {
  Future<String?> read();
  Future<void> write(String refresh);
  Future<void> clear();
}

// Web sessions are deliberately memory-only, not mobile Keychain emulation.
class MemorySessionVault implements SessionVault {
  String? _refresh;
  @override
  Future<String?> read() async => _refresh;
  @override
  Future<void> write(String refresh) async {
    _refresh = refresh;
  }

  @override
  Future<void> clear() async {
    _refresh = null;
  }
}

class DeviceSessionVault implements SessionVault {
  static const _key = 'objectno.refresh.v1';
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
    ),
  );
  @override
  Future<String?> read() => _storage.read(key: _key);
  @override
  Future<void> write(String refresh) =>
      _storage.write(key: _key, value: refresh);
  @override
  Future<void> clear() => _storage.delete(key: _key);
}

SessionVault createSessionVault() =>
    kIsWeb ? MemorySessionVault() : DeviceSessionVault();
