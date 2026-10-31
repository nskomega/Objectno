import 'package:flutter/material.dart';

// Working tokens for the first prototype; visual approval is still pending.
ThemeData objectnoTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  const orange = Color(0xFFFF7900);
  final scheme = ColorScheme.fromSeed(seedColor: orange, brightness: brightness)
      .copyWith(
        primary: dark ? orange : const Color(0xFFB84700),
        onPrimary: dark ? const Color(0xFF21150C) : Colors.white,
        surface: dark ? const Color(0xFF222326) : const Color(0xFFFFFCF7),
        onSurface: dark ? const Color(0xFFF5F3EF) : const Color(0xFF24211E),
        outline: dark ? const Color(0xFF8C8D91) : const Color(0xFF79736D),
        outlineVariant: dark
            ? const Color(0xFF414247)
            : const Color(0xFFDED7CE),
      );
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark
        ? const Color(0xFF18191C)
        : const Color(0xFFF7F2EA),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.transparent,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: const Color(0xFF21150C),
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: shape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.primary),
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: shape,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      alignLabelWithHint: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: dark ? .22 : .08),
      shape: shape.copyWith(side: BorderSide(color: scheme.outlineVariant)),
    ),
    chipTheme: ChipThemeData(
      selectedColor: orange,
      side: BorderSide(color: scheme.outline),
      shape: shape,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    ),
  );
}
