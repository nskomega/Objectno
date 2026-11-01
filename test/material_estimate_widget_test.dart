import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'package:objectno/features/renovation/domain/rectangular_room.dart';
import 'package:objectno/features/renovation/presentation/object_history_page.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'manual product estimate returns to history at 3x $brightness',
      (tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final db = await databaseFactoryMemory.openDatabase(
          'estimate-ui-$brightness',
        );
        addTearDown(db.close);
        final repo = JournalRepository(db);
        final id = (await tester.runAsync(() async {
          final id = await repo.addObject('Kitchen');
          final room = await repo.addRoom(
            id,
            name: 'Room',
            kind: RoomKind.kitchen,
            lengthMm: 3000,
            widthMm: 2000,
            heightMm: 2500,
            wish: '',
          );
          await repo.addRoomOpening(
            id,
            room,
            RoomOpening(
              wall: 0,
              geometry: SurfaceOpening(
                xMm: 0,
                yMm: 0,
                widthMm: 800,
                heightMm: 2000,
              ),
            ),
          );
          return id;
        }))!;
        await tester.pumpWidget(
          MaterialApp(
            theme: objectnoTheme(brightness),
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(3)),
              child: child!,
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
          find.text('Calculate material'),
          350,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.ensureVisible(find.text('Calculate material'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Calculate material'));
        await tester.pumpAndSettle();
        for (var wall = 1; wall <= 4; wall++) {
          await tester.ensureVisible(find.text('Wall $wall'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Wall $wall'));
          await tester.pumpAndSettle();
        }
        await tester.ensureVisible(find.text('ml'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('ml'));
        final values = [
          'Synthetic label product',
          'Synthetic test source',
          '100',
          '2500',
          '2',
          '10',
        ];
        for (var i = 0; i < values.length; i++) {
          await tester.enterText(find.byType(TextFormField).at(i), values[i]);
        }
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Save'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Required: 5148 ml'),
          350,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Packages: 3'), findsOneWidget);
        final records = await tester.runAsync(
          () => repo.watchHistory(id).first,
        );
        expect(records!.single.value['phase'], 'estimate');
        expect(tester.takeException(), isNull);
      },
    );
  }
}
