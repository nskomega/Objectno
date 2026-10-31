import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import '../design_system/theme/objectno_theme.dart';
import '../features/journal/data/database.dart';
import '../features/journal/data/journal_repository.dart';
import '../features/journal/presentation/journal_page.dart';

class ObjectnoApp extends StatefulWidget {
  const ObjectnoApp({super.key, this.repository});
  final JournalRepository? repository;
  @override
  State<ObjectnoApp> createState() => _ObjectnoAppState();
}

class _ObjectnoAppState extends State<ObjectnoApp> {
  JournalRepository? _repository;
  Object? _error;
  ThemeMode _theme = ThemeMode.system;
  String _language = 'system';
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    JournalRepository? repo;
    try {
      repo =
          widget.repository ?? JournalRepository(await openJournalDatabase());
      final mode = await repo.readTheme();
      final language = await repo.readLanguage();
      if (!mounted) {
        if (widget.repository == null) await repo.database.close();
        return;
      }
      setState(() {
        _repository = repo;
        _theme = ThemeMode.values.firstWhere(
          (m) => m.name == mode,
          orElse: () => ThemeMode.system,
        );
        _language =
            AppLocalizations.supportedLocales.any(
              (locale) => locale.languageCode == language,
            )
            ? language
            : 'system';
        _error = null;
      });
    } catch (error) {
      if (widget.repository == null) await repo?.database.close();
      if (mounted) setState(() => _error = error);
    }
  }

  Future<void> _setTheme(ThemeMode mode) async {
    await _repository!.saveTheme(mode.name);
    if (mounted) setState(() => _theme = mode);
  }

  Future<void> _setLanguage(String code) async {
    if (code != 'system' &&
        !AppLocalizations.supportedLocales.any(
          (locale) => locale.languageCode == code,
        )) {
      return;
    }
    await _repository!.saveLanguage(code);
    if (mounted) setState(() => _language = code);
  }

  @override
  void dispose() {
    if (widget.repository == null) _repository?.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => context.l10n.appName,
    locale: _language == 'system' ? null : Locale(_language),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    debugShowCheckedModeBanner: false,
    theme: objectnoTheme(Brightness.light),
    darkTheme: objectnoTheme(Brightness.dark),
    themeMode: _theme,
    home: Builder(
      builder: (context) => _repository == null
          ? Scaffold(
              body: Center(
                child: _error == null
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(context.l10n.databaseOpenFailure),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _load,
                            child: Text(context.l10n.retry),
                          ),
                        ],
                      ),
              ),
            )
          : JournalPage(
              repository: _repository!,
              themeMode: _theme,
              onThemeChanged: _setTheme,
              languageCode: _language,
              onLanguageChanged: _setLanguage,
            ),
    ),
  );
}
