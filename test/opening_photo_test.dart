import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_io.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'package:objectno/features/renovation/domain/rectangular_room.dart';

void main() {
  test(
    'measured opening keeps photo and kind after database reopen; rejects unrelated sources',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'objectno-opening-photo-',
      );
      var db = await databaseFactoryIo.openDatabase('${dir.path}/journal.db');
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });
      var repo = JournalRepository(db);
      final object = await repo.addObject('Kitchen');
      final other = await repo.addObject('Other');
      final room = await repo.addRoom(
        object,
        name: 'Kitchen',
        kind: RoomKind.kitchen,
        lengthMm: 4000,
        widthMm: 3000,
        heightMm: 2500,
        wish: '',
      );
      final photo = await repo.addHistory(
        object,
        'Window view',
        phase: 'before',
        photo: 'AQ==',
      );
      final foreign = await repo.addHistory(
        other,
        'Other view',
        phase: 'before',
        photo: 'AQ==',
      );
      final text = await repo.addHistory(object, 'Note', phase: 'progress');
      RoomOpening opening(int? source) => RoomOpening(
        wall: 1,
        kind: OpeningKind.window,
        sourceHistoryId: source,
        geometry: SurfaceOpening(
          xMm: 500,
          yMm: 1000,
          widthMm: 1200,
          heightMm: 1000,
        ),
      );
      for (final source in [foreign, text, 999999]) {
        await expectLater(
          repo.addRoomOpening(object, room, opening(source)),
          throwsStateError,
        );
      }
      await repo.addRoomOpening(object, room, opening(photo));
      await db.close();
      db = await databaseFactoryIo.openDatabase('${dir.path}/journal.db');
      repo = JournalRepository(db);
      final record = (await repo.watchRooms(object).first).single.value;
      final restored = RoomOpening.fromJson(
        Map<String, Object?>.from((record['openings'] as List).single as Map),
      );
      expect(restored.kind, OpeningKind.window);
      expect(restored.sourceHistoryId, photo);
      expect(restored.geometry.xMm, 500);
      expect(restored.geometry.yMm, 1000);
      expect(
        roomFromRecord(record).surfaces
            .where((s) => s.kind == SurfaceKind.wall)
            .fold<int>(0, (sum, s) => sum + s.netAreaMm2),
        33800000,
      );
      expect(
        (await repo.history.record(photo).get(db))!['description'],
        'Window view',
      );
      final legacy = restored.toJson()
        ..remove('kind')
        ..remove('sourceHistoryId');
      expect(RoomOpening.fromJson(legacy).kind, OpeningKind.unspecified);
      expect(RoomOpening.fromJson(legacy).sourceHistoryId, isNull);
    },
  );
}
