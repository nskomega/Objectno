import 'quantity_calculator.dart';

enum OpeningKind { unspecified, door, window }

/// A measured opening on wall 0/2 (length) or 1/3 (width).
class RoomOpening {
  RoomOpening({
    required this.wall,
    required this.geometry,
    this.kind = OpeningKind.unspecified,
    this.sourceHistoryId,
  }) {
    if (wall < 0 || wall > 3) throw ArgumentError('Invalid wall');
  }
  final int wall;
  final SurfaceOpening geometry;
  final OpeningKind kind;
  final int? sourceHistoryId;
  Map<String, Object?> toJson() => {
    'wall': wall,
    'kind': kind.name,
    if (sourceHistoryId != null) 'sourceHistoryId': sourceHistoryId,
    'xMm': geometry.xMm,
    'yMm': geometry.yMm,
    'widthMm': geometry.widthMm,
    'heightMm': geometry.heightMm,
  };
  factory RoomOpening.fromJson(Map<String, Object?> value) => RoomOpening(
    wall: value['wall'] as int,
    kind: value['kind'] == null
        ? OpeningKind.unspecified
        : OpeningKind.values.byName(value['kind'] as String),
    sourceHistoryId: value['sourceHistoryId'] as int?,
    geometry: SurfaceOpening(
      xMm: value['xMm'] as int,
      yMm: value['yMm'] as int,
      widthMm: value['widthMm'] as int,
      heightMm: value['heightMm'] as int,
    ),
  );
}

MeasuredRoom rectangularRoom({
  required RoomKind kind,
  required int lengthMm,
  required int widthMm,
  required int heightMm,
  List<RoomOpening> openings = const [],
}) => MeasuredRoom(
  kind: kind,
  surfaces: [
    MeasuredSurface(
      id: 'floor',
      kind: SurfaceKind.floor,
      widthMm: lengthMm,
      heightMm: widthMm,
    ),
    MeasuredSurface(
      id: 'ceiling',
      kind: SurfaceKind.ceiling,
      widthMm: lengthMm,
      heightMm: widthMm,
    ),
    for (var wall = 0; wall < 4; wall++)
      MeasuredSurface(
        id: 'wall-$wall',
        kind: SurfaceKind.wall,
        widthMm: wall.isEven ? lengthMm : widthMm,
        heightMm: heightMm,
        openings: openings
            .where((o) => o.wall == wall)
            .map((o) => o.geometry)
            .toList(),
      ),
  ],
);

MeasuredRoom roomFromRecord(Map<String, Object?> value) => rectangularRoom(
  kind: RoomKind.values.byName(value['kind'] as String),
  lengthMm: value['lengthMm'] as int,
  widthMm: value['widthMm'] as int,
  heightMm: value['heightMm'] as int,
  openings: [
    for (final opening in value['openings'] as List? ?? const [])
      RoomOpening.fromJson(Map<String, Object?>.from(opening as Map)),
  ],
);
