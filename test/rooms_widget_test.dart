import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/presentation/rooms_page.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('save room and display gross areas at 3x: $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = await databaseFactoryMemory.openDatabase('room-$brightness');
      addTearDown(db.close);
      final repo = JournalRepository(db);
      final id = (await tester.runAsync(() => repo.addObject('Apartment')))!;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: objectnoTheme(brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(3)),
            child: child!,
          ),
          home: RoomsPage(repository: repo, objectId: id),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add room'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<RoomKind>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kitchen').last);
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Kitchen west');
      await tester.enterText(fields.at(1), '4');
      await tester.enterText(fields.at(2), '3,5');
      await tester.enterText(fields.at(3), '2.5');
      await tester.enterText(fields.at(4), 'Modernise the room');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.text('Save room')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save room'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Kitchen west'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Floor: 14 m²'), findsOneWidget);
      expect(find.text('Walls before openings: 37.5 m²'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
