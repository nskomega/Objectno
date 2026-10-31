import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_io.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';

void main() {
  test(
    'account scopes isolate overlapping IDs and preserve guest data',
    () async {
      final dir = await Directory.systemTemp.createTemp('objectno-scopes-');
      final db = await databaseFactoryIo.openDatabase('${dir.path}/journal.db');
      try {
        final guest = JournalRepository(db);
        final alice = guest.inAccount('alice');
        final bob = guest.inAccount('bob');
        await alice.saveProfileName('Alice');
        await bob.saveProfileName('Bob');
        await guest.saveProfileName('Guest');
        final guestId = await guest.addObject('Guest');
        final aliceId = await alice.addObject('Alice');
        final bobId = await bob.addObject('Bob');
        expect(aliceId, bobId);
        await alice.addIssue(aliceId, 'Alice private');
        await alice.addRoom(
          aliceId,
          name: 'Kitchen',
          kind: RoomKind.kitchen,
          lengthMm: 4000,
          widthMm: 3000,
          heightMm: 2500,
          wish: 'Paint walls',
        );
        await bob.addRoom(
          bobId,
          name: 'Bedroom',
          kind: RoomKind.bedroom,
          lengthMm: 5000,
          widthMm: 3000,
          heightMm: 2700,
          wish: 'New flooring',
        );
        await bob.addIssue(bobId, 'Bob private');
        expect(
          (await alice.watchObjects().first).single.value['name'],
          'Alice',
        );
        expect(
          (await bob.watchIssues(bobId).first).single.value['description'],
          'Bob private',
        );
        await guest.clearAccount('alice');
        expect(await alice.readProfileName(), isNull);
        expect(await bob.readProfileName(), 'Bob');
        expect(await guest.readProfileName(), 'Guest');
        expect(await alice.watchRooms(aliceId).first, isEmpty);
        expect(await bob.watchRooms(bobId).first, hasLength(1));
        expect(await alice.watchObjects().first, isEmpty);
        expect(await alice.watchIssues(aliceId).first, isEmpty);
        expect(await bob.watchIssues(bobId).first, hasLength(1));
        expect((await guest.watchObjects().first).single.key, guestId);
      } finally {
        await db.close();
        await dir.delete(recursive: true);
      }
    },
  );
  test(
    'object, issue, photo and status survive reopen; deleting object cascades',
    () async {
      final dir = await Directory.systemTemp.createTemp('objectno-test-');
      final path = '${dir.path}/journal.db';
      var db = await databaseFactoryIo.openDatabase(path);
      try {
        var repo = JournalRepository(db);
        final id = await repo.addObject('Квартира');
        await repo.addRoom(
          id,
          name: 'Ванная',
          kind: RoomKind.bathroom,
          lengthMm: 2000,
          widthMm: 3000,
          heightMm: 2500,
          wish: 'Обновить плитку',
        );
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
        expect(
          (await repo.watchRooms(id).first).single.value['lengthMm'],
          2000,
        );
        final records = await repo.watchIssues(id).first;
        expect(records.single.value['description'], 'Проверить откос');
        expect(records.single.value['photo'], 'aGVsbG8=');
        expect(records.single.value['done'], true);
        expect(await repo.readTheme(), 'dark');
        await repo.deleteObject(id);
        expect(await repo.watchObjects().first, isEmpty);
        expect(await repo.watchRooms(id).first, isEmpty);
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
