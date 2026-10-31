import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import '../features/auth/application/session_controller.dart';
import '../features/journal/data/journal_repository.dart';
import '../features/journal/presentation/journal_page.dart';
import '../features/profile/presentation/profile_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
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
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _index,
      children: [
        JournalPage(repository: widget.repository),
        ProfilePage(
          repository: widget.repository,
          session: widget.session,
          themeMode: widget.themeMode,
          languageCode: widget.languageCode,
          onThemeChanged: widget.onThemeChanged,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ],
    ),
    bottomNavigationBar: DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _tab(
              0,
              context.l10n.propertiesTab,
              Icons.domain_outlined,
              Icons.domain,
            ),
            _tab(1, context.l10n.profile, Icons.person_outline, Icons.person),
          ],
        ),
      ),
    ),
  );
  Widget _tab(int index, String label, IconData icon, IconData selectedIcon) {
    final selected = _index == index;
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: InkWell(
          onTap: () => setState(() => _index = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? selectedIcon : icon, color: color),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
