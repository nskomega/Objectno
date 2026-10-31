import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo =
          widget.repository ?? JournalRepository(await openJournalDatabase());
      final mode = await repo.readTheme();
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
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  Future<void> _setTheme(ThemeMode mode) async {
    await _repository!.saveTheme(mode.name);
    if (mounted) setState(() => _theme = mode);
  }

  @override
  void dispose() {
    if (widget.repository == null) _repository?.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Объектно',
    locale: const Locale('ru'),
    supportedLocales: const [Locale('ru')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    debugShowCheckedModeBanner: false,
    theme: objectnoTheme(Brightness.light),
    darkTheme: objectnoTheme(Brightness.dark),
    themeMode: _theme,
    home: _repository == null
        ? Scaffold(
            body: Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Не удалось открыть данные'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
            ),
          )
        : JournalPage(
            repository: _repository!,
            themeMode: _theme,
            onThemeChanged: _setTheme,
          ),
  );
}
