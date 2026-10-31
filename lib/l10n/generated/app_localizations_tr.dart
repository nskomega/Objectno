// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure => 'Değişiklik kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get appearance => 'Görünüm';

  @override
  String get followSystem => 'Sistem ayarı';

  @override
  String get lightTheme => 'Açık';

  @override
  String get darkTheme => 'Koyu';

  @override
  String get objectsLoadFailure => 'Mülkler yüklenemedi';

  @override
  String get restartRetry => 'Uygulamayı yeniden başlatıp tekrar deneyin.';

  @override
  String get objectsHeading => 'Mülkleriniz';

  @override
  String get objectsIntro =>
      'Sorunları kaydedin, fotoğraf ekleyin ve düzeltmeleri takip edin.';

  @override
  String get emptyObjectsTitle => 'İlk mülkünüzü ekleyin';

  @override
  String get emptyObjectsBody =>
      'İncelediğiniz bir daireyi, odayı veya başka bir mülkü ekleyin.';

  @override
  String get createObject => 'Mülk ekle';

  @override
  String get newObject => 'Yeni mülk';

  @override
  String get objectName => 'Mülk adı';

  @override
  String get objectNameHint => 'Örneğin, Meşe Sokak dairesi';

  @override
  String get cancel => 'İptal';

  @override
  String get create => 'Oluştur';

  @override
  String get deleteObjectTitle => 'Mülk silinsin mi?';

  @override
  String get deleteObjectBody =>
      'Mülk, tüm sorunları ve fotoğrafları bu cihazdan silinecek.';

  @override
  String get delete => 'Sil';

  @override
  String get deleteObject => 'Mülkü sil';

  @override
  String get issuesLoadFailure => 'Sorunlar yüklenemedi';

  @override
  String get reopenObject => 'Mülkü yeniden açmayı deneyin.';

  @override
  String get issuesHeading => 'Sorunlar';

  @override
  String get filterAll => 'Tümü';

  @override
  String get statusOpen => 'Açık';

  @override
  String get statusDone => 'Düzeltildi';

  @override
  String get noIssuesTitle => 'Henüz sorun yok';

  @override
  String get noMatchesTitle => 'Burada henüz bir şey yok';

  @override
  String get noIssuesBody =>
      'Düzeltilmesi gereken şeyin açıklamasını ve fotoğrafını ekleyin.';

  @override
  String get noMatchesBody => 'Başka bir filtre seçmeyi deneyin.';

  @override
  String get issuePhoto => 'Sorun fotoğrafı';

  @override
  String get photoLoadFailure => 'Fotoğraf açılamadı';

  @override
  String get reopenIssue => 'Yeniden aç';

  @override
  String get markDone => 'Düzeltildi olarak işaretle';

  @override
  String get addIssue => 'Sorun ekle';

  @override
  String get newIssue => 'Yeni sorun';

  @override
  String get photoPickFailure =>
      'Fotoğraf eklenemedi. İzinleri kontrol edip en fazla 8 MB bir dosya seçin.';

  @override
  String get saveIssueFailure =>
      'Kaydedilemedi. Metniniz formda duruyor. Lütfen tekrar deneyin.';

  @override
  String get pleaseWait => 'Lütfen bekleyin…';

  @override
  String get saveIssue => 'Sorunu kaydet';

  @override
  String get issueDescriptionLabel => 'Ne düzeltilmeli?';

  @override
  String get issueDescriptionHint => 'Yeri ve sorunu açıklayın';

  @override
  String get removePhoto => 'Fotoğrafı kaldır';

  @override
  String get takePhoto => 'Fotoğraf çek';

  @override
  String get fromGallery => 'Galeriden';

  @override
  String get localStorageNote =>
      'Veriler ve fotoğraflar bu cihazda saklanır. Eşitleme henüz kullanılamıyor.';

  @override
  String get requiredField => 'Bu alan zorunludur';

  @override
  String get databaseOpenFailure => 'Veriler açılamadı';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get language => 'Uygulama dili';

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
  String get account => 'Hesap';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get register => 'Hesap oluştur';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Parola';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get deleteAccountBody =>
      'Hesabınızı ve bu cihazdaki verilerini kalıcı olarak silmek için parolanızı girin.';

  @override
  String get authUnavailable =>
      'Giriş şu anda kullanılamıyor. Yerel günlüğü kullanmaya devam edebilirsiniz.';

  @override
  String get authFailure => 'İstek tamamlanamadı. Yeniden deneyin.';

  @override
  String get authInvalidCredentials => 'E-posta ve parolanızı kontrol edin.';

  @override
  String get authPasswordRule =>
      'En az 12 karakter ve en fazla 72 UTF-8 bayt kullanın.';

  @override
  String get authNetwork => 'Bağlantı başarısız. Yeniden deneyin.';

  @override
  String get authStorage => 'Güvenli depolama kullanılamıyor. Yeniden deneyin.';

  @override
  String get authLocalNote =>
      'Hesap verileri bu cihazda kalır; eşitleme kullanılamıyor. Misafir kayıtları ayrı tutulur.';

  @override
  String get rooms => 'Odalar';

  @override
  String get newRoom => 'Oda ekle';

  @override
  String get roomType => 'Oda türü';

  @override
  String get roomName => 'Oda adı';

  @override
  String get lengthMetres => 'Uzunluk, m';

  @override
  String get widthMetres => 'Genişlik, m';

  @override
  String get heightMetres => 'Yükseklik, m';

  @override
  String get renovationWish => 'Neyi değiştirmek istiyorsunuz?';

  @override
  String get saveRoom => 'Odayı kaydet';

  @override
  String get invalidDimension =>
      '0,001 ile 1000 metre arasında bir ölçü girin (en fazla 3 ondalık basamak).';

  @override
  String get roomGeometryNote =>
      'Dikdörtgen oda. Açıklıklar henüz çıkarılmadı; malzeme hesabından önce kapıları, pencereleri ve çalışma alanlarını doğrulayın.';

  @override
  String floorArea(String value) {
    return 'Zemin: $value m²';
  }

  @override
  String wallArea(String value) {
    return 'Açıklıklar çıkarılmadan duvarlar: $value m²';
  }

  @override
  String get roomBathroom => 'Banyo';

  @override
  String get roomToilet => 'Tuvalet';

  @override
  String get roomKitchen => 'Mutfak';

  @override
  String get roomBedroom => 'Yatak odası';

  @override
  String get roomLiving => 'Oturma odası';

  @override
  String get roomOther => 'Diğer';

  @override
  String get profile => 'Profil';

  @override
  String get propertiesTab => 'Mülkler';

  @override
  String get guestProfile => 'Misafir profili';

  @override
  String get profileName => 'Adınız';

  @override
  String get editProfileName => 'Adı düzenle';

  @override
  String get settings => 'Ayarlar';

  @override
  String get save => 'Kaydet';
}
