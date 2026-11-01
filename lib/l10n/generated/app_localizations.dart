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
  /// **'From the first photo and idea to work progress and the finished result.'**
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

  /// Account screen: account
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Account screen: signIn
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Account screen: register
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register;

  /// Account screen: email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Account screen: password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Account screen: signOut
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Account screen: deleteAccount
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Account screen: deleteAccountBody
  ///
  /// In en, this message translates to:
  /// **'Enter your password to permanently delete your account and its data on this device.'**
  String get deleteAccountBody;

  /// Account screen: authUnavailable
  ///
  /// In en, this message translates to:
  /// **'Sign-in is unavailable. You can continue using the local journal.'**
  String get authUnavailable;

  /// Account screen: authFailure
  ///
  /// In en, this message translates to:
  /// **'Could not complete the request. Please try again.'**
  String get authFailure;

  /// Account screen: authInvalidCredentials
  ///
  /// In en, this message translates to:
  /// **'Check your email and password.'**
  String get authInvalidCredentials;

  /// Account screen: authPasswordRule
  ///
  /// In en, this message translates to:
  /// **'Use at least 12 characters and no more than 72 UTF-8 bytes.'**
  String get authPasswordRule;

  /// Account screen: authNetwork
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please try again.'**
  String get authNetwork;

  /// Account screen: authStorage
  ///
  /// In en, this message translates to:
  /// **'Secure storage is unavailable. Please try again.'**
  String get authStorage;

  /// Account screen: authLocalNote
  ///
  /// In en, this message translates to:
  /// **'Account data stays on this device; sync is not available. Guest entries remain separate.'**
  String get authLocalNote;

  /// Renovation room UI: rooms
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// Renovation room UI: newRoom
  ///
  /// In en, this message translates to:
  /// **'Add room'**
  String get newRoom;

  /// Renovation room UI: roomType
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get roomType;

  /// Renovation room UI: roomName
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get roomName;

  /// Renovation room UI: lengthMetres
  ///
  /// In en, this message translates to:
  /// **'Length, m'**
  String get lengthMetres;

  /// Renovation room UI: widthMetres
  ///
  /// In en, this message translates to:
  /// **'Width, m'**
  String get widthMetres;

  /// Renovation room UI: heightMetres
  ///
  /// In en, this message translates to:
  /// **'Height, m'**
  String get heightMetres;

  /// Renovation room UI: renovationWish
  ///
  /// In en, this message translates to:
  /// **'What would you like to change?'**
  String get renovationWish;

  /// Renovation room UI: saveRoom
  ///
  /// In en, this message translates to:
  /// **'Save room'**
  String get saveRoom;

  /// Renovation room UI: invalidDimension
  ///
  /// In en, this message translates to:
  /// **'Enter a size from 0.001 to 1000 metres (up to 3 decimal places).'**
  String get invalidDimension;

  /// Renovation room UI: roomGeometryNote
  ///
  /// In en, this message translates to:
  /// **'Rectangular room. Areas exclude no openings yet; confirm doors, windows and work zones before calculating materials.'**
  String get roomGeometryNote;

  /// Renovation room UI: floorArea
  ///
  /// In en, this message translates to:
  /// **'Floor: {value} m²'**
  String floorArea(String value);

  /// Renovation room UI: wallArea
  ///
  /// In en, this message translates to:
  /// **'Walls before openings: {value} m²'**
  String wallArea(String value);

  /// Renovation room UI: roomBathroom
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get roomBathroom;

  /// Renovation room UI: roomToilet
  ///
  /// In en, this message translates to:
  /// **'Toilet'**
  String get roomToilet;

  /// Renovation room UI: roomKitchen
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get roomKitchen;

  /// Renovation room UI: roomBedroom
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get roomBedroom;

  /// Renovation room UI: roomLiving
  ///
  /// In en, this message translates to:
  /// **'Living room'**
  String get roomLiving;

  /// Renovation room UI: roomOther
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get roomOther;

  /// Profile navigation: profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Profile navigation: propertiesTab
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get propertiesTab;

  /// Profile navigation: guestProfile
  ///
  /// In en, this message translates to:
  /// **'Guest profile'**
  String get guestProfile;

  /// Profile navigation: profileName
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileName;

  /// Profile navigation: editProfileName
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editProfileName;

  /// Profile navigation: settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Save profile changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Unified renovation object: projectHistory
  ///
  /// In en, this message translates to:
  /// **'Renovation history'**
  String get projectHistory;

  /// Unified renovation object: beforeStage
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get beforeStage;

  /// Unified renovation object: proposalStage
  ///
  /// In en, this message translates to:
  /// **'Proposals'**
  String get proposalStage;

  /// Unified renovation object: progressStage
  ///
  /// In en, this message translates to:
  /// **'Work progress'**
  String get progressStage;

  /// Unified renovation object: resultStage
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultStage;

  /// Unified renovation object: addUpdate
  ///
  /// In en, this message translates to:
  /// **'Add update'**
  String get addUpdate;

  /// Unified renovation object: newProject
  ///
  /// In en, this message translates to:
  /// **'New renovation project'**
  String get newProject;

  /// Unified renovation object: projectWish
  ///
  /// In en, this message translates to:
  /// **'What would you like to change?'**
  String get projectWish;

  /// Unified renovation object: measurements
  ///
  /// In en, this message translates to:
  /// **'Project measurements'**
  String get measurements;

  /// Unified renovation object: addMeasurements
  ///
  /// In en, this message translates to:
  /// **'Save measurements'**
  String get addMeasurements;

  /// Unified renovation object: proposalPending
  ///
  /// In en, this message translates to:
  /// **'Photo analysis and proposal generation are not connected yet. Solutions for this project will appear here.'**
  String get proposalPending;

  /// Unified renovation object: photoRequired
  ///
  /// In en, this message translates to:
  /// **'Add a photo of the initial state.'**
  String get photoRequired;

  /// Unified renovation object: entryStage
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get entryStage;

  /// Unified renovation object: historyEmpty
  ///
  /// In en, this message translates to:
  /// **'Add an initial photo and your wishes to start the project history.'**
  String get historyEmpty;

  /// analyzePhoto
  ///
  /// In en, this message translates to:
  /// **'Get a proposal'**
  String get analyzePhoto;

  /// analysisWorking
  ///
  /// In en, this message translates to:
  /// **'Analyzing on your Mac. This may take about a minute.'**
  String get analysisWorking;

  /// analysisDraft
  ///
  /// In en, this message translates to:
  /// **'Preliminary draft. Confirm observations; this is not a measurement or a finished renovation guide.'**
  String get analysisDraft;

  /// analysisFailed
  ///
  /// In en, this message translates to:
  /// **'Could not get a proposal. Check the local server and retry.'**
  String get analysisFailed;

  /// analysisNotRoom
  ///
  /// In en, this message translates to:
  /// **'No room recognized. Add an initial room photo.'**
  String get analysisNotRoom;

  /// analysisObservations
  ///
  /// In en, this message translates to:
  /// **'Visible in the photo'**
  String get analysisObservations;

  /// analysisSteps
  ///
  /// In en, this message translates to:
  /// **'Suggested steps'**
  String get analysisSteps;

  /// analysisMaterials
  ///
  /// In en, this message translates to:
  /// **'Material categories'**
  String get analysisMaterials;

  /// analysisQuestions
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get analysisQuestions;

  /// analysisUnknowns
  ///
  /// In en, this message translates to:
  /// **'Unknowns'**
  String get analysisUnknowns;

  /// openings
  ///
  /// In en, this message translates to:
  /// **'Door and window openings'**
  String get openings;

  /// addOpening
  ///
  /// In en, this message translates to:
  /// **'Add opening'**
  String get addOpening;

  /// openingX
  ///
  /// In en, this message translates to:
  /// **'Distance from left edge of wall, m'**
  String get openingX;

  /// openingY
  ///
  /// In en, this message translates to:
  /// **'Height above floor, m'**
  String get openingY;

  /// openingHelp
  ///
  /// In en, this message translates to:
  /// **'Measure the opening, not the door leaf. Walls 1 and 3 follow room length; 2 and 4 follow width. Count from the left when facing the wall from inside. Reveals are excluded.'**
  String get openingHelp;

  /// openingInvalid
  ///
  /// In en, this message translates to:
  /// **'Check dimensions: openings must not overlap or extend beyond the wall.'**
  String get openingInvalid;

  /// netWallArea
  ///
  /// In en, this message translates to:
  /// **'Walls excluding openings: {value} m²'**
  String netWallArea(String value);

  /// wallNumber
  ///
  /// In en, this message translates to:
  /// **'Wall {number}'**
  String wallNumber(int number);

  /// estimateStage
  ///
  /// In en, this message translates to:
  /// **'Material estimate'**
  String get estimateStage;

  /// calculateMaterials
  ///
  /// In en, this message translates to:
  /// **'Calculate material'**
  String get calculateMaterials;

  /// estimateSourceNote
  ///
  /// In en, this message translates to:
  /// **'Enter consumption for the specific product from its label or manufacturer documentation. No catalog is connected; you supply and verify these details.'**
  String get estimateSourceNote;

  /// selectedSurfaces
  ///
  /// In en, this message translates to:
  /// **'Work surfaces'**
  String get selectedSurfaces;

  /// floorSurface
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floorSurface;

  /// ceilingSurface
  ///
  /// In en, this message translates to:
  /// **'Ceiling'**
  String get ceilingSurface;

  /// productReference
  ///
  /// In en, this message translates to:
  /// **'Product name and reference'**
  String get productReference;

  /// consumptionSource
  ///
  /// In en, this message translates to:
  /// **'Consumption source'**
  String get consumptionSource;

  /// consumptionPerLayer
  ///
  /// In en, this message translates to:
  /// **'Consumption per m² per coat'**
  String get consumptionPerLayer;

  /// packageSize
  ///
  /// In en, this message translates to:
  /// **'Quantity per package'**
  String get packageSize;

  /// materialLayers
  ///
  /// In en, this message translates to:
  /// **'Number of coats'**
  String get materialLayers;

  /// wastePercent
  ///
  /// In en, this message translates to:
  /// **'Waste, %'**
  String get wastePercent;

  /// unitGrams
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitGrams;

  /// unitMillilitres
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMillilitres;

  /// unitPieces
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get unitPieces;

  /// estimateRequired
  ///
  /// In en, this message translates to:
  /// **'Required: {value} {unit}'**
  String estimateRequired(String value, String unit);

  /// estimatePackages
  ///
  /// In en, this message translates to:
  /// **'Packages: {value}'**
  String estimatePackages(int value);

  /// estimateArea
  ///
  /// In en, this message translates to:
  /// **'Work area: {value} m²'**
  String estimateArea(String value);

  /// estimateInvalid
  ///
  /// In en, this message translates to:
  /// **'Select surfaces and units; check consumption, package size, coats and waste.'**
  String get estimateInvalid;
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
