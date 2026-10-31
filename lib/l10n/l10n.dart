import 'package:flutter/widgets.dart';
import 'generated/app_localizations.dart';
export 'generated/app_localizations.dart';

extension ObjectnoLocalization on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

Map<String, String> languageNames(AppLocalizations l10n) => {
  'system': l10n.followSystem,
  'ru': l10n.languageRussian,
  'en': l10n.languageEnglish,
  'es': l10n.languageSpanish,
  'fr': l10n.languageFrench,
  'de': l10n.languageGerman,
  'it': l10n.languageItalian,
  'pt': l10n.languagePortuguese,
  'tr': l10n.languageTurkish,
};
