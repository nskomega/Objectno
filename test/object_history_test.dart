import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/presentation/object_history_page.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';

const photo =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+a9p8AAAAASUVORK5CYII=';
void main() {
  test(
    'initial photo and history persist, reject fake proposals, cascade and isolate',
    () async {
      final dir = await Directory.systemTemp.createTemp('objectno-history-');
      final path = '${dir.path}/journal.db';
      var db = await databaseFactoryIo.openDatabase(path);
      try {
        var repo = JournalRepository(db);
        final legacy = await repo.addObject('Existing');
        await repo.addIssue(legacy, 'Existing issue', photo: photo);
        await expectLater(
          repo.createRenovation('Incomplete', 'Wish', ''),
          throwsArgumentError,
        );
        expect(await repo.watchObjects().first, hasLength(1));
        final id = await repo.createRenovation('Kitchen', 'New finish', photo);
        await repo.addHistory(
          id,
          'Work started',
          phase: 'progress',
          photo: photo,
        );
        await repo.addHistory(id, 'Finished', phase: 'result', photo: photo);
        await expectLater(
          repo.addHistory(id, 'Invented AI result', phase: 'proposal'),
          throwsArgumentError,
        );
        await db.close();
        db = await databaseFactoryIo.openDatabase(path);
        repo = JournalRepository(db);
        final entries = await repo.watchHistory(id).first;
        expect(entries.map((r) => r.value['phase']), [
          'before',
          'progress',
          'result',
        ]);
        expect(entries.first.value['photo'], photo);
        final alice = repo.inAccount('alice');
        final bob = repo.inAccount('bob');
        final aliceId = await alice.createRenovation(
          'Alice room',
          'Wish',
          photo,
        );
        final bobId = await bob.createRenovation('Bob room', 'Wish', photo);
        await repo.clearAccount('alice');
        expect(await alice.watchHistory(aliceId).first, isEmpty);
        expect(await bob.watchHistory(bobId).first, hasLength(1));
        expect(await repo.watchHistory(id).first, hasLength(3));

        expect(await repo.inAccount('other').watchHistory(id).first, isEmpty);
        await repo.deleteObject(id);
        expect(await repo.watchHistory(id).first, isEmpty);
        expect(
          (await repo.watchIssues(legacy).first).single.value['photo'],
          photo,
        );
      } finally {
        await db.close();
        await dir.delete(recursive: true);
      }
    },
  );
  for (final brightness in Brightness.values) {
    testWidgets(
      'create with photo and view unified timeline at 3x $brightness',
      (tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final db = await databaseFactoryMemory.openDatabase(
          'history-ui-$brightness',
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
              ).copyWith(textScaler: TextScaler.linear(3)),
              child: child!,
            ),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final id = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HistoryEntryForm(
                          repository: repo,
                          pickPhoto: (_) async => XFile.fromData(
                            base64Decode(photo),
                            mimeType: 'image/png',
                            name: 'test.png',
                          ),
                        ),
                      ),
                    );
                    if (id != null && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ObjectHistoryPage(
                            repository: repo,
                            objectId: id,
                            name: 'Кухня',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Start'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Start'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).first, 'Кухня');
        await tester.enterText(
          find.byType(TextFormField).last,
          'Хочу обновить отделку',
        );
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Снять фото'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Снять фото'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Сохранить'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Сохранить'));
        await tester.pumpAndSettle();
        expect(find.text('История ремонта'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('До ремонта'),
          180,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Хочу обновить отделку'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
