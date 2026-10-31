import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthFailure implements Exception {
  const AuthFailure(this.code);
  final String code;
}

class AccountUser {
  const AccountUser({
    required this.id,
    required this.email,
    this.isGuest = false,
  });
  final String id;
  final String email;
  final bool isGuest;
  factory AccountUser.fromJson(Map<String, dynamic> value) {
    final id = value['id'];
    final email = value['email'];
    if (id is! String || id.isEmpty || email is! String) {
      throw const AuthFailure('server_error');
    }
    return AccountUser(id: id, email: email, isGuest: value['guest'] == true);
  }
}

class AuthTokens {
  const AuthTokens({
    required this.access,
    required this.refresh,
    required this.expiresIn,
    required this.user,
  });
  final String access;
  final String refresh;
  final int expiresIn;
  final AccountUser user;
  factory AuthTokens.fromJson(Map<String, dynamic> value) {
    final access = value['access_token'];
    final refresh = value['refresh_token'];
    final expiresIn = value['expires_in'];
    if (access is! String ||
        access.isEmpty ||
        refresh is! String ||
        refresh.isEmpty ||
        expiresIn is! int ||
        expiresIn <= 0 ||
        value['user'] is! Map<String, dynamic>) {
      throw const AuthFailure('server_error');
    }
    return AuthTokens(
      access: access,
      refresh: refresh,
      expiresIn: expiresIn,
      user: AccountUser.fromJson(value['user'] as Map<String, dynamic>),
    );
  }
}

class AuthApi {
  AuthApi({
    required String baseUrl,
    http.Client? client,
    bool allowLocalHttp = !kReleaseMode,
  }) : _client = client ?? http.Client(),
       baseUri = baseUrl.isEmpty ? null : Uri.tryParse(baseUrl) {
    if (baseUrl.isNotEmpty) {
      final uri = baseUri;
      final local =
          uri != null &&
          ['localhost', '127.0.0.1', '10.0.2.2', '::1'].contains(uri.host);
      if (uri == null ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          uri.hasQuery ||
          uri.hasFragment ||
          (uri.scheme != 'https' &&
              !(allowLocalHttp && local && uri.scheme == 'http'))) {
        throw ArgumentError(
          'API_BASE_URL must use HTTPS (local HTTP allowed for development only)',
        );
      }
    }
  }
  final Uri? baseUri;
  final http.Client _client;
  bool get enabled => baseUri != null;
  void close() => _client.close();
  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? access,
  }) async {
    if (!enabled) throw const AuthFailure('unavailable');
    try {
      final request = http.Request(method, baseUri!.resolve(path));
      request.headers['Content-Type'] = 'application/json';
      if (access != null) request.headers['Authorization'] = 'Bearer $access';
      if (body != null) request.body = jsonEncode(body);
      final response = await (() async {
        final streamed = await _client.send(request);
        final bytes = <int>[];
        await for (final chunk in streamed.stream) {
          if (bytes.length + chunk.length > 64 * 1024) {
            throw const AuthFailure('server_error');
          }
          bytes.addAll(chunk);
        }
        return http.Response.bytes(bytes, streamed.statusCode);
      })().timeout(const Duration(seconds: 20));
      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const AuthFailure('server_error');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final code = decoded['error'];
        throw AuthFailure(code is String ? code : 'server_error');
      }
      return decoded;
    } on AuthFailure {
      rethrow;
    } on TimeoutException {
      throw const AuthFailure('network');
    } on http.ClientException {
      throw const AuthFailure('network');
    } on FormatException {
      throw const AuthFailure('server_error');
    }
  }

  Future<AuthTokens> guest() async =>
      AuthTokens.fromJson(await _request('POST', '/v1/auth/guest', body: {}));
  Future<AuthTokens> signIn(
    String email,
    String password, {
    bool register = false,
  }) async => AuthTokens.fromJson(
    await _request(
      'POST',
      register ? '/v1/auth/register' : '/v1/auth/login',
      body: {'email': email, 'password': password},
    ),
  );
  Future<AuthTokens> refresh(String refresh) async => AuthTokens.fromJson(
    await _request(
      'POST',
      '/v1/auth/refresh',
      body: {'refresh_token': refresh},
    ),
  );
  Future<void> logout(String refresh) async {
    await _request('POST', '/v1/auth/logout', body: {'refresh_token': refresh});
  }

  Future<void> deleteAccount(String access, String password) async {
    await _request(
      'DELETE',
      '/v1/me',
      access: access,
      body: {'password': password},
    );
  }
}
