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
      'De la première photo et de l’idée au suivi des travaux et au résultat final.';

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

  @override
  String get account => 'Compte';

  @override
  String get signIn => 'Se connecter';

  @override
  String get register => 'Créer un compte';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountBody =>
      'Saisissez votre mot de passe pour supprimer définitivement votre compte et ses données sur cet appareil.';

  @override
  String get authUnavailable =>
      'La connexion est indisponible. Vous pouvez continuer à utiliser le journal local.';

  @override
  String get authFailure => 'La demande a échoué. Réessayez.';

  @override
  String get authInvalidCredentials =>
      'Vérifiez votre adresse e-mail et votre mot de passe.';

  @override
  String get authPasswordRule =>
      'Utilisez au moins 12 caractères et au maximum 72 octets UTF-8.';

  @override
  String get authNetwork => 'Échec de connexion. Réessayez.';

  @override
  String get authStorage => 'Le stockage sécurisé est indisponible. Réessayez.';

  @override
  String get authLocalNote =>
      'Les données du compte restent sur cet appareil ; la synchronisation est indisponible. Les entrées invité restent séparées.';

  @override
  String get rooms => 'Pièces';

  @override
  String get newRoom => 'Ajouter une pièce';

  @override
  String get roomType => 'Type de pièce';

  @override
  String get roomName => 'Nom de la pièce';

  @override
  String get lengthMetres => 'Longueur, m';

  @override
  String get widthMetres => 'Largeur, m';

  @override
  String get heightMetres => 'Hauteur, m';

  @override
  String get renovationWish => 'Que souhaitez-vous modifier ?';

  @override
  String get saveRoom => 'Enregistrer la pièce';

  @override
  String get invalidDimension =>
      'Saisissez une dimension de 0,001 à 1000 mètres (3 décimales maximum).';

  @override
  String get roomGeometryNote =>
      'Pièce rectangulaire. Les ouvertures ne sont pas encore déduites ; confirmez portes, fenêtres et zones de travaux avant de calculer les matériaux.';

  @override
  String floorArea(String value) {
    return 'Sol : $value m²';
  }

  @override
  String wallArea(String value) {
    return 'Murs avant déduction des ouvertures : $value m²';
  }

  @override
  String get roomBathroom => 'Salle de bains';

  @override
  String get roomToilet => 'Toilettes';

  @override
  String get roomKitchen => 'Cuisine';

  @override
  String get roomBedroom => 'Chambre';

  @override
  String get roomLiving => 'Salon';

  @override
  String get roomOther => 'Autre';

  @override
  String get profile => 'Profil';

  @override
  String get propertiesTab => 'Biens';

  @override
  String get guestProfile => 'Profil invité';

  @override
  String get profileName => 'Votre nom';

  @override
  String get editProfileName => 'Modifier le nom';

  @override
  String get settings => 'Réglages';

  @override
  String get save => 'Enregistrer';

  @override
  String get projectHistory => 'Historique des travaux';

  @override
  String get beforeStage => 'Avant';

  @override
  String get proposalStage => 'Propositions';

  @override
  String get progressStage => 'Avancement';

  @override
  String get resultStage => 'Résultat';

  @override
  String get addUpdate => 'Ajouter une étape';

  @override
  String get newProject => 'Nouveau projet de rénovation';

  @override
  String get projectWish => 'Que souhaitez-vous modifier ?';

  @override
  String get measurements => 'Mesures du projet';

  @override
  String get addMeasurements => 'Enregistrer les mesures';

  @override
  String get proposalPending =>
      'L’analyse des photos et la génération de propositions ne sont pas encore connectées. Les solutions apparaîtront ici.';

  @override
  String get photoRequired => 'Ajoutez une photo de l’état initial.';

  @override
  String get entryStage => 'Étape';

  @override
  String get historyEmpty =>
      'Ajoutez une photo initiale et vos souhaits pour commencer l’historique.';

  @override
  String get analyzePhoto => 'Obtenir une proposition';

  @override
  String get analysisWorking =>
      'Analyse sur votre Mac. Cela peut prendre une minute.';

  @override
  String get analysisDraft =>
      'Ébauche préliminaire. Confirmez les observations ; ce ne sont pas des mesures ni un guide définitif.';

  @override
  String get analysisFailed =>
      'Proposition indisponible. Vérifiez le serveur local et réessayez.';

  @override
  String get analysisNotRoom =>
      'Aucune pièce reconnue. Ajoutez une photo initiale de la pièce.';

  @override
  String get analysisObservations => 'Visible sur la photo';

  @override
  String get analysisSteps => 'Étapes proposées';

  @override
  String get analysisMaterials => 'Catégories de matériaux';

  @override
  String get analysisQuestions => 'Questions';

  @override
  String get analysisUnknowns => 'Inconnues';

  @override
  String get openings => 'Ouvertures des portes et fenêtres';

  @override
  String get addOpening => 'Ajouter une ouverture';

  @override
  String get openingX => 'Distance du bord gauche, m';

  @override
  String get openingY => 'Hauteur depuis le sol, m';

  @override
  String get openingHelp =>
      'Mesurez l’ouverture, pas le vantail. Murs 1 et 3 : longueur ; 2 et 4 : largeur. Comptez depuis la gauche en regardant de l’intérieur. Tableaux exclus.';

  @override
  String get openingInvalid =>
      'Vérifiez les dimensions : les ouvertures ne doivent ni se chevaucher ni dépasser du mur.';

  @override
  String netWallArea(String value) {
    return 'Murs hors ouvertures : $value m²';
  }

  @override
  String wallNumber(int number) {
    return 'Mur $number';
  }

  @override
  String get estimateStage => 'Calcul des matériaux';

  @override
  String get calculateMaterials => 'Calculer le matériau';

  @override
  String get estimateSourceNote =>
      'Saisissez la consommation du produit indiquée sur son étiquette ou sa documentation. Aucun catalogue connecté ; vous fournissez et vérifiez ces données.';

  @override
  String get selectedSurfaces => 'Surfaces à traiter';

  @override
  String get floorSurface => 'Sol';

  @override
  String get ceilingSurface => 'Plafond';

  @override
  String get productReference => 'Nom et référence du produit';

  @override
  String get consumptionSource => 'Source de consommation';

  @override
  String get consumptionPerLayer => 'Consommation par m² par couche';

  @override
  String get packageSize => 'Quantité par emballage';

  @override
  String get materialLayers => 'Nombre de couches';

  @override
  String get wastePercent => 'Marge, %';

  @override
  String get unitGrams => 'g';

  @override
  String get unitMillilitres => 'ml';

  @override
  String get unitPieces => 'pièces';

  @override
  String estimateRequired(String value, String unit) {
    return 'Besoin : $value $unit';
  }

  @override
  String estimatePackages(int value) {
    return 'Emballages : $value';
  }

  @override
  String estimateArea(String value) {
    return 'Surface : $value m²';
  }

  @override
  String get estimateInvalid =>
      'Choisissez les surfaces et unités ; vérifiez consommation, emballage, couches et marge.';
}
