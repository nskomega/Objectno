// Geometry uses integer millimetres; quantities are rounded only at boundaries.
// This module never infers measurements or product consumption from a photo.
enum RoomKind { bathroom, toilet, kitchen, bedroom, livingRoom, other }

enum SurfaceKind { floor, ceiling, wall }

enum QuantityUnit { gram, millilitre, piece }

void _positive(int value, String name) {
  if (value <= 0 || value > 9007199254740991) {
    throw ArgumentError.value(value, name, 'Must be a positive exact integer');
  }
}

int _exact(BigInt value) {
  if (value < BigInt.zero || value > BigInt.from(9007199254740991)) {
    throw ArgumentError('Quantity exceeds cross-platform exact integer range');
  }
  return value.toInt();
}

int _ceilDivide(BigInt value, BigInt divisor) =>
    _exact((value + divisor - BigInt.one) ~/ divisor);

class SurfaceOpening {
  SurfaceOpening({
    required this.xMm,
    required this.yMm,
    required this.widthMm,
    required this.heightMm,
  }) {
    if (xMm < 0 || yMm < 0) throw ArgumentError('Negative opening position');
    _positive(widthMm, 'widthMm');
    _positive(heightMm, 'heightMm');
    if ([xMm, yMm, widthMm, heightMm].any((value) => value > 1000000)) {
      throw ArgumentError('Opening dimensions exceed 1 km');
    }
  }
  final int xMm, yMm, widthMm, heightMm;
  int get areaMm2 => widthMm * heightMm;
  bool overlaps(SurfaceOpening other) =>
      xMm < other.xMm + other.widthMm &&
      xMm + widthMm > other.xMm &&
      yMm < other.yMm + other.heightMm &&
      yMm + heightMm > other.yMm;
}

class MeasuredSurface {
  MeasuredSurface({
    required this.id,
    required this.kind,
    required this.widthMm,
    required this.heightMm,
    List<SurfaceOpening> openings = const [],
  }) : openings = List.unmodifiable(openings) {
    if (id.trim().isEmpty) throw ArgumentError('Empty surface ID');
    _positive(widthMm, 'widthMm');
    _positive(heightMm, 'heightMm');
    if (widthMm > 1000000 || heightMm > 1000000) {
      throw ArgumentError('Surface dimensions exceed 1 km');
    }
    for (var i = 0; i < this.openings.length; i++) {
      final opening = this.openings[i];
      if (opening.xMm + opening.widthMm > widthMm ||
          opening.yMm + opening.heightMm > heightMm) {
        throw ArgumentError('Opening outside surface');
      }
      for (var j = 0; j < i; j++) {
        if (opening.overlaps(this.openings[j])) {
          throw ArgumentError('Overlapping openings');
        }
      }
    }
  }
  final String id;
  final SurfaceKind kind;
  final int widthMm, heightMm;
  final List<SurfaceOpening> openings;
  int get netAreaMm2 =>
      widthMm * heightMm -
      openings.fold<int>(0, (sum, opening) => sum + opening.areaMm2);
}

class MeasuredRoom {
  MeasuredRoom({required this.kind, required List<MeasuredSurface> surfaces})
    : surfaces = List.unmodifiable(surfaces) {
    if (surfaces.isEmpty) throw ArgumentError('No confirmed surfaces');
    if (surfaces.length > 1000) throw ArgumentError('Too many surfaces');
    if (surfaces.map((s) => s.id).toSet().length != surfaces.length) {
      throw ArgumentError('Duplicate surface IDs');
    }
  }
  final RoomKind kind;
  final List<MeasuredSurface> surfaces;
}

// The caller must provide a real product's documented consumption and units.
// Layers are explicit: never silently assume a single coat.
class ProductConsumption {
  ProductConsumption({
    required this.productId,
    required this.source,
    required this.unit,
    required this.unitsPerSquareMetrePerLayer,
    required this.unitsPerPackage,
  }) {
    if (productId.trim().isEmpty || source.trim().isEmpty) {
      throw ArgumentError('Product and consumption source required');
    }
    _positive(unitsPerSquareMetrePerLayer, 'unitsPerSquareMetrePerLayer');
    _positive(unitsPerPackage, 'unitsPerPackage');
  }
  final String productId, source;
  final QuantityUnit unit;
  final int unitsPerSquareMetrePerLayer, unitsPerPackage;
}

class MaterialEstimate {
  const MaterialEstimate({
    required this.surfaceIds,
    required this.areaMm2,
    required this.product,
    required this.layers,
    required this.wasteBasisPoints,
    required this.requiredUnits,
    required this.packages,
  });
  static const calculationVersion = 1;
  final List<String> surfaceIds;
  final int areaMm2, layers, wasteBasisPoints, requiredUnits, packages;
  final ProductConsumption product;
  int get purchasedUnits =>
      _exact(BigInt.from(packages) * BigInt.from(product.unitsPerPackage));
  int get surplusUnits => purchasedUnits - requiredUnits;
}

MaterialEstimate estimateMaterial({
  required MeasuredRoom room,
  required Set<String> surfaceIds,
  required ProductConsumption product,
  required int layers,
  required int wasteBasisPoints,
}) {
  _positive(layers, 'layers');
  if (wasteBasisPoints < 0 || wasteBasisPoints > 10000) {
    throw ArgumentError('Waste must be between 0 and 100 percent');
  }
  if (surfaceIds.isEmpty) throw ArgumentError('No work surfaces selected');
  final available = {for (final surface in room.surfaces) surface.id: surface};
  if (surfaceIds.any((id) => !available.containsKey(id))) {
    throw ArgumentError('Selected surface is not confirmed');
  }
  final ids = surfaceIds.toList()..sort();
  final area = ids.fold<int>(0, (sum, id) => sum + available[id]!.netAreaMm2);
  // 1 m² = 1,000,000 mm²; 100% = 10,000 basis points.
  final required = _ceilDivide(
    BigInt.from(area) *
        BigInt.from(product.unitsPerSquareMetrePerLayer) *
        BigInt.from(layers) *
        BigInt.from(10000 + wasteBasisPoints),
    BigInt.from(1000000 * 10000),
  );
  return MaterialEstimate(
    surfaceIds: List.unmodifiable(ids),
    areaMm2: area,
    product: product,
    layers: layers,
    wasteBasisPoints: wasteBasisPoints,
    requiredUnits: required,
    packages: _ceilDivide(
      BigInt.from(required),
      BigInt.from(product.unitsPerPackage),
    ),
  );
}
