import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sembast/sembast.dart';
import '../../../design_system/components/labeled_field.dart';
import '../data/journal_repository.dart';

typedef Entry = RecordSnapshot<int, Map<String, Object?>>;

void showFailure(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Не удалось сохранить изменение. Попробуйте ещё раз.'),
    ),
  );
}

class JournalPage extends StatelessWidget {
  const JournalPage({
    super.key,
    required this.repository,
    required this.themeMode,
    required this.onThemeChanged,
  });
  final JournalRepository repository;
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeChanged;

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
      title: const Text('Объектно'),
      actions: [
        PopupMenuButton<ThemeMode>(
          tooltip: 'Тема оформления',
          initialValue: themeMode,
          icon: const Icon(Icons.contrast_outlined),
          onSelected: (mode) async {
            try {
              await onThemeChanged(mode);
            } catch (_) {
              if (context.mounted) showFailure(context);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Text('Как в системе'),
            ),
            PopupMenuItem(value: ThemeMode.light, child: Text('Светлая')),
            PopupMenuItem(value: ThemeMode.dark, child: Text('Тёмная')),
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
                return const _Message(
                  title: 'Не удалось загрузить объекты',
                  text: 'Перезапустите приложение и попробуйте снова.',
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
                    'Всё по объектам',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Фиксируйте замечания, добавляйте фотографии и отмечайте исправленное.',
                  ),
                  const SizedBox(height: 24),
                  if (entries.isEmpty)
                    const _Message(
                      title: 'Начните с первого объекта',
                      text:
                          'Добавьте квартиру, комнату или другой объект, который вы осматриваете.',
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
        label: const Text('Создать объект'),
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
    title: const Text('Новый объект'),
    content: SingleChildScrollView(
      child: Form(
        key: form,
        child: LabeledField(
          label: 'Название объекта',
          controller: controller,
          hint: 'Например, квартира на Лесной',
          autofocus: true,
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Отмена'),
      ),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            Navigator.pop(context, controller.text.trim());
          }
        },
        child: const Text('Создать'),
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
        title: const Text('Удалить объект?'),
        content: const Text(
          'Объект, все его замечания и фотографии будут удалены с этого устройства.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
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
          tooltip: 'Удалить объект',
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
                return const _Message(
                  title: 'Не удалось загрузить замечания',
                  text: 'Попробуйте открыть объект повторно.',
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
                    'Замечания',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < 3; i++)
                        ChoiceChip(
                          label: Text(['Все', 'Открыто', 'Исправлено'][i]),
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
                          ? 'Пока нет замечаний'
                          : 'Здесь пока пусто',
                      text: all.isEmpty
                          ? 'Добавьте описание и фотографию того, что нужно исправить.'
                          : 'Попробуйте выбрать другой фильтр.',
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
                                    semanticLabel: 'Фотография замечания',
                                    errorBuilder: (_, _, _) => const Text(
                                      'Не удалось открыть фотографию',
                                    ),
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
                                      ? 'Снова открыть'
                                      : 'Отметить исправленным',
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
        label: const Text('Добавить замечание'),
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
        done ? 'Исправлено' : 'Открыто',
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
        setState(
          () => error =
              'Не удалось добавить фото. Проверьте разрешение и выберите файл до 8 МБ.',
        );
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
          error =
              'Не удалось сохранить. Ваш текст остался в форме. Попробуйте ещё раз.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: Scaffold(
      appBar: AppBar(title: const Text('Новое замечание')),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: busy ? null : _save,
            child: Text(busy ? 'Подождите…' : 'Сохранить замечание'),
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
                    label: 'Что нужно исправить?',
                    controller: controller,
                    hint: 'Опишите место и проблему',
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
                      child: const Text('Убрать фотографию'),
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
                        label: const Text('Снять фото'),
                      ),
                      OutlinedButton.icon(
                        onPressed: busy
                            ? null
                            : () => _pick(ImageSource.gallery),
                        icon: const Icon(Icons.photo_outlined),
                        label: const Text('Из галереи'),
                      ),
                    ],
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  const Text(
                    'Данные и фотографии сохраняются на этом устройстве. Синхронизация пока недоступна.',
                  ),
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
