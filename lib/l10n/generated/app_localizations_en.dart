// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure => 'Could not save the change. Please try again.';

  @override
  String get appearance => 'Appearance';

  @override
  String get followSystem => 'Follow system';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get objectsLoadFailure => 'Could not load properties';

  @override
  String get restartRetry => 'Restart the app and try again.';

  @override
  String get objectsHeading => 'Your properties';

  @override
  String get objectsIntro =>
      'From the first photo and idea to work progress and the finished result.';

  @override
  String get emptyObjectsTitle => 'Start with your first property';

  @override
  String get emptyObjectsBody =>
      'Add an apartment, room or another property you are inspecting.';

  @override
  String get createObject => 'Add property';

  @override
  String get newObject => 'New property';

  @override
  String get objectName => 'Property name';

  @override
  String get objectNameHint => 'For example, Oak Street apartment';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get deleteObjectTitle => 'Delete property?';

  @override
  String get deleteObjectBody =>
      'The property, all its issues and photos will be deleted from this device.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteObject => 'Delete property';

  @override
  String get issuesLoadFailure => 'Could not load issues';

  @override
  String get reopenObject => 'Try reopening the property.';

  @override
  String get issuesHeading => 'Issues';

  @override
  String get filterAll => 'All';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusDone => 'Fixed';

  @override
  String get noIssuesTitle => 'No issues yet';

  @override
  String get noMatchesTitle => 'Nothing here yet';

  @override
  String get noIssuesBody =>
      'Add a description and a photo of what needs fixing.';

  @override
  String get noMatchesBody => 'Try choosing a different filter.';

  @override
  String get issuePhoto => 'Issue photo';

  @override
  String get photoLoadFailure => 'Could not open photo';

  @override
  String get reopenIssue => 'Reopen';

  @override
  String get markDone => 'Mark as fixed';

  @override
  String get addIssue => 'Add issue';

  @override
  String get newIssue => 'New issue';

  @override
  String get photoPickFailure =>
      'Could not add photo. Check permissions and choose a file up to 8 MB.';

  @override
  String get saveIssueFailure =>
      'Could not save. Your text is still in the form. Please try again.';

  @override
  String get pleaseWait => 'Please wait…';

  @override
  String get saveIssue => 'Save issue';

  @override
  String get issueDescriptionLabel => 'What needs fixing?';

  @override
  String get issueDescriptionHint => 'Describe the location and issue';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get localStorageNote =>
      'Data and photos are saved on this device. Sync is not available yet.';

  @override
  String get requiredField => 'This field is required';

  @override
  String get databaseOpenFailure => 'Could not open data';

  @override
  String get retry => 'Try again';

  @override
  String get language => 'App language';

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
  String get signIn => 'Sign in';

  @override
  String get register => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountBody =>
      'Enter your password to permanently delete your account and its data on this device.';

  @override
  String get authUnavailable =>
      'Sign-in is unavailable. You can continue using the local journal.';

  @override
  String get authFailure => 'Could not complete the request. Please try again.';

  @override
  String get authInvalidCredentials => 'Check your email and password.';

  @override
  String get authPasswordRule =>
      'Use at least 12 characters and no more than 72 UTF-8 bytes.';

  @override
  String get authNetwork => 'Connection failed. Please try again.';

  @override
  String get authStorage => 'Secure storage is unavailable. Please try again.';

  @override
  String get authLocalNote =>
      'Account data stays on this device; sync is not available. Guest entries remain separate.';

  @override
  String get rooms => 'Rooms';

  @override
  String get newRoom => 'Add room';

  @override
  String get roomType => 'Room type';

  @override
  String get roomName => 'Room name';

  @override
  String get lengthMetres => 'Length, m';

  @override
  String get widthMetres => 'Width, m';

  @override
  String get heightMetres => 'Height, m';

  @override
  String get renovationWish => 'What would you like to change?';

  @override
  String get saveRoom => 'Save room';

  @override
  String get invalidDimension =>
      'Enter a size from 0.001 to 1000 metres (up to 3 decimal places).';

  @override
  String get roomGeometryNote =>
      'Rectangular room. Areas exclude no openings yet; confirm doors, windows and work zones before calculating materials.';

  @override
  String floorArea(String value) {
    return 'Floor: $value m²';
  }

  @override
  String wallArea(String value) {
    return 'Walls before openings: $value m²';
  }

  @override
  String get roomBathroom => 'Bathroom';

  @override
  String get roomToilet => 'Toilet';

  @override
  String get roomKitchen => 'Kitchen';

  @override
  String get roomBedroom => 'Bedroom';

  @override
  String get roomLiving => 'Living room';

  @override
  String get roomOther => 'Other';

  @override
  String get profile => 'Profile';

  @override
  String get propertiesTab => 'Properties';

  @override
  String get guestProfile => 'Guest profile';

  @override
  String get profileName => 'Your name';

  @override
  String get editProfileName => 'Edit name';

  @override
  String get settings => 'Settings';

  @override
  String get save => 'Save';

  @override
  String get projectHistory => 'Renovation history';

  @override
  String get beforeStage => 'Before';

  @override
  String get proposalStage => 'Proposals';

  @override
  String get progressStage => 'Work progress';

  @override
  String get resultStage => 'Result';

  @override
  String get addUpdate => 'Add update';

  @override
  String get newProject => 'New renovation project';

  @override
  String get projectWish => 'What would you like to change?';

  @override
  String get measurements => 'Project measurements';

  @override
  String get addMeasurements => 'Save measurements';

  @override
  String get proposalPending =>
      'Photo analysis and proposal generation are not connected yet. Solutions for this project will appear here.';

  @override
  String get photoRequired => 'Add a photo of the initial state.';

  @override
  String get entryStage => 'Stage';

  @override
  String get historyEmpty =>
      'Add an initial photo and your wishes to start the project history.';

  @override
  String get analyzePhoto => 'Get a proposal';

  @override
  String get analysisWorking =>
      'Analyzing on your Mac. This may take about a minute.';

  @override
  String get analysisDraft =>
      'Preliminary draft. Confirm observations; this is not a measurement or a finished renovation guide.';

  @override
  String get analysisFailed =>
      'Could not get a proposal. Check the local server and retry.';

  @override
  String get analysisNotRoom =>
      'No room recognized. Add an initial room photo.';

  @override
  String get analysisObservations => 'Visible in the photo';

  @override
  String get analysisSteps => 'Suggested steps';

  @override
  String get analysisMaterials => 'Material categories';

  @override
  String get analysisQuestions => 'Questions';

  @override
  String get analysisUnknowns => 'Unknowns';

  @override
  String get openings => 'Door and window openings';

  @override
  String get addOpening => 'Add opening';

  @override
  String get openingX => 'Distance from left edge of wall, m';

  @override
  String get openingY => 'Height above floor, m';

  @override
  String get openingHelp =>
      'Measure the opening, not the door leaf. Walls 1 and 3 follow room length; 2 and 4 follow width. Count from the left when facing the wall from inside. Reveals are excluded.';

  @override
  String get openingInvalid =>
      'Check dimensions: openings must not overlap or extend beyond the wall.';

  @override
  String netWallArea(String value) {
    return 'Walls excluding openings: $value m²';
  }

  @override
  String wallNumber(int number) {
    return 'Wall $number';
  }

  @override
  String get estimateStage => 'Material estimate';

  @override
  String get calculateMaterials => 'Calculate material';

  @override
  String get estimateSourceNote =>
      'Enter consumption for the specific product from its label or manufacturer documentation. No catalog is connected; you supply and verify these details.';

  @override
  String get selectedSurfaces => 'Work surfaces';

  @override
  String get floorSurface => 'Floor';

  @override
  String get ceilingSurface => 'Ceiling';

  @override
  String get productReference => 'Product name and reference';

  @override
  String get consumptionSource => 'Consumption source';

  @override
  String get consumptionPerLayer => 'Consumption per m² per coat';

  @override
  String get packageSize => 'Quantity per package';

  @override
  String get materialLayers => 'Number of coats';

  @override
  String get wastePercent => 'Waste, %';

  @override
  String get unitGrams => 'g';

  @override
  String get unitMillilitres => 'ml';

  @override
  String get unitPieces => 'pcs';

  @override
  String estimateRequired(String value, String unit) {
    return 'Required: $value $unit';
  }

  @override
  String estimatePackages(int value) {
    return 'Packages: $value';
  }

  @override
  String estimateArea(String value) {
    return 'Work area: $value m²';
  }

  @override
  String get estimateInvalid =>
      'Select surfaces and units; check consumption, package size, coats and waste.';

  @override
  String get measuredPlan => 'Measured floor plan';

  @override
  String get measuredPlanNote =>
      'Top view. Openings are orange; door leaves and utility routes are not modeled. Numbers match the selected walls.';
}
