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
      'Record issues, add photos and track what has been fixed.';

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
}
