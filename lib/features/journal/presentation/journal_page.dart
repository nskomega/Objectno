import '../../../l10n/l10n.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sembast/sembast.dart';
import '../../../design_system/components/labeled_field.dart';
import '../data/journal_repository.dart';

typedef Entry = RecordSnapshot<int, Map<String, Object?>>;

void showFailure(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.l10n.saveFailure)));
}

class JournalPage extends StatelessWidget {
  const JournalPage({
    super.key,
    required this.repository,
    required this.themeMode,
    required this.onThemeChanged,
    this.languageCode = 'system',
    this.onLanguageChanged,
    this.onAccount,
  });
  final VoidCallback? onAccount;
  final JournalRepository repository;
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeChanged;
  final String languageCode;
  final Future<void> Function(String)? onLanguageChanged;

  Future<void> _create(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _ObjectDialog(),
    );
    if (name == null) return;
    try {
      await repository.addObject(name);
    } catch (_) {
      if (context.mounted) showFailure(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n.appName),
      actions: [
        if (onAccount != null)
          IconButton(
            onPressed: onAccount,
            tooltip: context.l10n.account,
            icon: const Icon(Icons.person_outline),
          ),
        if (onLanguageChanged != null)
          PopupMenuButton<String>(
            tooltip: context.l10n.language,
            initialValue: languageCode,
            icon: const Icon(Icons.language_outlined),
            onSelected: (code) async {
              try {
                await onLanguageChanged!(code);
              } catch (_) {
                if (context.mounted) showFailure(context);
              }
            },
            itemBuilder: (context) => languageNames(context.l10n).entries
                .map(
                  (entry) =>
                      PopupMenuItem(value: entry.key, child: Text(entry.value)),
                )
                .toList(),
          ),
        PopupMenuButton<ThemeMode>(
          tooltip: context.l10n.appearance,
          initialValue: themeMode,
          icon: const Icon(Icons.contrast_outlined),
          onSelected: (mode) async {
            try {
              await onThemeChanged(mode);
            } catch (_) {
              if (context.mounted) showFailure(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Text(context.l10n.followSystem),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: Text(context.l10n.lightTheme),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Text(context.l10n.darkTheme),
            ),
          ],
        ),
      ],
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: StreamBuilder<List<Entry>>(
            stream: repository.watchObjects(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _Message(
                  title: context.l10n.objectsLoadFailure,
                  text: context.l10n.restartRetry,
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final entries = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
                children: [
                  Text(
                    context.l10n.objectsHeading,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.objectsIntro),
                  const SizedBox(height: 24),
                  if (entries.isEmpty)
                    _Message(
                      title: context.l10n.emptyObjectsTitle,
                      text: context.l10n.emptyObjectsBody,
                    ),
                  for (final entry in entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => IssuesPage(
                                repository: repository,
                                objectId: entry.key,
                                objectName: entry.value['name'] as String,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.home_work_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    entry.value['name'] as String,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.all(16),
      child: FilledButton.icon(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.createObject),
      ),
    ),
  );
}

class _ObjectDialog extends StatefulWidget {
  const _ObjectDialog();
  @override
  State<_ObjectDialog> createState() => _ObjectDialogState();
}

class _ObjectDialogState extends State<_ObjectDialog> {
  final controller = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.newObject),
    content: SingleChildScrollView(
      child: Form(
        key: form,
        child: LabeledField(
          label: context.l10n.objectName,
          controller: controller,
          hint: context.l10n.objectNameHint,
          autofocus: true,
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            Navigator.pop(context, controller.text.trim());
          }
        },
        child: Text(context.l10n.create),
      ),
    ],
  );
}

class IssuesPage extends StatefulWidget {
  const IssuesPage({
    super.key,
    required this.repository,
    required this.objectId,
    required this.objectName,
  });
  final JournalRepository repository;
  final int objectId;
  final String objectName;
  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  int filter = 0;
  bool changing = false;
  Future<void> _deleteObject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteObjectTitle),
        content: Text(context.l10n.deleteObjectBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.repository.deleteObject(widget.objectId);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) showFailure(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.objectName),
      actions: [
        IconButton(
          tooltip: context.l10n.deleteObject,
          onPressed: _deleteObject,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: StreamBuilder<List<Entry>>(
            stream: widget.repository.watchIssues(widget.objectId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _Message(
                  title: context.l10n.issuesLoadFailure,
                  text: context.l10n.reopenObject,
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final all = snapshot.data!;
              final visible = all
                  .where(
                    (e) =>
                        filter == 0 ||
                        (e.value['done'] == true) == (filter == 2),
                  )
                  .toList();
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
                children: [
                  Text(
                    context.l10n.issuesHeading,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < 3; i++)
                        ChoiceChip(
                          label: Text(
                            [
                              context.l10n.filterAll,
                              context.l10n.statusOpen,
                              context.l10n.statusDone,
                            ][i],
                          ),
                          selected: filter == i,
                          labelStyle: TextStyle(
                            color: filter == i
                                ? const Color(0xFF21150C)
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          checkmarkColor: const Color(0xFF21150C),
                          onSelected: (_) => setState(() => filter = i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (visible.isEmpty)
                    _Message(
                      title: all.isEmpty
                          ? context.l10n.noIssuesTitle
                          : context.l10n.noMatchesTitle,
                      text: all.isEmpty
                          ? context.l10n.noIssuesBody
                          : context.l10n.noMatchesBody,
                    ),
                  for (final entry in visible)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _Status(
                                  done: entry.value['done'] == true,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                entry.value['description'] as String,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if (entry.value['photo']
                                  case final String photo) ...[
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(photo),
                                    height: 200,
                                    fit: BoxFit.cover,
                                    semanticLabel: context.l10n.issuePhoto,
                                    errorBuilder: (_, _, _) =>
                                        Text(context.l10n.photoLoadFailure),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: changing
                                    ? null
                                    : () async {
                                        setState(() => changing = true);
                                        try {
                                          await widget.repository.setDone(
                                            entry.key,
                                            entry.value['done'] != true,
                                          );
                                        } catch (_) {
                                          if (context.mounted) {
                                            showFailure(context);
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() => changing = false);
                                          }
                                        }
                                      },
                                icon: Icon(
                                  entry.value['done'] == true
                                      ? Icons.undo
                                      : Icons.check,
                                ),
                                label: Text(
                                  entry.value['done'] == true
                                      ? context.l10n.reopenIssue
                                      : context.l10n.markDone,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.all(16),
      child: FilledButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => _IssueForm(
              repository: widget.repository,
              objectId: widget.objectId,
            ),
          ),
        ),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addIssue),
      ),
    ),
  );
}

class _Status extends StatelessWidget {
  const _Status({required this.done});
  final bool done;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = done
        ? (dark ? const Color(0xFF89D9A1) : const Color(0xFF176A35))
        : Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        done ? context.l10n.statusDone : context.l10n.statusOpen,
        style: TextStyle(color: color),
      ),
    );
  }
}

class _IssueForm extends StatefulWidget {
  const _IssueForm({required this.repository, required this.objectId});
  final JournalRepository repository;
  final int objectId;
  @override
  State<_IssueForm> createState() => _IssueFormState();
}

class _IssueFormState extends State<_IssueForm> {
  final controller = TextEditingController();
  final form = GlobalKey<FormState>();
  String? photo;
  bool busy = false;
  String? error;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 80,
        requestFullMetadata: false,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 8 * 1024 * 1024) throw StateError('Image too large');
        if (mounted) setState(() => photo = base64Encode(bytes));
      }
    } catch (_) {
      if (mounted) {
        setState(() => error = 'photo');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _save() async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.repository.addIssue(
        widget.objectId,
        controller.text,
        photo: photo,
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          error = 'save';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: Scaffold(
      appBar: AppBar(title: Text(context.l10n.newIssue)),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: busy ? null : _save,
            child: Text(
              busy ? context.l10n.pleaseWait : context.l10n.saveIssue,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: form,
              child: ListView(
                key: const ValueKey("issue-form-list"),
                padding: const EdgeInsets.all(16),
                children: [
                  LabeledField(
                    label: context.l10n.issueDescriptionLabel,
                    controller: controller,
                    hint: context.l10n.issueDescriptionHint,
                    maxLines: 5,
                    maxLength: 2000,
                  ),
                  const SizedBox(height: 16),
                  if (photo != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(photo!),
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextButton(
                      onPressed: busy
                          ? null
                          : () => setState(() => photo = null),
                      child: Text(context.l10n.removePhoto),
                    ),
                  ],
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: busy
                            ? null
                            : () => _pick(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(context.l10n.takePhoto),
                      ),
                      OutlinedButton.icon(
                        onPressed: busy
                            ? null
                            : () => _pick(ImageSource.gallery),
                        icon: const Icon(Icons.photo_outlined),
                        label: Text(context.l10n.fromGallery),
                      ),
                    ],
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          error == 'photo'
                              ? context.l10n.photoPickFailure
                              : context.l10n.saveIssueFailure,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(context.l10n.localStorageNote),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.text});
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(text),
      ],
    ),
  );
}
