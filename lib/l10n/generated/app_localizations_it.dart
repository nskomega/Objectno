// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure => 'Impossibile salvare la modifica. Riprova.';

  @override
  String get appearance => 'Aspetto';

  @override
  String get followSystem => 'Come il sistema';

  @override
  String get lightTheme => 'Chiaro';

  @override
  String get darkTheme => 'Scuro';

  @override
  String get objectsLoadFailure => 'Impossibile caricare gli immobili';

  @override
  String get restartRetry => 'Riavvia l’app e riprova.';

  @override
  String get objectsHeading => 'I tuoi immobili';

  @override
  String get objectsIntro =>
      'Registra i problemi, aggiungi foto e segna le correzioni.';

  @override
  String get emptyObjectsTitle => 'Aggiungi il tuo primo immobile';

  @override
  String get emptyObjectsBody =>
      'Aggiungi un appartamento, una stanza o un altro immobile da ispezionare.';

  @override
  String get createObject => 'Aggiungi immobile';

  @override
  String get newObject => 'Nuovo immobile';

  @override
  String get objectName => 'Nome dell’immobile';

  @override
  String get objectNameHint => 'Ad esempio, appartamento in via Roma';

  @override
  String get cancel => 'Annulla';

  @override
  String get create => 'Crea';

  @override
  String get deleteObjectTitle => 'Eliminare l’immobile?';

  @override
  String get deleteObjectBody =>
      'L’immobile, tutti i suoi problemi e le foto saranno eliminati da questo dispositivo.';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteObject => 'Elimina immobile';

  @override
  String get issuesLoadFailure => 'Impossibile caricare i problemi';

  @override
  String get reopenObject => 'Prova a riaprire l’immobile.';

  @override
  String get issuesHeading => 'Problemi';

  @override
  String get filterAll => 'Tutti';

  @override
  String get statusOpen => 'Aperto';

  @override
  String get statusDone => 'Risolto';

  @override
  String get noIssuesTitle => 'Nessun problema per ora';

  @override
  String get noMatchesTitle => 'Ancora nessun elemento';

  @override
  String get noIssuesBody =>
      'Aggiungi una descrizione e una foto di ciò che va corretto.';

  @override
  String get noMatchesBody => 'Prova a scegliere un altro filtro.';

  @override
  String get issuePhoto => 'Foto del problema';

  @override
  String get photoLoadFailure => 'Impossibile aprire la foto';

  @override
  String get reopenIssue => 'Riapri';

  @override
  String get markDone => 'Segna come risolto';

  @override
  String get addIssue => 'Aggiungi problema';

  @override
  String get newIssue => 'Nuovo problema';

  @override
  String get photoPickFailure =>
      'Impossibile aggiungere la foto. Controlla i permessi e scegli un file fino a 8 MB.';

  @override
  String get saveIssueFailure =>
      'Salvataggio non riuscito. Il testo è rimasto nel modulo. Riprova.';

  @override
  String get pleaseWait => 'Attendi…';

  @override
  String get saveIssue => 'Salva problema';

  @override
  String get issueDescriptionLabel => 'Cosa va corretto?';

  @override
  String get issueDescriptionHint => 'Descrivi il luogo e il problema';

  @override
  String get removePhoto => 'Rimuovi foto';

  @override
  String get takePhoto => 'Scatta foto';

  @override
  String get fromGallery => 'Dalla galleria';

  @override
  String get localStorageNote =>
      'Dati e foto sono salvati su questo dispositivo. La sincronizzazione non è ancora disponibile.';

  @override
  String get requiredField => 'Questo campo è obbligatorio';

  @override
  String get databaseOpenFailure => 'Impossibile aprire i dati';

  @override
  String get retry => 'Riprova';

  @override
  String get language => 'Lingua dell’app';

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
  String get account => 'Account';

  @override
  String get signIn => 'Accedi';

  @override
  String get register => 'Crea account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signOut => 'Esci';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountBody =>
      'Inserisci la password per eliminare definitivamente il tuo account e i suoi dati su questo dispositivo.';

  @override
  String get authUnavailable =>
      'Accesso non disponibile. Puoi continuare a usare il diario locale.';

  @override
  String get authFailure => 'Impossibile completare la richiesta. Riprova.';

  @override
  String get authInvalidCredentials => 'Controlla email e password.';

  @override
  String get authPasswordRule =>
      'Usa almeno 12 caratteri e non più di 72 byte UTF-8.';

  @override
  String get authNetwork => 'Connessione non riuscita. Riprova.';

  @override
  String get authStorage => 'Archiviazione sicura non disponibile. Riprova.';

  @override
  String get authLocalNote =>
      'I dati restano su questo dispositivo; la sincronizzazione non è disponibile. Le voci ospite restano separate.';
}
