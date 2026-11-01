import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'package:objectno/features/renovation/domain/room_dimensions.dart';
import 'package:objectno/features/renovation/presentation/openings_panel.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';

void main() {
  test(
    'offset accepts zero and exact comma decimals but rejects negatives',
    () {
      expect(parseOffsetMetresToMm('0,000'), 0);
      expect(parseOffsetMetresToMm('0,125'), 125);
      expect(parseOffsetMetresToMm('-1'), isNull);
      expect(parseMetresToMm('0'), isNull);
    },
  );
  for (final brightness in Brightness.values) {
    testWidgets(
      'opening form validates bounds and updates net area at 3x $brightness',
      (tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final db = await databaseFactoryMemory.openDatabase(
          'opening-ui-$brightness',
        );
        addTearDown(db.close);
        final repo = JournalRepository(db);
        final ids = (await tester.runAsync(() async {
          final id = await repo.addObject('Room');
          final room = await repo.addRoom(
            id,
            name: 'Room',
            kind: RoomKind.kitchen,
            lengthMm: 3000,
            widthMm: 2000,
            heightMm: 2500,
            wish: '',
          );
          return (id, room);
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
            home: Scaffold(
              body: SingleChildScrollView(
                child: StreamBuilder(
                  stream: repo.watchRooms(ids.$1),
                  builder: (context, snapshot) => snapshot.hasData
                      ? OpeningsPanel(
                          repository: repo,
                          objectId: ids.$1,
                          roomId: ids.$2,
                          room: snapshot.data!.single.value,
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Door and window openings'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Door and window openings'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).at(0), '4');
        await tester.enterText(find.byType(TextFormField).at(1), '2');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Add opening'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add opening'));
        await tester.pumpAndSettle();
        expect(
          find.text(
            'Check dimensions: openings must not overlap or extend beyond the wall.',
          ),
          findsOneWidget,
        );
        await tester.enterText(find.byType(TextFormField).at(0), '0.8');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Add opening'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add opening'));
        await tester.pumpAndSettle();
        expect(find.text('Walls excluding openings: 23.4 m²'), findsOneWidget);
        final saved = await tester.runAsync(
          () => repo.watchRooms(ids.$1).first,
        );
        expect(saved!.single.value['openings'], hasLength(1));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
