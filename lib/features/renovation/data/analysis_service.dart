import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../../auth/application/session_controller.dart';

import 'analysis_result.dart';
export 'analysis_result.dart';

class AnalysisService {
  AnalysisService(this.session, {http.Client? client})
    : _client = client ?? http.Client();
  final SessionController session;
  final http.Client _client;
  bool get enabled => session.api.enabled;
  void close() => _client.close();
  Future<AnalysisResult> analyze({
    required String photo,
    required String wish,
    required String language,
  }) async {
    if (!enabled) throw const AnalysisFailure('unavailable');
    final token = await session.accessToken();
    final identity = session.user?.id;
    try {
      final request =
          http.Request('POST', session.api.baseUri!.resolve('/v1/analysis'))
            ..followRedirects = false
            ..headers.addAll({
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            })
            ..body = jsonEncode({
              'photo': photo,
              'wish': wish,
              'language': language,
            });
      final result = await (() async {
        final response = await _client.send(request);
        if (response.statusCode != 200) {
          await response.stream.drain<void>();
          throw AnalysisFailure(response.statusCode == 429 ? 'busy' : 'failed');
        }
        final bytes = <int>[];
        await for (final chunk in response.stream) {
          bytes.addAll(chunk);
          if (bytes.length > 65536) {
            throw const AnalysisFailure('invalid');
          }
        }
        return AnalysisResult.fromJson(
          jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>,
        );
      })().timeout(const Duration(seconds: 160));
      if (identity == null || session.user?.id != identity) {
        throw const AnalysisFailure('session_changed');
      }
      return result;
    } on AnalysisFailure {
      rethrow;
    } catch (_) {
      throw const AnalysisFailure('failed');
    }
  }
}

class AnalysisScope extends InheritedWidget {
  const AnalysisScope({super.key, required this.service, required super.child});
  final AnalysisService service;
  static AnalysisService? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AnalysisScope>()?.service;
  @override
  bool updateShouldNotify(AnalysisScope oldWidget) =>
      service != oldWidget.service;
}
