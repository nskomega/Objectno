// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Объектно';

  @override
  String get saveFailure =>
      'Не удалось сохранить изменение. Попробуйте ещё раз.';

  @override
  String get appearance => 'Тема оформления';

  @override
  String get followSystem => 'Как в системе';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get objectsLoadFailure => 'Не удалось загрузить объекты';

  @override
  String get restartRetry => 'Перезапустите приложение и попробуйте снова.';

  @override
  String get objectsHeading => 'Всё по объектам';

  @override
  String get objectsIntro =>
      'От первого фото и идеи до хода работ и готового результата.';

  @override
  String get emptyObjectsTitle => 'Начните с первого объекта';

  @override
  String get emptyObjectsBody =>
      'Добавьте квартиру, комнату или другой объект, который вы осматриваете.';

  @override
  String get createObject => 'Создать объект';

  @override
  String get newObject => 'Новый объект';

  @override
  String get objectName => 'Название объекта';

  @override
  String get objectNameHint => 'Например, квартира на Лесной';

  @override
  String get cancel => 'Отмена';

  @override
  String get create => 'Создать';

  @override
  String get deleteObjectTitle => 'Удалить объект?';

  @override
  String get deleteObjectBody =>
      'Объект, все его замечания и фотографии будут удалены с этого устройства.';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteObject => 'Удалить объект';

  @override
  String get issuesLoadFailure => 'Не удалось загрузить замечания';

  @override
  String get reopenObject => 'Попробуйте открыть объект повторно.';

  @override
  String get issuesHeading => 'Замечания';

  @override
  String get filterAll => 'Все';

  @override
  String get statusOpen => 'Открыто';

  @override
  String get statusDone => 'Исправлено';

  @override
  String get noIssuesTitle => 'Пока нет замечаний';

  @override
  String get noMatchesTitle => 'Здесь пока пусто';

  @override
  String get noIssuesBody =>
      'Добавьте описание и фотографию того, что нужно исправить.';

  @override
  String get noMatchesBody => 'Попробуйте выбрать другой фильтр.';

  @override
  String get issuePhoto => 'Фотография замечания';

  @override
  String get photoLoadFailure => 'Не удалось открыть фотографию';

  @override
  String get reopenIssue => 'Снова открыть';

  @override
  String get markDone => 'Отметить исправленным';

  @override
  String get addIssue => 'Добавить замечание';

  @override
  String get newIssue => 'Новое замечание';

  @override
  String get photoPickFailure =>
      'Не удалось добавить фото. Проверьте разрешение и выберите файл до 8 МБ.';

  @override
  String get saveIssueFailure =>
      'Не удалось сохранить. Ваш текст остался в форме. Попробуйте ещё раз.';

  @override
  String get pleaseWait => 'Подождите…';

  @override
  String get saveIssue => 'Сохранить замечание';

  @override
  String get issueDescriptionLabel => 'Что нужно исправить?';

  @override
  String get issueDescriptionHint => 'Опишите место и проблему';

  @override
  String get removePhoto => 'Убрать фотографию';

  @override
  String get takePhoto => 'Снять фото';

  @override
  String get fromGallery => 'Из галереи';

  @override
  String get localStorageNote =>
      'Данные и фотографии сохраняются на этом устройстве. Синхронизация пока недоступна.';

  @override
  String get requiredField => 'Заполните поле';

  @override
  String get databaseOpenFailure => 'Не удалось открыть данные';

  @override
  String get retry => 'Повторить';

  @override
  String get language => 'Язык приложения';

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
  String get account => 'Аккаунт';

  @override
  String get signIn => 'Войти';

  @override
  String get register => 'Создать аккаунт';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get signOut => 'Выйти';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountBody =>
      'Введите пароль, чтобы навсегда удалить аккаунт и его данные на этом устройстве.';

  @override
  String get authUnavailable =>
      'Вход пока недоступен. Можно продолжать работать с локальным журналом.';

  @override
  String get authFailure => 'Не удалось выполнить запрос. Попробуйте ещё раз.';

  @override
  String get authInvalidCredentials => 'Проверьте почту и пароль.';

  @override
  String get authPasswordRule =>
      'Не менее 12 символов и не более 72 байт UTF-8.';

  @override
  String get authNetwork => 'Нет соединения. Попробуйте ещё раз.';

  @override
  String get authStorage =>
      'Защищённое хранилище недоступно. Попробуйте ещё раз.';

  @override
  String get authLocalNote =>
      'Данные аккаунта остаются на этом устройстве, синхронизации пока нет. Гостевые записи хранятся отдельно.';

  @override
  String get rooms => 'Помещения';

  @override
  String get newRoom => 'Добавить помещение';

  @override
  String get roomType => 'Тип помещения';

  @override
  String get roomName => 'Название помещения';

  @override
  String get lengthMetres => 'Длина, м';

  @override
  String get widthMetres => 'Ширина, м';

  @override
  String get heightMetres => 'Высота, м';

  @override
  String get renovationWish => 'Что хотите изменить?';

  @override
  String get saveRoom => 'Сохранить помещение';

  @override
  String get invalidDimension =>
      'Введите размер от 0,001 до 1000 метров (до 3 знаков после запятой).';

  @override
  String get roomGeometryNote =>
      'Прямоугольное помещение. Проёмы пока не вычтены; перед расчётом материалов нужно подтвердить двери, окна и зоны работ.';

  @override
  String floorArea(String value) {
    return 'Пол: $value м²';
  }

  @override
  String wallArea(String value) {
    return 'Стены без вычета проёмов: $value м²';
  }

  @override
  String get roomBathroom => 'Ванная';

  @override
  String get roomToilet => 'Санузел';

  @override
  String get roomKitchen => 'Кухня';

  @override
  String get roomBedroom => 'Спальня';

  @override
  String get roomLiving => 'Гостиная';

  @override
  String get roomOther => 'Другое';

  @override
  String get profile => 'Профиль';

  @override
  String get propertiesTab => 'Объекты';

  @override
  String get guestProfile => 'Гостевой профиль';

  @override
  String get profileName => 'Ваше имя';

  @override
  String get editProfileName => 'Изменить имя';

  @override
  String get settings => 'Настройки';

  @override
  String get save => 'Сохранить';

  @override
  String get projectHistory => 'История ремонта';

  @override
  String get beforeStage => 'До ремонта';

  @override
  String get proposalStage => 'Предложения';

  @override
  String get progressStage => 'Ход работ';

  @override
  String get resultStage => 'Результат';

  @override
  String get addUpdate => 'Добавить запись';

  @override
  String get newProject => 'Новый объект ремонта';

  @override
  String get projectWish => 'Что хотите изменить?';

  @override
  String get measurements => 'Обмеры объекта';

  @override
  String get addMeasurements => 'Сохранить обмеры';

  @override
  String get proposalPending =>
      'Анализ фото и генерация предложений ещё не подключены. Здесь появятся наши решения для этого объекта.';

  @override
  String get photoRequired => 'Добавьте фото исходного состояния.';

  @override
  String get entryStage => 'Этап';

  @override
  String get historyEmpty =>
      'Добавьте исходное фото и пожелания, чтобы начать историю объекта.';

  @override
  String get analyzePhoto => 'Получить предложение';

  @override
  String get analysisWorking =>
      'Анализируем фото на Mac. Это может занять около минуты.';

  @override
  String get analysisDraft =>
      'Предварительное предложение. Наблюдения нужно подтвердить; это не обмеры и не готовая инструкция по ремонту.';

  @override
  String get analysisFailed =>
      'Не удалось получить предложение. Проверьте локальный сервер и попробуйте снова.';

  @override
  String get analysisNotRoom =>
      'Не удалось распознать помещение. Добавьте исходное фото комнаты.';

  @override
  String get analysisObservations => 'Что видно на фото';

  @override
  String get analysisSteps => 'Предлагаемые этапы';

  @override
  String get analysisMaterials => 'Категории материалов';

  @override
  String get analysisQuestions => 'Что уточнить';

  @override
  String get analysisUnknowns => 'Что пока неизвестно';

  @override
  String get openings => 'Проёмы дверей и окон';

  @override
  String get addOpening => 'Добавить проём';

  @override
  String get openingX => 'Отступ от левого края стены, м';

  @override
  String get openingY => 'Высота от пола, м';

  @override
  String get openingHelp =>
      'Укажите размер проёма, а не полотна. Стены 1 и 3 — длина комнаты, 2 и 4 — ширина. Отсчёт слева при взгляде на стену из комнаты. Откосы не учтены.';

  @override
  String get openingInvalid =>
      'Проверьте размеры: проёмы не должны пересекаться или выходить за стену.';

  @override
  String netWallArea(String value) {
    return 'Стены за вычетом проёмов: $value м²';
  }

  @override
  String wallNumber(int number) {
    return 'Стена $number';
  }

  @override
  String get estimateStage => 'Расчёт материалов';

  @override
  String get calculateMaterials => 'Рассчитать материал';

  @override
  String get estimateSourceNote =>
      'Введите норму конкретного продукта с упаковки или из документации изготовителя. Каталог пока не подключён; эти сведения вводите и проверяете вы.';

  @override
  String get selectedSurfaces => 'Поверхности для работ';

  @override
  String get floorSurface => 'Пол';

  @override
  String get ceilingSurface => 'Потолок';

  @override
  String get productReference => 'Название и артикул продукта';

  @override
  String get consumptionSource => 'Источник нормы расхода';

  @override
  String get consumptionPerLayer => 'Расход на 1 м² за один слой';

  @override
  String get packageSize => 'Количество в упаковке';

  @override
  String get materialLayers => 'Количество слоёв';

  @override
  String get wastePercent => 'Запас, %';

  @override
  String get unitGrams => 'г';

  @override
  String get unitMillilitres => 'мл';

  @override
  String get unitPieces => 'шт.';

  @override
  String estimateRequired(String value, String unit) {
    return 'Потребность: $value $unit';
  }

  @override
  String estimatePackages(int value) {
    return 'Упаковок: $value';
  }

  @override
  String estimateArea(String value) {
    return 'Площадь работ: $value м²';
  }

  @override
  String get estimateInvalid =>
      'Выберите поверхности и единицы; проверьте норму, фасовку, слои и запас.';
}
