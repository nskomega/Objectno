import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'package:objectno/features/renovation/domain/rectangular_room.dart';

RoomOpening opening(int wall, int x, int y, int width, int height) =>
    RoomOpening(
      wall: wall,
      geometry: SurfaceOpening(
        xMm: x,
        yMm: y,
        widthMm: width,
        heightMm: height,
      ),
    );
void main() {
  test('four walls deduct openings only on their own surface', () {
    final room = rectangularRoom(
      kind: RoomKind.kitchen,
      lengthMm: 3000,
      widthMm: 2000,
      heightMm: 2500,
      openings: [
        opening(0, 0, 0, 800, 2000),
        opening(1, 500, 1000, 1000, 1000),
      ],
    );
    final walls = room.surfaces.where((s) => s.kind == SurfaceKind.wall);
    expect(walls.fold<int>(0, (sum, s) => sum + s.netAreaMm2), 22400000);
    expect(room.surfaces.first.netAreaMm2, 6000000);
    expect(
      () => rectangularRoom(
        kind: RoomKind.bedroom,
        lengthMm: 3000,
        widthMm: 2000,
        heightMm: 2500,
        openings: [opening(1, 1500, 0, 800, 2000)],
      ),
      throwsArgumentError,
    );
    expect(
      () => rectangularRoom(
        kind: RoomKind.bathroom,
        lengthMm: 3000,
        widthMm: 2000,
        heightMm: 2500,
        openings: [
          opening(0, 0, 0, 800, 2000),
          opening(0, 500, 1000, 1000, 1000),
        ],
      ),
      throwsArgumentError,
    );
  });
  test(
    'legacy rooms, saved openings, failed update and account isolation',
    () async {
      final db = await databaseFactoryMemory.openDatabase('openings');
      addTearDown(db.close);
      final repo = JournalRepository(db);
      final id = await repo.addObject('Room');
      final roomId = await repo.addRoom(
        id,
        name: 'Room',
        kind: RoomKind.kitchen,
        lengthMm: 3000,
        widthMm: 2000,
        heightMm: 2500,
        wish: '',
      );
      var record = (await repo.watchRooms(id).first).single.value;
      expect(roomFromRecord(record).surfaces, hasLength(6));
      await repo.addRoomOpening(id, roomId, opening(0, 0, 0, 800, 2000));
      await expectLater(
        repo.addRoomOpening(id, roomId, opening(0, 0, 0, 900, 2100)),
        throwsArgumentError,
      );
      record = (await JournalRepository(db).watchRooms(id).first).single.value;
      expect(record['openings'], hasLength(1));
      await expectLater(
        repo
            .inAccount('other')
            .addRoomOpening(id, roomId, opening(1, 0, 0, 800, 2000)),
        throwsStateError,
      );
      await repo.removeRoomOpening(id, roomId, 0);
      expect(
        (await repo.watchRooms(id).first).single.value['openings'],
        isEmpty,
      );
    },
  );
}
