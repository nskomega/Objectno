import 'package:flutter_test/flutter_test.dart';
import 'package:objectno/features/renovation/domain/quantity_calculator.dart';

void main() {
  ProductConsumption fixture({int rate = 200, int package = 1000}) =>
      ProductConsumption(
        productId: 'test-fixture-only',
        source: 'Synthetic test data, not a recommendation',
        unit: QuantityUnit.gram,
        unitsPerSquareMetrePerLayer: rate,
        unitsPerPackage: package,
      );
  MeasuredSurface wall({List<SurfaceOpening> openings = const []}) =>
      MeasuredSurface(
        id: 'wall',
        kind: SurfaceKind.wall,
        widthMm: 4000,
        heightMm: 2500,
        openings: openings,
      );

  for (final kind in [RoomKind.bathroom, RoomKind.kitchen, RoomKind.bedroom]) {
    test('same confirmed work gives same quantity in $kind', () {
      final surface = wall(
        openings: [
          SurfaceOpening(xMm: 100, yMm: 0, widthMm: 1000, heightMm: 2000),
        ],
      );
      final result = estimateMaterial(
        room: MeasuredRoom(kind: kind, surfaces: [surface]),
        surfaceIds: {'wall'},
        product: fixture(),
        layers: 2,
        wasteBasisPoints: 1000,
      );
      expect(result.areaMm2, 8000000); // 10m² minus actual 2m² opening.
      expect(result.requiredUnits, 3520); // 8 * 200 * 2 * 1.10.
      expect(result.packages, 4);
      expect(result.surplusUnits, 480);
    });
  }
  test('opening edges may touch but cannot overlap or leave surface', () {
    wall(
      openings: [
        SurfaceOpening(xMm: 0, yMm: 0, widthMm: 1000, heightMm: 2000),
        SurfaceOpening(xMm: 1000, yMm: 0, widthMm: 1000, heightMm: 2000),
      ],
    );
    expect(
      () => wall(
        openings: [
          SurfaceOpening(xMm: 3500, yMm: 0, widthMm: 1000, heightMm: 2000),
        ],
      ),
      throwsArgumentError,
    );
    expect(
      () => wall(
        openings: [
          SurfaceOpening(xMm: 0, yMm: 0, widthMm: 1000, heightMm: 2000),
          SurfaceOpening(xMm: 999, yMm: 0, widthMm: 1000, heightMm: 2000),
        ],
      ),
      throwsArgumentError,
    );
  });
  test('exact pack boundary and tiny remainder round correctly', () {
    for (final width in [1000, 1001]) {
      final room = MeasuredRoom(
        kind: RoomKind.other,
        surfaces: [
          MeasuredSurface(
            id: 'floor',
            kind: SurfaceKind.floor,
            widthMm: width,
            heightMm: 1000,
          ),
        ],
      );
      final result = estimateMaterial(
        room: room,
        surfaceIds: {'floor'},
        product: fixture(rate: 1000),
        layers: 1,
        wasteBasisPoints: 0,
      );
      expect(result.requiredUnits, width);
      expect(result.packages, width == 1000 ? 1 : 2);
    }
  });
  test('missing work data fails instead of returning zero', () {
    final room = MeasuredRoom(kind: RoomKind.bedroom, surfaces: [wall()]);
    for (final ids in [
      <String>{},
      {'missing'},
    ]) {
      expect(
        () => estimateMaterial(
          room: room,
          surfaceIds: ids,
          product: fixture(),
          layers: 1,
          wasteBasisPoints: 0,
        ),
        throwsArgumentError,
      );
    }
    expect(
      () => MeasuredRoom(kind: RoomKind.kitchen, surfaces: [wall(), wall()]),
      throwsArgumentError,
    );
    expect(
      () => estimateMaterial(
        room: room,
        surfaceIds: {'wall'},
        product: fixture(),
        layers: 0,
        wasteBasisPoints: 0,
      ),
      throwsArgumentError,
    );
    expect(
      () => estimateMaterial(
        room: room,
        surfaceIds: {'wall'},
        product: fixture(),
        layers: 1,
        wasteBasisPoints: -1,
      ),
      throwsArgumentError,
    );
  });
  test('large intermediate products retain an exact packaging boundary', () {
    final room = MeasuredRoom(
      kind: RoomKind.kitchen,
      surfaces: [
        MeasuredSurface(
          id: 'floor',
          kind: SurfaceKind.floor,
          widthMm: 100000,
          heightMm: 100000,
        ),
      ],
    );
    final result = estimateMaterial(
      room: room,
      surfaceIds: {'floor'},
      product: fixture(rate: 5000, package: 25000),
      layers: 2,
      wasteBasisPoints: 1000,
    );
    expect(result.requiredUnits, 110000000);
    expect(result.packages, 4400);
  });
  test('zero net work area needs no material', () {
    final room = MeasuredRoom(
      kind: RoomKind.other,
      surfaces: [
        wall(
          openings: [
            SurfaceOpening(xMm: 0, yMm: 0, widthMm: 4000, heightMm: 2500),
          ],
        ),
      ],
    );
    final result = estimateMaterial(
      room: room,
      surfaceIds: {'wall'},
      product: fixture(),
      layers: 1,
      wasteBasisPoints: 0,
    );
    expect(result.requiredUnits, 0);
    expect(result.packages, 0);
  });
}
