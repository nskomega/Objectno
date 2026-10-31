// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure =>
      'Impossible d’enregistrer la modification. Réessayez.';

  @override
  String get appearance => 'Apparence';

  @override
  String get followSystem => 'Selon le système';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get objectsLoadFailure => 'Impossible de charger les biens';

  @override
  String get restartRetry => 'Redémarrez l’application et réessayez.';

  @override
  String get objectsHeading => 'Vos biens';

  @override
  String get objectsIntro =>
      'Notez les problèmes, ajoutez des photos et suivez les corrections.';

  @override
  String get emptyObjectsTitle => 'Ajoutez votre premier bien';

  @override
  String get emptyObjectsBody =>
      'Ajoutez un appartement, une pièce ou un autre bien à inspecter.';

  @override
  String get createObject => 'Ajouter un bien';

  @override
  String get newObject => 'Nouveau bien';

  @override
  String get objectName => 'Nom du bien';

  @override
  String get objectNameHint => 'Par exemple, appartement rue des Chênes';

  @override
  String get cancel => 'Annuler';

  @override
  String get create => 'Créer';

  @override
  String get deleteObjectTitle => 'Supprimer le bien ?';

  @override
  String get deleteObjectBody =>
      'Le bien, ses problèmes et ses photos seront supprimés de cet appareil.';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteObject => 'Supprimer le bien';

  @override
  String get issuesLoadFailure => 'Impossible de charger les problèmes';

  @override
  String get reopenObject => 'Essayez de rouvrir le bien.';

  @override
  String get issuesHeading => 'Problèmes';

  @override
  String get filterAll => 'Tous';

  @override
  String get statusOpen => 'À traiter';

  @override
  String get statusDone => 'Corrigé';

  @override
  String get noIssuesTitle => 'Aucun problème pour le moment';

  @override
  String get noMatchesTitle => 'Rien ici pour le moment';

  @override
  String get noIssuesBody =>
      'Ajoutez une description et une photo de ce qui doit être corrigé.';

  @override
  String get noMatchesBody => 'Essayez un autre filtre.';

  @override
  String get issuePhoto => 'Photo du problème';

  @override
  String get photoLoadFailure => 'Impossible d’ouvrir la photo';

  @override
  String get reopenIssue => 'Rouvrir';

  @override
  String get markDone => 'Marquer comme corrigé';

  @override
  String get addIssue => 'Ajouter un problème';

  @override
  String get newIssue => 'Nouveau problème';

  @override
  String get photoPickFailure =>
      'Impossible d’ajouter la photo. Vérifiez les autorisations et choisissez un fichier de 8 Mo maximum.';

  @override
  String get saveIssueFailure =>
      'Enregistrement impossible. Votre texte est conservé dans le formulaire. Réessayez.';

  @override
  String get pleaseWait => 'Veuillez patienter…';

  @override
  String get saveIssue => 'Enregistrer le problème';

  @override
  String get issueDescriptionLabel => 'Que faut-il corriger ?';

  @override
  String get issueDescriptionHint => 'Décrivez le lieu et le problème';

  @override
  String get removePhoto => 'Retirer la photo';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get fromGallery => 'Depuis la galerie';

  @override
  String get localStorageNote =>
      'Les données et les photos sont enregistrées sur cet appareil. La synchronisation n’est pas encore disponible.';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get databaseOpenFailure => 'Impossible d’ouvrir les données';

  @override
  String get retry => 'Réessayer';

  @override
  String get language => 'Langue de l’application';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageTurkish => 'Türkçe';
}
