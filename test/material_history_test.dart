import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:objectno/features/journal/data/journal_repository.dart';
import 'package:objectno/features/renovation/domain/quantity_calculator.dart';
import 'package:objectno/features/renovation/domain/rectangular_room.dart';

void main() {
  test(
    'estimate uses current net surfaces and preserves its measurement snapshot',
    () async {
      final db = await databaseFactoryMemory.openDatabase('estimates');
      addTearDown(db.close);
      final repo = JournalRepository(db);
      final object = await repo.addObject('Kitchen');
      final room = await repo.addRoom(
        object,
        name: 'Room',
        kind: RoomKind.kitchen,
        lengthMm: 3000,
        widthMm: 2000,
        heightMm: 2500,
        wish: '',
      );
      await repo.addRoomOpening(
        object,
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
      final product = ProductConsumption(
        productId: 'Synthetic test product',
        source: 'Synthetic test label, not a recommendation',
        unit: QuantityUnit.millilitre,
        unitsPerSquareMetrePerLayer: 100,
        unitsPerPackage: 2500,
      );
      final selected = {for (var i = 0; i < 4; i++) 'wall-$i'};
      await repo.addMaterialEstimate(
        object,
        room,
        surfaceIds: selected,
        product: product,
        layers: 2,
        wasteBasisPoints: 1000,
      );
      await repo.removeRoomOpening(object, room, 0);
      final record = (await JournalRepository(
        db,
      ).watchHistory(object).first).single.value;
      final estimate = record['estimate'] as Map;
      expect(record['phase'], 'estimate');
      expect(estimate['areaMm2'], 23400000);
      expect(estimate['requiredUnits'], 5148);
      expect(estimate['packages'], 3);
      expect(estimate['purchasedUnits'], 7500);
      expect(
        ((estimate['measurementSnapshot'] as Map)['openings'] as List),
        hasLength(1),
      );
      expect(estimate['sourceKind'], 'user_entered');
      await expectLater(
        repo.addMaterialEstimate(
          object,
          room,
          surfaceIds: {'unknown'},
          product: product,
          layers: 2,
          wasteBasisPoints: 1000,
        ),
        throwsArgumentError,
      );
      await expectLater(
        repo
            .inAccount('another')
            .addMaterialEstimate(
              object,
              room,
              surfaceIds: selected,
              product: product,
              layers: 2,
              wasteBasisPoints: 1000,
            ),
        throwsStateError,
      );
      expect(await repo.watchHistory(object).first, hasLength(1));
    },
  );
}
