import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:sembast/sembast_io.dart';
import 'package:objectno/app/objectno_app.dart';
import 'package:objectno/features/auth/application/session_controller.dart';
import 'package:objectno/features/auth/data/auth_api.dart';
import 'package:objectno/features/auth/data/session_vault.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';

void main() {
  // This binding registers the driver extension in Flutter 3.44.2.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'native Keychain, actual local inference, selected scope and disk reopen',
    (tester) async {
      const api = String.fromEnvironment('API_BASE_URL');
      const fixture = String.fromEnvironment('OBJECTNO_TEST_FIXTURE_URL');
      expect(api, 'http://127.0.0.1:8088');
      expect(fixture, 'http://127.0.0.1:8768/fixture.jpg');
      final photo = await http.get(Uri.parse(fixture));
      expect(photo.statusCode, 200);
      expect(photo.bodyBytes.length, lessThan(8 * 1024 * 1024));
      final directory = await Directory.systemTemp.createTemp(
        'objectno-integration-',
      );
      final path = File.fromUri(directory.uri.resolve('journal.db')).path;
      var db = await databaseFactoryIo.openDatabase(path);
      var repo = JournalRepository(db);
      SessionController newSession() => SessionController(
        api: AuthApi(baseUrl: api),
        vault: DeviceSessionVault(),
      );
      final session = newSession();
      SessionController? restored;
      try {
        // The script runs a separate app ID, so its Keychain does not touch the real app.
        await session.vault.clear();
        await repo.saveLanguage('en');
        final id = await repo.createRenovation(
          'Native integration room',
          'Update lighting only. Preserve walls, floor, layout and appliances.',
          base64Encode(photo.bodyBytes),
        );
        final source = (await repo.watchHistory(id).first).single.key;
        await tester.pumpWidget(
          ObjectnoApp(repository: repo, session: session),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Native integration room'));
        await tester.pumpAndSettle();
        final request = find.byKey(ValueKey('analysis-request-$source'));
        await tester.scrollUntilVisible(
          request,
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.widget<FilledButton>(request).onPressed, isNull);
        final scope = find.byKey(ValueKey('analysis-scope-$source-lighting'));
        await tester.ensureVisible(scope);
        await tester.pumpAndSettle();
        await tester.tap(scope);
        await tester.pumpAndSettle();
        await tester.ensureVisible(request);
        await tester.pumpAndSettle();
        await tester.tap(request);
        await tester.pumpAndSettle(
          const Duration(milliseconds: 200),
          EnginePhase.sendSemanticsUpdate,
          const Duration(minutes: 3),
        );
        final entries = await repo.watchHistory(id).first;
        expect(
          entries,
          hasLength(2),
          reason: 'Actual inference must save exactly one proposal',
        );
        final saved = entries.last.value;
        expect(saved['phase'], 'proposal');
        final analysis = saved['analysis'] as Map;
        expect(analysis['work_scopes'], ['lighting']);
        expect(analysis['detected_items'], isNotEmpty);
        final concept = saved['description'] as String;
        await tester.scrollUntilVisible(
          find.text(concept),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(find.text(concept), findsOneWidget);
        expect(session.user?.isGuest, true);
        expect(await session.vault.read(), isNotEmpty);
        final identity = session.user!.id;
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        await db.close();
        db = await databaseFactoryIo.openDatabase(path);
        repo = JournalRepository(db);
        restored = newSession();
        await restored.restore();
        expect(
          restored.user?.id,
          identity,
          reason: 'Native Keychain refresh must restore the same identity',
        );
        expect(
          (await repo.watchHistory(id).first).last.value['description'],
          concept,
        );
        await tester.pumpWidget(
          ObjectnoApp(repository: repo, session: restored),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Native integration room'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text(concept),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(concept), findsOneWidget);
        expect(tester.takeException(), isNull);
        binding.reportData = {
          'native_keychain_restore': true,
          'disk_reopen': true,
          'work_scopes': ['lighting'],
          'model': analysis['model'],
          'prompt_version': analysis['prompt_version'],
        };
        await tester.pumpAndSettle();
        await binding.takeScreenshot('native-scoped-proposal');
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        if (restored != null) {
          await restored.logout();
          restored.dispose();
        } else {
          await session.logout();
        }
        session.dispose();
        await db.close();
        await directory.delete(recursive: true);
      }
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
