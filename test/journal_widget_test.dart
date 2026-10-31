import 'package:objectno/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/journal/presentation/journal_page.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    for (final scale in [.8, 1.0, 2.0, 3.0]) {
      testWidgets('create object and issue: $brightness scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final db = await databaseFactoryMemory.openDatabase(
          'test-$brightness-$scale',
        );
        addTearDown(db.close);
        final repo = JournalRepository(db);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: objectnoTheme(brightness),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: JournalPage(repository: repo),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Создать объект'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField), 'Квартира');
        await tester.ensureVisible(find.text('Создать'));
        await tester.tap(find.text('Создать'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Квартира'),
          160,
          scrollable: find.byType(Scrollable).first,
        );
        await Scrollable.ensureVisible(
          tester.element(find.text('Квартира')),
          alignment: .5,
        );
        await tester.pumpAndSettle();
        expect(find.text('Квартира'), findsOneWidget);
        await tester.tap(find.text('Квартира'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Добавить замечание'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextFormField),
          'Проверить крепление подоконника',
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Сохранить замечание'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Сохранить замечание'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Проверить крепление подоконника'),
          160,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Проверить крепление подоконника'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
