import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/app/objectno_app.dart';
import 'package:objectno/features/auth/application/session_controller.dart';
import 'package:objectno/features/auth/data/auth_api.dart';
import 'package:objectno/features/auth/data/session_vault.dart';
import 'package:objectno/features/auth/presentation/account_page.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/l10n/l10n.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';

void main() {
  testWidgets('login and logout replace navigation and isolate guest records', (
    tester,
  ) async {
    final db = await databaseFactoryMemory.openDatabase('auth-integration');
    final repo = JournalRepository(db);
    await tester.runAsync(() async {
      await repo.addObject('Guest private object');
      await repo.inAccount('alice').addObject('Alice private object');
      await repo.saveLanguage('en');
    });
    final vault = MemorySessionVault();
    final session = SessionController(
      vault: vault,
      api: AuthApi(
        baseUrl: 'https://example.com',
        client: MockClient((r) async {
          if (r.url.path.endsWith('logout')) return http.Response('{}', 200);
          return http.Response(
            jsonEncode({
              'access_token': 'a',
              'refresh_token': 'r',
              'expires_in': 900,
              'user': {'id': 'alice', 'email': 'alice@example.com'},
            }),
            200,
          );
        }),
      ),
    );
    addTearDown(session.dispose);
    addTearDown(db.close);
    await tester.pumpWidget(ObjectnoApp(repository: repo, session: session));
    await tester.pumpAndSettle();
    expect(find.text('Guest private object'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Account'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'alice@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'example password');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountPage), findsNothing);
    expect(find.text('Guest private object'), findsNothing);
    expect(find.text('Alice private object'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Account'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Guest private object'), findsOneWidget);
    expect(find.text('Alice private object'), findsNothing);
    expect(await tester.runAsync(vault.read), isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('anonymous analysis session keeps the guest journal visible', (
    tester,
  ) async {
    final db = await databaseFactoryMemory.openDatabase('guest-analysis-root');
    addTearDown(db.close);
    final repo = JournalRepository(db);
    await tester.runAsync(() async {
      await repo.addObject('Guest renovation');
      await repo.saveLanguage('en');
    });
    final session = SessionController(
      vault: MemorySessionVault(),
      api: AuthApi(
        baseUrl: 'https://example.com',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'access_token': 'a',
              'refresh_token': 'r',
              'expires_in': 900,
              'user': {'id': 'anonymous-id', 'email': '', 'guest': true},
            }),
            200,
          ),
        ),
      ),
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(ObjectnoApp(repository: repo, session: session));
    await tester.pumpAndSettle();
    await tester.runAsync(session.accessToken);
    await tester.pumpAndSettle();
    expect(find.text('Guest renovation'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Guest profile'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  for (final brightness in Brightness.values) {
    testWidgets('registration validation remains usable at 3x: $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final session = SessionController(
        vault: MemorySessionVault(),
        api: AuthApi(baseUrl: 'https://example.com'),
      );
      addTearDown(session.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: objectnoTheme(brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(3)),
            child: child!,
          ),
          home: AccountPage(session: session, wipeLocal: (_) async {}),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.widgetWithText(TextButton, 'Создать аккаунт'),
        240,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.widgetWithText(TextButton, 'Создать аккаунт'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.widgetWithText(FilledButton, 'Создать аккаунт'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await Scrollable.ensureVisible(
        tester.element(find.widgetWithText(FilledButton, 'Создать аккаунт')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Создать аккаунт'));
      await tester.pumpAndSettle();
      expect(find.text('Заполните поле'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }
}
