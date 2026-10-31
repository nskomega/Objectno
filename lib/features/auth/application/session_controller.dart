import 'package:flutter/foundation.dart';
import '../data/auth_api.dart';
import '../data/session_vault.dart';

class SessionController extends ChangeNotifier {
  SessionController({
    required this.api,
    required this.vault,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;
  final AuthApi api;
  final SessionVault vault;
  final DateTime Function() _now;
  AccountUser? user;
  String? restoreError;
  String? _access;
  String? _refresh;
  DateTime? _expires;
  Future<String>? _refreshing;
  bool _mutation = false;
  bool _disposed = false;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> restore() async {
    if (!api.enabled) return;
    try {
      _refresh = await vault.read();
      if (_refresh != null) await accessToken();
    } on AuthFailure catch (error) {
      restoreError = error.code;
    } catch (_) {
      restoreError = 'storage';
    }
    _notify();
  }

  Future<void> signIn(
    String email,
    String password, {
    bool register = false,
  }) async {
    if (_mutation) throw const AuthFailure('busy');
    _mutation = true;
    try {
      // Do not race an in-flight rotation against replacing the stored session.
      try {
        await _refreshing;
      } on AuthFailure {
        /* replaced by an explicit login */
      }
      final tokens = await api.signIn(email, password, register: register);
      await _accept(tokens);
      restoreError = null;
      _notify();
    } finally {
      _mutation = false;
    }
  }

  Future<void> _accept(AuthTokens tokens) async {
    try {
      await vault.write(tokens.refresh);
    } catch (_) {
      // Avoid leaving a newly-issued live session behind when persistence failed.
      try {
        await api.logout(tokens.refresh);
      } catch (_) {
        /* best effort */
      }
      throw const AuthFailure('storage');
    }
    _access = tokens.access;
    _refresh = tokens.refresh;
    user = tokens.user;
    _expires = _now().add(Duration(seconds: tokens.expiresIn));
  }

  Future<String> accessToken() {
    if (_access != null &&
        _expires != null &&
        _expires!.isAfter(_now().add(const Duration(seconds: 30)))) {
      return Future.value(_access);
    }
    return _refreshing ??= _rotate().whenComplete(() => _refreshing = null);
  }

  Future<String> _rotate() async {
    final token = _refresh;
    if (token == null) {
      if (!api.enabled) throw const AuthFailure('unauthorized');
      await _accept(await api.guest());
      _notify();
      return _access!;
    }
    try {
      final tokens = await api.refresh(token);
      await _accept(tokens);
      _notify();
      return _access!;
    } on AuthFailure catch (error) {
      if (error.code == 'unauthorized') {
        await _clear();
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_mutation) throw const AuthFailure('busy');
    _mutation = true;
    try {
      try {
        await _refreshing;
      } on AuthFailure {
        /* revoked session may be cleared */
      }
      final token = _refresh;
      if (token != null) {
        try {
          await api.logout(token);
        } on AuthFailure catch (e) {
          if (e.code != 'unauthorized') rethrow;
        }
      }
      await _clear();
    } finally {
      _mutation = false;
    }
  }

  Future<void> deleteAccount(
    String password,
    Future<void> Function(String userId) wipeLocal,
  ) async {
    if (_mutation) throw const AuthFailure('busy');
    _mutation = true;
    try {
      final access = await accessToken();
      final id = user!.id;
      await api.deleteAccount(access, password);
      try {
        await wipeLocal(id);
      } finally {
        await _clear();
      }
    } finally {
      _mutation = false;
    }
  }

  Future<void> _clear() async {
    try {
      await vault.clear();
    } catch (_) {
      throw const AuthFailure('storage');
    } finally {
      _access = null;
      _refresh = null;
      _expires = null;
      user = null;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    api.close();
    super.dispose();
  }
}
