import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/l10n.dart';
import '../../journal/data/journal_repository.dart';
import '../domain/quantity_calculator.dart';
import '../domain/rectangular_room.dart';
import '../domain/room_dimensions.dart';

class OpeningsPanel extends StatefulWidget {
  const OpeningsPanel({
    super.key,
    required this.repository,
    required this.objectId,
    required this.roomId,
    required this.room,
  });
  final JournalRepository repository;
  final int objectId, roomId;
  final Map<String, Object?> room;
  @override
  State<OpeningsPanel> createState() => _OpeningsPanelState();
}

class _OpeningsPanelState extends State<OpeningsPanel> {
  final _form = GlobalKey<FormState>();
  final _width = TextEditingController(), _height = TextEditingController();
  final _x = TextEditingController(text: '0'),
      _y = TextEditingController(text: '0');
  int _wall = 0;
  bool _busy = false, _error = false;
  @override
  void dispose() {
    for (final c in [_width, _height, _x, _y]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _change(Future<void> Function() operation) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      await operation();
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _add() async {
    if (!_form.currentState!.validate()) return;
    await _change(
      () => widget.repository.addRoomOpening(
        widget.objectId,
        widget.roomId,
        RoomOpening(
          wall: _wall,
          geometry: SurfaceOpening(
            xMm: parseOffsetMetresToMm(_x.text)!,
            yMm: parseOffsetMetresToMm(_y.text)!,
            widthMm: parseMetresToMm(_width.text)!,
            heightMm: parseMetresToMm(_height.text)!,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final number = NumberFormat(
      '0.###',
      Localizations.localeOf(context).languageCode,
    );
    final surfaces = roomFromRecord(widget.room).surfaces;
    final net = surfaces
        .where((s) => s.kind == SurfaceKind.wall)
        .fold<int>(0, (sum, s) => sum + s.netAreaMm2);
    final openings = widget.room['openings'] as List? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.netWallArea(number.format(net / 1000000))),
        ExpansionTile(
          title: Text(l.openings),
          childrenPadding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Text(l.openingHelp),
            for (var i = 0; i < openings.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${l.wallNumber(((openings[i] as Map)['wall'] as int) + 1)} · ${number.format(((openings[i] as Map)['widthMm'] as int) / 1000)} × ${number.format(((openings[i] as Map)['heightMm'] as int) / 1000)}',
                      ),
                    ),
                    IconButton(
                      tooltip: l.delete,
                      onPressed: _busy
                          ? null
                          : () => _change(
                              () => widget.repository.removeRoomOpening(
                                widget.objectId,
                                widget.roomId,
                                i,
                              ),
                            ),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var wall = 0; wall < 4; wall++)
                        ChoiceChip(
                          label: Text(l.wallNumber(wall + 1)),
                          selected: _wall == wall,
                          onSelected: _busy
                              ? null
                              : (_) => setState(() => _wall = wall),
                        ),
                    ],
                  ),
                  for (final field in [
                    (l.widthMetres, _width, false),
                    (l.heightMetres, _height, false),
                    (l.openingX, _x, true),
                    (l.openingY, _y, true),
                  ]) ...[
                    const SizedBox(height: 12),
                    Text(field.$1),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: field.$2,
                      enabled: !_busy,
                      decoration: InputDecoration(hintText: field.$1),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) =>
                          (field.$3
                                  ? parseOffsetMetresToMm(v ?? '')
                                  : parseMetresToMm(v ?? '')) ==
                              null
                          ? l.invalidDimension
                          : null,
                    ),
                  ],
                  if (_error)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        l.openingInvalid,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _busy ? null : _add,
                    child: Text(_busy ? l.pleaseWait : l.addOpening),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
