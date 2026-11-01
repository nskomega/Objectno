// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure =>
      'Die Änderung konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get appearance => 'Darstellung';

  @override
  String get followSystem => 'Wie im System';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get objectsLoadFailure => 'Objekte konnten nicht geladen werden';

  @override
  String get restartRetry => 'Starte die App neu und versuche es erneut.';

  @override
  String get objectsHeading => 'Deine Objekte';

  @override
  String get objectsIntro =>
      'Vom ersten Foto und der Idee bis zum Baufortschritt und fertigen Ergebnis.';

  @override
  String get emptyObjectsTitle => 'Füge dein erstes Objekt hinzu';

  @override
  String get emptyObjectsBody =>
      'Füge eine Wohnung, einen Raum oder ein anderes zu prüfendes Objekt hinzu.';

  @override
  String get createObject => 'Objekt hinzufügen';

  @override
  String get newObject => 'Neues Objekt';

  @override
  String get objectName => 'Objektname';

  @override
  String get objectNameHint => 'Zum Beispiel Wohnung in der Eichenstraße';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String get deleteObjectTitle => 'Objekt löschen?';

  @override
  String get deleteObjectBody =>
      'Das Objekt sowie alle zugehörigen Mängel und Fotos werden von diesem Gerät gelöscht.';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteObject => 'Objekt löschen';

  @override
  String get issuesLoadFailure => 'Mängel konnten nicht geladen werden';

  @override
  String get reopenObject => 'Versuche, das Objekt erneut zu öffnen.';

  @override
  String get issuesHeading => 'Mängel';

  @override
  String get filterAll => 'Alle';

  @override
  String get statusOpen => 'Offen';

  @override
  String get statusDone => 'Behoben';

  @override
  String get noIssuesTitle => 'Noch keine Mängel';

  @override
  String get noMatchesTitle => 'Hier ist noch nichts';

  @override
  String get noIssuesBody =>
      'Füge eine Beschreibung und ein Foto des Mangels hinzu.';

  @override
  String get noMatchesBody => 'Wähle einen anderen Filter.';

  @override
  String get issuePhoto => 'Foto des Mangels';

  @override
  String get photoLoadFailure => 'Foto konnte nicht geöffnet werden';

  @override
  String get reopenIssue => 'Wieder öffnen';

  @override
  String get markDone => 'Als behoben markieren';

  @override
  String get addIssue => 'Mangel hinzufügen';

  @override
  String get newIssue => 'Neuer Mangel';

  @override
  String get photoPickFailure =>
      'Foto konnte nicht hinzugefügt werden. Prüfe die Berechtigungen und wähle eine Datei bis 8 MB.';

  @override
  String get saveIssueFailure =>
      'Speichern fehlgeschlagen. Dein Text bleibt im Formular. Bitte erneut versuchen.';

  @override
  String get pleaseWait => 'Bitte warten…';

  @override
  String get saveIssue => 'Mangel speichern';

  @override
  String get issueDescriptionLabel => 'Was muss behoben werden?';

  @override
  String get issueDescriptionHint => 'Beschreibe die Stelle und den Mangel';

  @override
  String get removePhoto => 'Foto entfernen';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get fromGallery => 'Aus der Galerie';

  @override
  String get localStorageNote =>
      'Daten und Fotos werden auf diesem Gerät gespeichert. Synchronisierung ist noch nicht verfügbar.';

  @override
  String get requiredField => 'Dieses Feld ist erforderlich';

  @override
  String get databaseOpenFailure => 'Daten konnten nicht geöffnet werden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get language => 'App-Sprache';

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
  String get account => 'Konto';

  @override
  String get signIn => 'Anmelden';

  @override
  String get register => 'Konto erstellen';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get signOut => 'Abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountBody =>
      'Gib dein Passwort ein, um dein Konto und dessen Daten auf diesem Gerät dauerhaft zu löschen.';

  @override
  String get authUnavailable =>
      'Die Anmeldung ist nicht verfügbar. Das lokale Journal kann weiter genutzt werden.';

  @override
  String get authFailure =>
      'Die Anfrage ist fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authInvalidCredentials => 'Prüfe E-Mail und Passwort.';

  @override
  String get authPasswordRule =>
      'Mindestens 12 Zeichen und höchstens 72 UTF-8-Bytes verwenden.';

  @override
  String get authNetwork =>
      'Verbindung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authStorage =>
      'Sicherer Speicher ist nicht verfügbar. Bitte erneut versuchen.';

  @override
  String get authLocalNote =>
      'Kontodaten bleiben auf diesem Gerät; keine Synchronisierung verfügbar. Gasteinträge bleiben getrennt.';

  @override
  String get rooms => 'Räume';

  @override
  String get newRoom => 'Raum hinzufügen';

  @override
  String get roomType => 'Raumtyp';

  @override
  String get roomName => 'Raumname';

  @override
  String get lengthMetres => 'Länge, m';

  @override
  String get widthMetres => 'Breite, m';

  @override
  String get heightMetres => 'Höhe, m';

  @override
  String get renovationWish => 'Was möchtest du ändern?';

  @override
  String get saveRoom => 'Raum speichern';

  @override
  String get invalidDimension =>
      'Maß zwischen 0,001 und 1000 Metern eingeben (bis zu 3 Nachkommastellen).';

  @override
  String get roomGeometryNote =>
      'Rechteckiger Raum. Öffnungen sind noch nicht abgezogen; Türen, Fenster und Arbeitsflächen vor der Materialberechnung bestätigen.';

  @override
  String floorArea(String value) {
    return 'Boden: $value m²';
  }

  @override
  String wallArea(String value) {
    return 'Wände ohne Abzug der Öffnungen: $value m²';
  }

  @override
  String get roomBathroom => 'Badezimmer';

  @override
  String get roomToilet => 'WC';

  @override
  String get roomKitchen => 'Küche';

  @override
  String get roomBedroom => 'Schlafzimmer';

  @override
  String get roomLiving => 'Wohnzimmer';

  @override
  String get roomOther => 'Sonstiger';

  @override
  String get profile => 'Profil';

  @override
  String get propertiesTab => 'Objekte';

  @override
  String get guestProfile => 'Gastprofil';

  @override
  String get profileName => 'Dein Name';

  @override
  String get editProfileName => 'Namen ändern';

  @override
  String get settings => 'Einstellungen';

  @override
  String get save => 'Speichern';

  @override
  String get projectHistory => 'Renovierungsverlauf';

  @override
  String get beforeStage => 'Vorher';

  @override
  String get proposalStage => 'Vorschläge';

  @override
  String get progressStage => 'Baufortschritt';

  @override
  String get resultStage => 'Ergebnis';

  @override
  String get addUpdate => 'Eintrag hinzufügen';

  @override
  String get newProject => 'Neues Renovierungsprojekt';

  @override
  String get projectWish => 'Was möchtest du ändern?';

  @override
  String get measurements => 'Projektmaße';

  @override
  String get addMeasurements => 'Maße speichern';

  @override
  String get proposalPending =>
      'Fotoanalyse und Vorschlagserstellung sind noch nicht verbunden. Lösungen für dieses Projekt erscheinen hier.';

  @override
  String get photoRequired => 'Füge ein Foto des Ausgangszustands hinzu.';

  @override
  String get entryStage => 'Phase';

  @override
  String get historyEmpty =>
      'Füge ein Ausgangsfoto und deine Wünsche hinzu, um den Verlauf zu beginnen.';

  @override
  String get analyzePhoto => 'Vorschlag erstellen';

  @override
  String get analysisWorking =>
      'Analyse auf deinem Mac. Dies kann etwa eine Minute dauern.';

  @override
  String get analysisDraft =>
      'Vorläufiger Entwurf. Beobachtungen bestätigen; keine Vermessung oder fertige Renovierungsanleitung.';

  @override
  String get analysisFailed =>
      'Vorschlag fehlgeschlagen. Lokalen Server prüfen und erneut versuchen.';

  @override
  String get analysisNotRoom =>
      'Kein Raum erkannt. Ein Ausgangsfoto des Raums hinzufügen.';

  @override
  String get analysisObservations => 'Auf dem Foto sichtbar';

  @override
  String get analysisSteps => 'Vorgeschlagene Schritte';

  @override
  String get analysisMaterials => 'Materialkategorien';

  @override
  String get analysisQuestions => 'Fragen';

  @override
  String get analysisUnknowns => 'Unbekannte Angaben';
}
