import 'package:flutter/material.dart';
import 'package:objectno/l10n/l10n.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/features/renovation/presentation/object_history_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/auth/application/session_controller.dart';
import 'package:objectno/features/auth/data/auth_api.dart';
import 'package:objectno/features/auth/data/session_vault.dart';
import 'package:objectno/features/renovation/data/analysis_service.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'object_history_test.dart' show photo;

Map<String, dynamic> draft({bool matches = true}) => {
  'model': 'test-model',
  'revision': 'pinned-revision',
  'prompt_version': 7,
  'proposal': {
    'scene_matches': matches,
    'concept': matches ? 'Light walls, keep furniture.' : '',
    'observations': ['Visible table'],
    'work_steps': matches ? ['Paint walls'] : <String>[],
    'materials': matches ? ['Wall paint'] : <String>[],
    'questions': ['Keep table?'],
    'uncertainties': ['Wall condition'],
  },
};
void main() {
  test(
    'proposal persists with its source; foreign or deleted source is rejected',
    () async {
      final db = await databaseFactoryMemory.openDatabase('proposal-source');
      addTearDown(db.close);
      final repo = JournalRepository(db);
      final id = await repo.createRenovation('Kitchen', 'Light finish', photo);
      final other = await repo.createRenovation('Bedroom', 'Keep bed', photo);
      final source = (await repo.watchHistory(id).first).first.key;
      final result = AnalysisResult.fromJson(draft());
      await expectLater(
        repo.addProposal(other, source, result),
        throwsStateError,
      );
      await repo.addProposal(id, source, result);
      final saved = (await JournalRepository(
        db,
      ).watchHistory(id).first).last.value;
      expect(saved['sourceHistoryId'], source);
      expect(saved['phase'], 'proposal');
      expect((saved['analysis'] as Map)['revision'], 'pinned-revision');
      await expectLater(
        Future.sync(
          () => repo.addProposal(
            id,
            source,
            AnalysisResult.fromJson(draft(matches: false)),
          ),
        ),
        throwsArgumentError,
      );
      await repo.deleteObject(id);
      await expectLater(repo.addProposal(id, source, result), throwsStateError);
      expect(await repo.watchHistory(id).first, isEmpty);
    },
  );
  test(
    'analysis sends authorized source and rejects response after identity changes',
    () async {
      final session = SessionController(
        vault: MemorySessionVault(),
        api: AuthApi(
          baseUrl: 'https://example.com',
          client: MockClient(
            (request) async => http.Response(
              jsonEncode({
                'access_token': 'access',
                'refresh_token': 'refresh',
                'expires_in': 900,
                'user': {'id': 'guest-1', 'email': '', 'guest': true},
              }),
              200,
            ),
          ),
        ),
      );
      addTearDown(session.dispose);
      final gate = Completer<void>();
      final service = AnalysisService(
        session,
        client: MockClient((request) async {
          expect(request.headers['Authorization'], 'Bearer access');
          expect(jsonDecode(request.body)['photo'], photo);
          await gate.future;
          return http.Response(jsonEncode(draft()), 200);
        }),
      );
      addTearDown(service.close);
      final pending = service.analyze(
        photo: photo,
        wish: 'Light finish',
        language: 'en',
      );
      await Future<void>.delayed(Duration.zero);
      session.user = const AccountUser(id: 'other', email: 'other@example.com');
      gate.complete();
      await expectLater(
        pending,
        throwsA(
          isA<AnalysisFailure>().having(
            (e) => e.code,
            'code',
            'session_changed',
          ),
        ),
      );
    },
  );
  for (final brightness in Brightness.values) {
    testWidgets('generate and display saved draft at 3x $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = await databaseFactoryMemory.openDatabase(
        'draft-ui-$brightness',
      );
      addTearDown(db.close);
      final repo = JournalRepository(db);
      final id = (await tester.runAsync(
        () => repo.createRenovation('Kitchen', 'Light walls', photo),
      ))!;
      final secondSource = (await tester.runAsync(
        () => repo.addHistory(
          id,
          'Updated wishes',
          phase: 'before',
          photo: photo,
        ),
      ))!;
      final session = SessionController(
        vault: MemorySessionVault(),
        api: AuthApi(
          baseUrl: 'https://example.com',
          client: MockClient(
            (r) async => http.Response(
              jsonEncode({
                'access_token': 'access',
                'refresh_token': 'refresh',
                'expires_in': 900,
                'user': {'id': 'guest', 'email': '', 'guest': true},
              }),
              200,
            ),
          ),
        ),
      );
      addTearDown(session.dispose);
      final service = AnalysisService(
        session,
        client: MockClient((r) async {
          expect(jsonDecode(r.body)['wish'], 'Updated wishes');
          return http.Response(jsonEncode(draft()), 200);
        }),
      );
      addTearDown(service.close);
      await tester.pumpWidget(
        MaterialApp(
          theme: objectnoTheme(brightness),
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => AnalysisScope(
            service: service,
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(3)),
              child: child!,
            ),
          ),
          home: ObjectHistoryPage(
            repository: repo,
            objectId: id,
            name: 'Kitchen',
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(ValueKey(secondSource)),
        350,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text('Get a proposal').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get a proposal').last);
      await tester.pumpAndSettle();
      expect(
        (await tester.runAsync(
          () => repo.watchHistory(id).first,
        ))!.last.value['phase'],
        'proposal',
      );
      await tester.scrollUntilVisible(
        find.text('Light walls, keep furniture.'),
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        (await tester.runAsync(
          () => repo.watchHistory(id).first,
        ))!.last.value['sourceHistoryId'],
        secondSource,
      );
      expect(find.text('Light walls, keep furniture.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  test('malformed plan and non-room with work steps fail closed', () {
    final value = draft(matches: false);
    (value['proposal'] as Map)['work_steps'] = ['Invented plan'];
    expect(
      () => AnalysisResult.fromJson(value),
      throwsA(isA<AnalysisFailure>()),
    );
    final invalid = draft();
    (invalid['proposal'] as Map)['materials'] = [23];
    expect(
      () => AnalysisResult.fromJson(invalid),
      throwsA(isA<AnalysisFailure>()),
    );
  });
}
