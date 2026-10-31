// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure => 'No se pudo guardar el cambio. Inténtalo de nuevo.';

  @override
  String get appearance => 'Apariencia';

  @override
  String get followSystem => 'Según el sistema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get objectsLoadFailure => 'No se pudieron cargar los inmuebles';

  @override
  String get restartRetry => 'Reinicia la aplicación e inténtalo de nuevo.';

  @override
  String get objectsHeading => 'Tus inmuebles';

  @override
  String get objectsIntro =>
      'Registra incidencias, añade fotos y marca lo que se ha corregido.';

  @override
  String get emptyObjectsTitle => 'Empieza con tu primer inmueble';

  @override
  String get emptyObjectsBody =>
      'Añade un piso, una habitación u otro inmueble que estés inspeccionando.';

  @override
  String get createObject => 'Añadir inmueble';

  @override
  String get newObject => 'Nuevo inmueble';

  @override
  String get objectName => 'Nombre del inmueble';

  @override
  String get objectNameHint => 'Por ejemplo, piso de la calle Roble';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Crear';

  @override
  String get deleteObjectTitle => '¿Eliminar el inmueble?';

  @override
  String get deleteObjectBody =>
      'El inmueble, sus incidencias y sus fotos se eliminarán de este dispositivo.';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteObject => 'Eliminar inmueble';

  @override
  String get issuesLoadFailure => 'No se pudieron cargar las incidencias';

  @override
  String get reopenObject => 'Intenta abrir el inmueble de nuevo.';

  @override
  String get issuesHeading => 'Incidencias';

  @override
  String get filterAll => 'Todas';

  @override
  String get statusOpen => 'Abierta';

  @override
  String get statusDone => 'Corregida';

  @override
  String get noIssuesTitle => 'Aún no hay incidencias';

  @override
  String get noMatchesTitle => 'Todavía no hay nada';

  @override
  String get noIssuesBody =>
      'Añade una descripción y una foto de lo que hay que corregir.';

  @override
  String get noMatchesBody => 'Prueba con otro filtro.';

  @override
  String get issuePhoto => 'Foto de la incidencia';

  @override
  String get photoLoadFailure => 'No se pudo abrir la foto';

  @override
  String get reopenIssue => 'Reabrir';

  @override
  String get markDone => 'Marcar como corregida';

  @override
  String get addIssue => 'Añadir incidencia';

  @override
  String get newIssue => 'Nueva incidencia';

  @override
  String get photoPickFailure =>
      'No se pudo añadir la foto. Revisa los permisos y elige un archivo de hasta 8 MB.';

  @override
  String get saveIssueFailure =>
      'No se pudo guardar. El texto sigue en el formulario. Inténtalo de nuevo.';

  @override
  String get pleaseWait => 'Espera…';

  @override
  String get saveIssue => 'Guardar incidencia';

  @override
  String get issueDescriptionLabel => '¿Qué hay que corregir?';

  @override
  String get issueDescriptionHint => 'Describe el lugar y el problema';

  @override
  String get removePhoto => 'Quitar foto';

  @override
  String get takePhoto => 'Hacer foto';

  @override
  String get fromGallery => 'De la galería';

  @override
  String get localStorageNote =>
      'Los datos y las fotos se guardan en este dispositivo. La sincronización aún no está disponible.';

  @override
  String get requiredField => 'Este campo es obligatorio';

  @override
  String get databaseOpenFailure => 'No se pudieron abrir los datos';

  @override
  String get retry => 'Reintentar';

  @override
  String get language => 'Idioma de la aplicación';

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
  String get account => 'Cuenta';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get register => 'Crear cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountBody =>
      'Introduce tu contraseña para eliminar permanentemente tu cuenta y sus datos de este dispositivo.';

  @override
  String get authUnavailable =>
      'El inicio de sesión no está disponible. Puedes seguir usando el diario local.';

  @override
  String get authFailure =>
      'No se pudo completar la solicitud. Inténtalo de nuevo.';

  @override
  String get authInvalidCredentials => 'Comprueba tu correo y contraseña.';

  @override
  String get authPasswordRule =>
      'Usa al menos 12 caracteres y no más de 72 bytes UTF-8.';

  @override
  String get authNetwork => 'Error de conexión. Inténtalo de nuevo.';

  @override
  String get authStorage =>
      'El almacenamiento seguro no está disponible. Inténtalo de nuevo.';

  @override
  String get authLocalNote =>
      'Los datos de la cuenta permanecen en este dispositivo; no hay sincronización. Las entradas de invitado se guardan por separado.';

  @override
  String get rooms => 'Habitaciones';

  @override
  String get newRoom => 'Añadir habitación';

  @override
  String get roomType => 'Tipo de habitación';

  @override
  String get roomName => 'Nombre de la habitación';

  @override
  String get lengthMetres => 'Largo, m';

  @override
  String get widthMetres => 'Ancho, m';

  @override
  String get heightMetres => 'Alto, m';

  @override
  String get renovationWish => '¿Qué quieres cambiar?';

  @override
  String get saveRoom => 'Guardar habitación';

  @override
  String get invalidDimension =>
      'Introduce una medida entre 0,001 y 1000 metros (hasta 3 decimales).';

  @override
  String get roomGeometryNote =>
      'Habitación rectangular. Aún no se descuentan huecos; confirma puertas, ventanas y zonas de trabajo antes de calcular materiales.';

  @override
  String floorArea(String value) {
    return 'Suelo: $value m²';
  }

  @override
  String wallArea(String value) {
    return 'Paredes sin descontar huecos: $value m²';
  }

  @override
  String get roomBathroom => 'Baño';

  @override
  String get roomToilet => 'Aseo';

  @override
  String get roomKitchen => 'Cocina';

  @override
  String get roomBedroom => 'Dormitorio';

  @override
  String get roomLiving => 'Salón';

  @override
  String get roomOther => 'Otra';
}
