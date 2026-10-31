import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_io.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';

void main() {
  test(
    'object, issue, photo and status survive reopen; deleting object cascades',
    () async {
      final dir = await Directory.systemTemp.createTemp('objectno-test-');
      final path = '${dir.path}/journal.db';
      var db = await databaseFactoryIo.openDatabase(path);
      try {
        var repo = JournalRepository(db);
        final id = await repo.addObject('Квартира');
        final issue = await repo.addIssue(
          id,
          'Проверить откос',
          photo: 'aGVsbG8=',
        );
        await repo.setDone(issue, true);
        await repo.saveTheme('dark');
        await db.close();
        db = await databaseFactoryIo.openDatabase(path);
        repo = JournalRepository(db);
        final records = await repo.watchIssues(id).first;
        expect(records.single.value['description'], 'Проверить откос');
        expect(records.single.value['photo'], 'aGVsbG8=');
        expect(records.single.value['done'], true);
        expect(await repo.readTheme(), 'dark');
        await repo.deleteObject(id);
        expect(await repo.watchObjects().first, isEmpty);
        expect(await repo.watchIssues(id).first, isEmpty);
        await expectLater(
          repo.addIssue(id, 'Сиротская запись'),
          throwsStateError,
        );
      } finally {
        await db.close();
        await dir.delete(recursive: true);
      }
    },
  );
}
