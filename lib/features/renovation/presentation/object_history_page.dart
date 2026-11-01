import '../data/analysis_service.dart';
import '../../auth/data/auth_api.dart' show AuthFailure;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../l10n/l10n.dart';
import '../../../design_system/components/labeled_field.dart';
import '../../journal/data/journal_repository.dart';
import '../../journal/presentation/journal_page.dart' show Entry, IssuesPage;
import '../domain/quantity_calculator.dart';
import '../domain/room_dimensions.dart';
import 'rooms_page.dart' show roomKindLabel;

String phaseLabel(AppLocalizations l, String phase) => switch (phase) {
  'before' => l.beforeStage,
  'progress' => l.progressStage,
  'result' => l.resultStage,
  'proposal' => l.proposalStage,
  _ => l.issuesHeading,
};

class ObjectHistoryPage extends StatelessWidget {
  const ObjectHistoryPage({
    super.key,
    required this.repository,
    required this.objectId,
    required this.name,
  });
  final JournalRepository repository;
  final int objectId;
  final String name;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            tooltip: l.issuesHeading,
            icon: const Icon(Icons.fact_check_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => IssuesPage(
                  repository: repository,
                  objectId: objectId,
                  objectName: name,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: StreamBuilder<List<Entry>>(
              stream: repository.watchHistory(objectId),
              builder: (context, history) {
                return StreamBuilder<List<Entry>>(
                  stream: repository.watchIssues(objectId),
                  builder: (context, issues) {
                    if (history.hasError || issues.hasError) {
                      return Center(child: Text(l.issuesLoadFailure));
                    }
                    if (!history.hasData || !issues.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final records =
                        [
                          ...history.data!.map((r) => r.value),
                          ...issues.data!.map(
                            (r) => {...r.value, 'phase': 'issue'},
                          ),
                        ]..sort(
                          (a, b) => (a['createdAt'] as String).compareTo(
                            b['createdAt'] as String,
                          ),
                        );
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          l.projectHistory,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        _Measurements(
                          repository: repository,
                          objectId: objectId,
                          name: name,
                        ),
                        const SizedBox(height: 12),
                        if (records.isEmpty) Text(l.historyEmpty),
                        if (!records.any((r) => r['phase'] == 'before'))
                          const _ProposalPending(),
                        for (var i = 0; i < records.length; i++) ...[
                          _HistoryCard(record: records[i]),
                          if (i ==
                              records.indexWhere((r) => r['phase'] == 'before'))
                            _GenerateProposal(
                              repository: repository,
                              objectId: objectId,
                              source: history.data!.firstWhere(
                                (r) => r.value['phase'] == 'before',
                              ),
                            ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text(l.addUpdate),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<int>(
              builder: (_) =>
                  HistoryEntryForm(repository: repository, objectId: objectId),
            ),
          ),
        ),
      ),
    );
  }
}

class _GenerateProposal extends StatefulWidget {
  const _GenerateProposal({
    required this.repository,
    required this.objectId,
    required this.source,
  });
  final JournalRepository repository;
  final int objectId;
  final Entry source;
  @override
  State<_GenerateProposal> createState() => _GenerateProposalState();
}

class _GenerateProposalState extends State<_GenerateProposal> {
  bool _busy = false;
  String? _error;
  Future<void> _run(AnalysisService service) async {
    final language = Localizations.localeOf(context).languageCode;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await service.analyze(
        photo: widget.source.value['photo'] as String,
        wish: widget.source.value['description'] as String,
        language: language,
      );
      if (!mounted) return;
      if (!result.matches) {
        setState(() => _error = 'notRoom');
        return;
      }
      await widget.repository.addProposal(
        widget.objectId,
        widget.source.key,
        result,
      );
    } catch (error) {
      assert(() {
        debugPrint(
          'Analysis request failed: ${error is AuthFailure
              ? error.code
              : error is AnalysisFailure
              ? error.code
              : error.runtimeType}',
        );
        return true;
      }());
      if (mounted) setState(() => _error = 'failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final service = AnalysisScope.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.proposalStage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l.analysisDraft),
            if (service?.enabled != true) Text(l.proposalPending),
            if (_busy) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              Text(l.analysisWorking),
            ],
            if (_error != null)
              Text(
                _error == 'notRoom' ? l.analysisNotRoom : l.analysisFailed,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy || service?.enabled != true
                  ? null
                  : () => _run(service!),
              child: Text(l.analyzePhoto),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProposalDetails extends StatelessWidget {
  const _ProposalDetails({required this.analysis});
  final Map analysis;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final proposal = analysis['proposal'] as Map;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(l.analysisDraft),
        for (final section in [
          (l.analysisObservations, 'observations'),
          (l.analysisSteps, 'work_steps'),
          (l.analysisMaterials, 'materials'),
          (l.analysisQuestions, 'questions'),
          (l.analysisUnknowns, 'uncertainties'),
        ]) ...[
          const SizedBox(height: 16),
          Text(section.$1, style: Theme.of(context).textTheme.titleMedium),
          for (final text in proposal[section.$2] as List)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('• $text'),
            ),
        ],
        const SizedBox(height: 16),
        Text(
          '${analysis['model']} · ${analysis['revision']}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProposalPending extends StatelessWidget {
  const _ProposalPending();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.proposalStage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.proposalPending),
        ],
      ),
    ),
  );
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.record});
  final Map<String, Object?> record;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final date = DateTime.tryParse(record['createdAt'] as String? ?? '');
    final photo = record['photo'] as String?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              phaseLabel(l, record['phase'] as String),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (date != null)
              Text(
                DateFormat.yMMMd(
                  Localizations.localeOf(context).languageCode,
                ).add_Hm().format(date.toLocal()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
            Text(record['description'] as String),
            if (record['phase'] == 'proposal')
              _ProposalDetails(analysis: record['analysis'] as Map),
            if (record['phase'] == 'issue')
              Text(record['done'] == true ? l.statusDone : l.statusOpen),
            if (photo != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64Decode(photo),
                  semanticLabel: l.issuePhoto,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, error, stack) => Text(l.photoLoadFailure),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Measurements extends StatefulWidget {
  const _Measurements({
    required this.repository,
    required this.objectId,
    required this.name,
  });
  final JournalRepository repository;
  final int objectId;
  final String name;
  @override
  State<_Measurements> createState() => _MeasurementsState();
}

class _MeasurementsState extends State<_Measurements> {
  final _form = GlobalKey<FormState>();
  final _length = TextEditingController(),
      _width = TextEditingController(),
      _height = TextEditingController();
  RoomKind _kind = RoomKind.other;
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    for (final c in [_length, _width, _height]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.addRoom(
        widget.objectId,
        name: widget.name,
        kind: _kind,
        lengthMm: parseMetresToMm(_length.text)!,
        widthMm: parseMetresToMm(_width.text)!,
        heightMm: parseMetresToMm(_height.text)!,
        wish: '',
      );
    } catch (_) {
      if (mounted) setState(() => _error = 'save');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final number = NumberFormat(
      '0.###',
      Localizations.localeOf(context).languageCode,
    );
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l.measurements,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          StreamBuilder<List<Entry>>(
            stream: widget.repository.watchRooms(widget.objectId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l.objectsLoadFailure),
                );
              }
              return Column(
                children: [
                  for (final room in snapshot.data ?? <Entry>[])
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            room.value['name'] as String,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if ((room.value['wish'] as String).isNotEmpty)
                            Text(room.value['wish'] as String),
                          Text(
                            l.floorArea(
                              number.format(
                                (room.value['lengthMm'] as int) *
                                    (room.value['widthMm'] as int) /
                                    1000000,
                              ),
                            ),
                          ),
                          Text(
                            l.wallArea(
                              number.format(
                                2 *
                                    ((room.value['lengthMm'] as int) +
                                        (room.value['widthMm'] as int)) *
                                    (room.value['heightMm'] as int) /
                                    1000000,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          ExpansionTile(
            title: Text('${l.roomType} · ${l.measurements}'),
            childrenPadding: const EdgeInsets.all(16),
            children: [
              Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.roomType),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final kind in RoomKind.values)
                          ChoiceChip(
                            label: Text(roomKindLabel(l, kind)),
                            selected: _kind == kind,
                            onSelected: _busy
                                ? null
                                : (_) => setState(() => _kind = kind),
                          ),
                      ],
                    ),
                    for (final entry in [
                      (l.lengthMetres, _length),
                      (l.widthMetres, _width),
                      (l.heightMetres, _height),
                    ]) ...[
                      const SizedBox(height: 16),
                      Text(entry.$1),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: entry.$2,
                        enabled: !_busy,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(hintText: entry.$1),
                        validator: (v) => parseMetresToMm(v ?? '') == null
                            ? l.invalidDimension
                            : null,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(l.roomGeometryNote),
                    if (_error != null) Text(l.saveFailure),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _busy ? null : _save,
                      child: Text(_busy ? l.pleaseWait : l.addMeasurements),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryEntryForm extends StatefulWidget {
  const HistoryEntryForm({
    super.key,
    required this.repository,
    this.objectId,
    this.pickPhoto,
  });
  final JournalRepository repository;
  final Future<XFile?> Function(ImageSource)? pickPhoto;
  final int? objectId;
  @override
  State<HistoryEntryForm> createState() => _HistoryEntryFormState();
}

class _HistoryEntryFormState extends State<HistoryEntryForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(), _text = TextEditingController();
  String? _photo, _error;
  String _phase = 'progress';
  bool _busy = false;
  bool get _creating => widget.objectId == null;
  @override
  void dispose() {
    _name.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final file = widget.pickPhoto != null
          ? await widget.pickPhoto!(source)
          : await ImagePicker().pickImage(
              source: source,
              maxWidth: 1600,
              maxHeight: 1600,
              imageQuality: 80,
              requestFullMetadata: false,
            );
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 8 * 1024 * 1024) throw StateError('Image too large');
        if (mounted) setState(() => _photo = base64Encode(bytes));
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'photo');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    if ((_creating || _phase == 'before') && _photo == null) {
      setState(() => _error = 'requiredPhoto');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = _creating
          ? await widget.repository.createRenovation(
              _name.text,
              _text.text,
              _photo!,
            )
          : await widget.repository.addHistory(
              widget.objectId!,
              _text.text,
              phase: _phase,
              photo: _photo,
            );
      if (mounted) Navigator.pop(context, id);
    } catch (_) {
      if (mounted) setState(() => _error = 'save');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(title: Text(_creating ? l.newProject : l.addUpdate)),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_creating) ...[
                        LabeledField(label: l.objectName, controller: _name),
                        const SizedBox(height: 16),
                      ] else ...[
                        Text(l.entryStage),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final phase in [
                              'before',
                              'progress',
                              'result',
                            ])
                              ChoiceChip(
                                label: Text(phaseLabel(l, phase)),
                                selected: _phase == phase,
                                onSelected: _busy
                                    ? null
                                    : (_) => setState(() => _phase = phase),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      LabeledField(
                        label: _creating
                            ? l.projectWish
                            : l.issueDescriptionLabel,
                        controller: _text,
                        maxLines: 4,
                        maxLength: 2000,
                      ),
                      const SizedBox(height: 16),
                      if (_photo != null) ...[
                        Image.memory(
                          base64Decode(_photo!),
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                        TextButton(
                          onPressed: _busy
                              ? null
                              : () => setState(() => _photo = null),
                          child: Text(l.removePhoto),
                        ),
                      ],
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _pick(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: Text(l.takePhoto),
                          ),
                          OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _pick(ImageSource.gallery),
                            icon: const Icon(Icons.photo_outlined),
                            label: Text(l.fromGallery),
                          ),
                        ],
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          switch (_error) {
                            'photo' => l.photoPickFailure,
                            'requiredPhoto' => l.photoRequired,
                            _ => l.saveIssueFailure,
                          },
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _save,
                        child: Text(_busy ? l.pleaseWait : l.save),
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
