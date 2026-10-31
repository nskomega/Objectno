import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/app/home_shell.dart';
import 'package:objectno/features/auth/application/session_controller.dart';
import 'package:objectno/features/auth/data/auth_api.dart';
import 'package:objectno/features/auth/data/session_vault.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('profile, name and theme selection at 3x: $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = await databaseFactoryMemory.openDatabase(
        'profile-$brightness',
      );
      addTearDown(db.close);
      final repo = JournalRepository(db);
      final session = SessionController(
        api: AuthApi(baseUrl: ''),
        vault: MemorySessionVault(),
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
          home: HomeShell(
            repository: repo,
            session: session,
            themeMode: ThemeMode.system,
            languageCode: 'system',
            onThemeChanged: (m) => repo.saveTheme(m.name),
            onLanguageChanged: repo.saveLanguage,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PopupMenuButton<String>), findsNothing);
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Изменить имя'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Изменить имя')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Изменить имя'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Михаил');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Сохранить'));
      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();
      expect(await tester.runAsync(repo.readProfileName), 'Михаил');
      await tester.scrollUntilVisible(
        find.text('Тема оформления'),
        160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Тема оформления'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Тёмная'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Тёмная'));
      await tester.pumpAndSettle();
      expect(await tester.runAsync(repo.readTheme), 'dark');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
