import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/app/objectno_app.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/journal/presentation/journal_page.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';

void main() {
  test('all locale bundles have every source key', () {
    Set<String> keys(File f) =>
        (jsonDecode(f.readAsStringSync()) as Map<String, dynamic>).keys
            .where((k) => !k.startsWith('@'))
            .toSet();
    final expected = keys(File('lib/l10n/arb/app_en.arb'));
    for (final file in Directory('lib/l10n/arb').listSync().whereType<File>()) {
      expect(keys(file), expected, reason: file.path);
    }
  });
  for (final locale in AppLocalizations.supportedLocales) {
    for (final brightness in Brightness.values) {
      testWidgets('localized home and validation: $locale $brightness at 2x', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final db = await databaseFactoryMemory.openDatabase(
          'locale-$locale-$brightness',
        );
        addTearDown(db.close);
        final l10n = await AppLocalizations.delegate.load(locale);
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: objectnoTheme(brightness),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: JournalPage(repository: JournalRepository(db)),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l10n.objectsHeading), findsOneWidget);
        await tester.tap(find.text(l10n.createObject));
        await tester.pumpAndSettle();
        expect(find.text(l10n.objectName), findsOneWidget);
        await tester.ensureVisible(find.text(l10n.create));
        await tester.tap(find.text(l10n.create));
        await tester.pumpAndSettle();
        expect(find.text(l10n.requiredField), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('system, manual override and persisted selection', (
    tester,
  ) async {
    final db = await databaseFactoryMemory.openDatabase('locale-setting');
    addTearDown(db.close);
    final repo = JournalRepository(db);
    tester.binding.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(ObjectnoApp(repository: repo));
    await tester.pumpAndSettle();
    final es = await AppLocalizations.delegate.load(const Locale('es'));
    final de = await AppLocalizations.delegate.load(const Locale('de'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(es.objectsHeading), findsOneWidget);
    await tester.tap(find.text(es.profile));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(es.language));
    await tester.tap(find.text(es.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text(es.languageGerman));
    await tester.pumpAndSettle();
    expect(find.text(de.settings), findsOneWidget);
    expect(await tester.runAsync(repo.readLanguage), 'de');
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    await tester.pumpAndSettle();
    expect(find.text(de.settings), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(ObjectnoApp(repository: repo));
    await tester.pumpAndSettle();
    expect(find.text(de.objectsHeading), findsOneWidget);
    await tester.tap(find.text(de.profile));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(de.language));
    await tester.tap(find.text(de.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text(de.followSystem));
    await tester.pumpAndSettle();
    expect(find.text(en.settings), findsOneWidget);
    expect(await tester.runAsync(repo.readLanguage), 'system');
  });
}
