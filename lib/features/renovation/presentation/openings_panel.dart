import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'measured_plan.dart';
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
  OpeningKind _kind = OpeningKind.door;
  int? _sourceHistoryId;
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
          kind: _kind,
          sourceHistoryId: _sourceHistoryId,
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
    String kindLabel(OpeningKind kind) => switch (kind) {
      OpeningKind.door => l.openingDoor,
      OpeningKind.window => l.openingWindow,
      OpeningKind.unspecified => l.openingUnspecified,
    };
    return StreamBuilder<List<RecordSnapshot<int, Map<String, Object?>>>>(
      stream: widget.repository.watchHistory(widget.objectId),
      builder: (context, snapshot) {
        final photos = {
          for (final record
              in snapshot.data ?? <RecordSnapshot<int, Map<String, Object?>>>[])
            if (record.value['photo'] is String &&
                (record.value['photo'] as String).isNotEmpty)
              record.key: record.value,
        };
        final selectedPhoto = photos[_sourceHistoryId];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.netWallArea(number.format(net / 1000000))),
            MeasuredPlan(room: widget.room),
            ExpansionTile(
              title: Text(l.openings),
              childrenPadding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                Text(l.openingHelp),
                const SizedBox(height: 8),
                Text(l.photoPlanHelp),
                for (var i = 0; i < openings.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${kindLabel(RoomOpening.fromJson(Map<String, Object?>.from(openings[i] as Map)).kind)} · ${l.wallNumber(((openings[i] as Map)['wall'] as int) + 1)} · ${number.format(((openings[i] as Map)['widthMm'] as int) / 1000)} × ${number.format(((openings[i] as Map)['heightMm'] as int) / 1000)}',
                              ),
                              if (photos[(openings[i]
                                      as Map)['sourceHistoryId']]
                                  case final photo?)
                                ExpansionTile(
                                  title: Text(l.openingReferencePhoto),
                                  subtitle: Text(
                                    photo['description'] as String,
                                  ),
                                  children: [_referenceImage(context, photo)],
                                ),
                            ],
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
                          for (final kind in [
                            OpeningKind.door,
                            OpeningKind.window,
                          ])
                            ChoiceChip(
                              label: Text(kindLabel(kind)),
                              selected: _kind == kind,
                              onSelected: _busy
                                  ? null
                                  : (_) => setState(() => _kind = kind),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(l.openingReferencePhoto),
                      const SizedBox(height: 8),
                      if (snapshot.hasError) Text(l.objectsLoadFailure),
                      DropdownButtonFormField<int>(
                        key: ValueKey(_sourceHistoryId),
                        initialValue: photos.containsKey(_sourceHistoryId)
                            ? _sourceHistoryId
                            : 0,
                        isExpanded: true,
                        itemHeight: null,
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(l.openingNoPhoto),
                          ),
                          for (final entry in photos.entries)
                            DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value['description'] as String),
                            ),
                        ],
                        onChanged: _busy
                            ? null
                            : (id) => setState(
                                () => _sourceHistoryId = id == 0 ? null : id,
                              ),
                      ),
                      if (selectedPhoto != null) ...[
                        const SizedBox(height: 8),
                        _referenceImage(context, selectedPhoto),
                      ],
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
      },
    );
  }

  Widget _referenceImage(BuildContext context, Map<String, Object?> photo) =>
      Image.memory(
        base64Decode(photo['photo'] as String),
        height: 200,
        fit: BoxFit.contain,
        semanticLabel: photo['description'] as String,
        errorBuilder: (_, error, stack) => Text(context.l10n.photoLoadFailure),
      );
}
