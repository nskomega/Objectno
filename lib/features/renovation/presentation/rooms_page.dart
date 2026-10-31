import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sembast/sembast.dart';
import '../../../design_system/components/labeled_field.dart';
import '../../../l10n/l10n.dart';
import '../../journal/data/journal_repository.dart';
import '../domain/quantity_calculator.dart';
import '../domain/room_dimensions.dart';

String roomKindLabel(AppLocalizations l, RoomKind kind) => switch (kind) {
  RoomKind.bathroom => l.roomBathroom,
  RoomKind.toilet => l.roomToilet,
  RoomKind.kitchen => l.roomKitchen,
  RoomKind.bedroom => l.roomBedroom,
  RoomKind.livingRoom => l.roomLiving,
  RoomKind.other => l.roomOther,
};

class RoomsPage extends StatelessWidget {
  const RoomsPage({
    super.key,
    required this.repository,
    required this.objectId,
  });
  final JournalRepository repository;
  final int objectId;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final number = NumberFormat(
      '0.###',
      Localizations.localeOf(context).languageCode,
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.rooms)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child:
                StreamBuilder<List<RecordSnapshot<int, Map<String, Object?>>>>(
                  stream: repository.watchRooms(objectId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text(l.objectsLoadFailure);
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.add),
                          label: Text(l.newRoom),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => _RoomForm(
                                repository: repository,
                                objectId: objectId,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(l.roomGeometryNote),
                        const SizedBox(height: 16),
                        for (final record in snapshot.data!)
                          Builder(
                            builder: (context) {
                              final room = record.value;
                              final length = room['lengthMm'] as int;
                              final width = room['widthMm'] as int;
                              final height = room['heightMm'] as int;
                              final kind = RoomKind.values.firstWhere(
                                (k) => k.name == room['kind'],
                                orElse: () => RoomKind.other,
                              );
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        room['name'] as String,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      Text(roomKindLabel(l, kind)),
                                      const SizedBox(height: 8),
                                      Text(room['wish'] as String),
                                      const SizedBox(height: 8),
                                      Text(
                                        l.floorArea(
                                          number.format(
                                            length * width / 1000000,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        l.wallArea(
                                          number.format(
                                            2 *
                                                (length + width) *
                                                height /
                                                1000000,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}

class _RoomForm extends StatefulWidget {
  const _RoomForm({required this.repository, required this.objectId});
  final JournalRepository repository;
  final int objectId;
  @override
  State<_RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<_RoomForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _wish = TextEditingController();
  final _length = TextEditingController();
  final _width = TextEditingController();
  final _height = TextEditingController();
  RoomKind _kind = RoomKind.other;
  bool _busy = false;
  bool _error = false;
  @override
  void dispose() {
    for (final c in [_name, _wish, _length, _width, _height]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      await widget.repository.addRoom(
        widget.objectId,
        name: _name.text,
        kind: _kind,
        lengthMm: parseMetresToMm(_length.text)!,
        widthMm: parseMetresToMm(_width.text)!,
        heightMm: parseMetresToMm(_height.text)!,
        wish: _wish.text,
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _dimension(String label, TextEditingController controller) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        enabled: !_busy,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(hintText: label),
        validator: (s) => parseMetresToMm(s ?? '') == null
            ? context.l10n.invalidDimension
            : null,
      ),
      const SizedBox(height: 16),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(title: Text(l.newRoom)),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l.roomType,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<RoomKind>(
                        itemHeight: null,
                        initialValue: _kind,
                        isExpanded: true,
                        items: [
                          for (final kind in RoomKind.values)
                            DropdownMenuItem(
                              value: kind,
                              child: Text(roomKindLabel(l, kind)),
                            ),
                        ],
                        onChanged: _busy
                            ? null
                            : (kind) => setState(() => _kind = kind!),
                      ),
                      const SizedBox(height: 16),
                      LabeledField(label: l.roomName, controller: _name),
                      const SizedBox(height: 16),
                      _dimension(l.lengthMetres, _length),
                      _dimension(l.widthMetres, _width),
                      _dimension(l.heightMetres, _height),
                      LabeledField(
                        label: l.renovationWish,
                        controller: _wish,
                        maxLines: 4,
                        maxLength: 2000,
                      ),
                      const SizedBox(height: 16),
                      Text(l.roomGeometryNote),
                      if (_error) ...[
                        const SizedBox(height: 16),
                        Text(
                          l.saveFailure,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _save,
                        child: Text(_busy ? l.pleaseWait : l.saveRoom),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
