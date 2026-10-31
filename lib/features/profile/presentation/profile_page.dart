import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../../design_system/components/labeled_field.dart';
import '../../auth/application/session_controller.dart';
import '../../auth/presentation/account_page.dart';
import '../../journal/data/journal_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.repository,
    required this.session,
    required this.themeMode,
    required this.languageCode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });
  final JournalRepository repository;
  final SessionController session;
  final ThemeMode themeMode;
  final String languageCode;
  final Future<void> Function(ThemeMode) onThemeChanged;
  final Future<void> Function(String) onLanguageChanged;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    try {
      final name = await widget.repository.readProfileName();
      if (mounted) setState(() => _name = name);
    } catch (_) {
      // Profile preferences must not prevent access to account recovery/settings.
    }
  }

  Future<void> _editName() async {
    final value = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => _NamePage(initial: _name ?? '')),
    );
    if (value == null) return;
    try {
      await widget.repository.saveProfileName(value);
      if (mounted) setState(() => _name = value.trim());
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.saveFailure)));
      }
    }
  }

  Future<void> _choose<T>(
    String title,
    Map<T, String> options,
    T selected,
    Future<void> Function(T) save,
  ) => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => _SelectionPage<T>(
        title: title,
        options: options,
        selected: selected,
        save: save,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final registered =
        widget.session.user != null && !widget.session.user!.isGuest;
    final themes = {
      ThemeMode.system: l.followSystem,
      ThemeMode.light: l.lightTheme,
      ThemeMode.dark: l.darkTheme,
    };
    final languages = languageNames(l);
    return Scaffold(
      appBar: AppBar(title: Text(l.profile)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person_outline,
                              size: 32,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _name ?? (!registered ? l.guestProfile : l.profile),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (registered) Text(widget.session.user!.email),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: _editName,
                            child: Text(l.editProfileName),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(l.settings, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.palette_outlined,
                        title: l.appearance,
                        value: themes[widget.themeMode]!,
                        onTap: () => _choose(
                          l.appearance,
                          themes,
                          widget.themeMode,
                          widget.onThemeChanged,
                        ),
                      ),
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      _SettingsRow(
                        icon: Icons.language_outlined,
                        title: l.language,
                        value: languages[widget.languageCode]!,
                        onTap: () => _choose(
                          l.language,
                          languages,
                          widget.languageCode,
                          widget.onLanguageChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: _SettingsRow(
                    icon: Icons.manage_accounts_outlined,
                    title: l.account,
                    value: !registered ? l.signIn : widget.session.user!.email,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => AccountPage(
                          session: widget.session,
                          wipeLocal: widget.repository.clearAccount,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.localStorageNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });
  final IconData icon;
  final String title, value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}

class _SelectionPage<T> extends StatefulWidget {
  const _SelectionPage({
    required this.title,
    required this.options,
    required this.selected,
    required this.save,
  });
  final String title;
  final Map<T, String> options;
  final T selected;
  final Future<void> Function(T) save;
  @override
  State<_SelectionPage<T>> createState() => _SelectionPageState<T>();
}

class _SelectionPageState<T> extends State<_SelectionPage<T>> {
  bool _busy = false;
  Future<void> _select(T value) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.save(value);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.saveFailure)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Column(
                    children: [
                      for (final option in widget.options.entries)
                        Semantics(
                          selected: option.key == widget.selected,
                          child: InkWell(
                            onTap: _busy ? null : () => _select(option.key),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.value,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    option.key == widget.selected
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: option.key == widget.selected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_busy) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _NamePage extends StatefulWidget {
  const _NamePage({required this.initial});
  final String initial;
  @override
  State<_NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<_NamePage> {
  final _form = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.editProfileName)),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledField(
                label: context.l10n.profileName,
                controller: _controller,
                autofocus: true,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    Navigator.pop(context, _controller.text);
                  }
                },
                child: Text(context.l10n.save),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
