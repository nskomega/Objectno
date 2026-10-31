import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
  ];

  /// Objectno UI: appName
  ///
  /// In en, this message translates to:
  /// **'Objectno'**
  String get appName;

  /// Objectno UI: saveFailure
  ///
  /// In en, this message translates to:
  /// **'Could not save the change. Please try again.'**
  String get saveFailure;

  /// Objectno UI: appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Objectno UI: followSystem
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// Objectno UI: lightTheme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Objectno UI: darkTheme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// Objectno UI: objectsLoadFailure
  ///
  /// In en, this message translates to:
  /// **'Could not load properties'**
  String get objectsLoadFailure;

  /// Objectno UI: restartRetry
  ///
  /// In en, this message translates to:
  /// **'Restart the app and try again.'**
  String get restartRetry;

  /// Objectno UI: objectsHeading
  ///
  /// In en, this message translates to:
  /// **'Your properties'**
  String get objectsHeading;

  /// Objectno UI: objectsIntro
  ///
  /// In en, this message translates to:
  /// **'Record issues, add photos and track what has been fixed.'**
  String get objectsIntro;

  /// Objectno UI: emptyObjectsTitle
  ///
  /// In en, this message translates to:
  /// **'Start with your first property'**
  String get emptyObjectsTitle;

  /// Objectno UI: emptyObjectsBody
  ///
  /// In en, this message translates to:
  /// **'Add an apartment, room or another property you are inspecting.'**
  String get emptyObjectsBody;

  /// Objectno UI: createObject
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get createObject;

  /// Objectno UI: newObject
  ///
  /// In en, this message translates to:
  /// **'New property'**
  String get newObject;

  /// Objectno UI: objectName
  ///
  /// In en, this message translates to:
  /// **'Property name'**
  String get objectName;

  /// Objectno UI: objectNameHint
  ///
  /// In en, this message translates to:
  /// **'For example, Oak Street apartment'**
  String get objectNameHint;

  /// Objectno UI: cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Objectno UI: create
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Objectno UI: deleteObjectTitle
  ///
  /// In en, this message translates to:
  /// **'Delete property?'**
  String get deleteObjectTitle;

  /// Objectno UI: deleteObjectBody
  ///
  /// In en, this message translates to:
  /// **'The property, all its issues and photos will be deleted from this device.'**
  String get deleteObjectBody;

  /// Objectno UI: delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Objectno UI: deleteObject
  ///
  /// In en, this message translates to:
  /// **'Delete property'**
  String get deleteObject;

  /// Objectno UI: issuesLoadFailure
  ///
  /// In en, this message translates to:
  /// **'Could not load issues'**
  String get issuesLoadFailure;

  /// Objectno UI: reopenObject
  ///
  /// In en, this message translates to:
  /// **'Try reopening the property.'**
  String get reopenObject;

  /// Objectno UI: issuesHeading
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get issuesHeading;

  /// Objectno UI: filterAll
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Objectno UI: statusOpen
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// Objectno UI: statusDone
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get statusDone;

  /// Objectno UI: noIssuesTitle
  ///
  /// In en, this message translates to:
  /// **'No issues yet'**
  String get noIssuesTitle;

  /// Objectno UI: noMatchesTitle
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get noMatchesTitle;

  /// Objectno UI: noIssuesBody
  ///
  /// In en, this message translates to:
  /// **'Add a description and a photo of what needs fixing.'**
  String get noIssuesBody;

  /// Objectno UI: noMatchesBody
  ///
  /// In en, this message translates to:
  /// **'Try choosing a different filter.'**
  String get noMatchesBody;

  /// Objectno UI: issuePhoto
  ///
  /// In en, this message translates to:
  /// **'Issue photo'**
  String get issuePhoto;

  /// Objectno UI: photoLoadFailure
  ///
  /// In en, this message translates to:
  /// **'Could not open photo'**
  String get photoLoadFailure;

  /// Objectno UI: reopenIssue
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopenIssue;

  /// Objectno UI: markDone
  ///
  /// In en, this message translates to:
  /// **'Mark as fixed'**
  String get markDone;

  /// Objectno UI: addIssue
  ///
  /// In en, this message translates to:
  /// **'Add issue'**
  String get addIssue;

  /// Objectno UI: newIssue
  ///
  /// In en, this message translates to:
  /// **'New issue'**
  String get newIssue;

  /// Objectno UI: photoPickFailure
  ///
  /// In en, this message translates to:
  /// **'Could not add photo. Check permissions and choose a file up to 8 MB.'**
  String get photoPickFailure;

  /// Objectno UI: saveIssueFailure
  ///
  /// In en, this message translates to:
  /// **'Could not save. Your text is still in the form. Please try again.'**
  String get saveIssueFailure;

  /// Objectno UI: pleaseWait
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get pleaseWait;

  /// Objectno UI: saveIssue
  ///
  /// In en, this message translates to:
  /// **'Save issue'**
  String get saveIssue;

  /// Objectno UI: issueDescriptionLabel
  ///
  /// In en, this message translates to:
  /// **'What needs fixing?'**
  String get issueDescriptionLabel;

  /// Objectno UI: issueDescriptionHint
  ///
  /// In en, this message translates to:
  /// **'Describe the location and issue'**
  String get issueDescriptionHint;

  /// Objectno UI: removePhoto
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// Objectno UI: takePhoto
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// Objectno UI: fromGallery
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get fromGallery;

  /// Objectno UI: localStorageNote
  ///
  /// In en, this message translates to:
  /// **'Data and photos are saved on this device. Sync is not available yet.'**
  String get localStorageNote;

  /// Objectno UI: requiredField
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Objectno UI: databaseOpenFailure
  ///
  /// In en, this message translates to:
  /// **'Could not open data'**
  String get databaseOpenFailure;

  /// Objectno UI: retry
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// Objectno UI: language
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get language;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// Language name shown in its own language
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
    'ru',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
