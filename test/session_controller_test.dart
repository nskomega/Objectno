import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:objectno/features/auth/application/session_controller.dart';
import 'package:objectno/features/auth/data/auth_api.dart';
import 'package:objectno/features/auth/data/session_vault.dart';

String tokens(String suffix) => jsonEncode({
  'access_token': 'access-$suffix',
  'refresh_token': 'refresh-$suffix',
  'expires_in': 900,
  'user': {'id': 'user-1', 'email': 'test@example.com'},
});

void main() {
  test(
    'restore coalesces concurrent rotation and persists replacement',
    () async {
      final vault = MemorySessionVault();
      await vault.write('old');
      final gate = Completer<void>();
      var calls = 0;
      var now = DateTime.utc(2026);
      final session = SessionController(
        vault: vault,
        now: () => now,
        api: AuthApi(
          baseUrl: 'https://example.com',
          client: MockClient((r) async {
            calls++;
            expect(
              jsonDecode(r.body)['refresh_token'],
              calls == 1 ? 'old' : 'refresh-1',
            );
            await gate.future;
            return http.Response(tokens('$calls'), 200);
          }),
        ),
      );
      addTearDown(session.dispose);
      final restored = session.restore();
      await Future<void>.delayed(Duration.zero);
      final concurrent = session.accessToken();
      gate.complete();
      await restored;
      expect(await concurrent, 'access-1');
      expect(await vault.read(), 'refresh-1');
      expect(await session.accessToken(), 'access-1');
      expect(calls, 1);
      now = now.add(const Duration(minutes: 15));
      expect(await session.accessToken(), 'access-2');
      expect(calls, 2);
    },
  );

  test('revoked refresh clears secret and identity', () async {
    final vault = MemorySessionVault();
    await vault.write('revoked');
    final session = SessionController(
      vault: vault,
      api: AuthApi(
        baseUrl: 'https://example.com',
        client: MockClient(
          (_) async => http.Response('{"error":"unauthorized"}', 401),
        ),
      ),
    );
    addTearDown(session.dispose);
    await session.restore();
    expect(session.restoreError, 'unauthorized');
    expect(session.user, isNull);
    expect(await vault.read(), isNull);
  });

  test(
    'delete removes server account before wiping current local scope',
    () async {
      final vault = MemorySessionVault();
      final events = <String>[];
      final session = SessionController(
        vault: vault,
        api: AuthApi(
          baseUrl: 'https://example.com',
          client: MockClient((r) async {
            if (r.method == 'DELETE') {
              expect(r.headers['Authorization'], 'Bearer access-new');
              expect(jsonDecode(r.body)['password'], 'confirmed');
              events.add('server');
              return http.Response('{}', 200);
            }
            return http.Response(tokens('new'), 200);
          }),
        ),
      );
      addTearDown(session.dispose);
      await session.signIn('test@example.com', 'secret');
      await session.deleteAccount('confirmed', (id) async {
        events.add(id);
      });
      expect(events, ['server', 'user-1']);
      expect(session.user, isNull);
      expect(await vault.read(), isNull);
    },
  );

  test('production rejects cleartext and malformed response', () async {
    expect(
      () => AuthApi(baseUrl: 'http://localhost', allowLocalHttp: false),
      throwsArgumentError,
    );
    final api = AuthApi(
      baseUrl: 'https://example.com',
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    addTearDown(api.close);
    await expectLater(
      api.signIn('x', 'y'),
      throwsA(isA<AuthFailure>().having((e) => e.code, 'code', 'server_error')),
    );
  });
}
