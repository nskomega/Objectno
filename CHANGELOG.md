# Изменения

## 0.1.0-dev.23 - 2026-11-01
- Added revocable anonymous sessions for authenticated analysis without forcing account registration or inventing guest email/password data.
- Anonymous sessions retain the existing guest journal scope and guest profile UI; registered accounts retain their separate stores.
- Go guest rotation/logout test passed with race detection; 53 Flutter tests passed before adding the root-scope regression, and all four account widget tests passed afterwards. Local inference is still being connected separately.


## 0.1.0-dev.22 - 2026-11-01
- Recorded owner-confirmed build 20 hardware checks: existing issue/photo preserved in the new history, and a new object created with wishes/photo opens with its Before entry. Documentation only; no new device binary or store publication.


## 0.1.0-dev.21 - 2026-11-01
- Recorded verified development signing and successful installation of build 20 on the reconnected iPhone, without uninstalling the app. Installed version independently queried as 20; hardware verification of the updated history is pending. No app behavior changes.


## 0.1.0-dev.20
- Объект стал единым проектом ремонта: создание с исходным фото и пожеланиями, общая история с датами и этапами «До ремонта», «Ход работ», «Результат».
- Обмеры и ранее созданные помещения отображаются внутри объекта; отдельный переход в список помещений убран. Старые замечания и фотографии сохранены и видны в истории, управление их статусами доступно дополнительно.
- Генерация предложений явно отмечена как неподключённая; вымышленные результаты не создаются.
- Анализ без замечаний, 52 теста прошли, включая фото при создании, сохранность после перезапуска, каскадное удаление/изоляцию, крупный текст и нормальную высоту таббара 48–56 px. Web и iOS release собраны. На телефоне пока сборка 18: устройство недоступно по USB.


## 0.1.0-dev.19 - 2026-10-31
- Reduced root tab bar to about 50 logical pixels at standard text size, keeping 48px tap targets and content growth for accessibility text.
- Both existing 3x-text profile tests passed. Documented the next unified-object revision requested by the owner; that workflow is not implemented in this commit.


## 0.1.0-dev.18 - 2026-10-31
- Added bottom Properties/Profile tabs. Moved language, appearance and account access into Profile; removed language/theme popup menus from the object app bar.
- Added scrollable selection screens with current-choice indicators and a local per-account editable profile name. Tab labels grow with system text scaling.
- All new strings translated into eight languages. Existing guest data/stores retained.
- Clean dart analysis; all 48 tests passed, including profile editing at 3x text on 320x568, preference persistence, account navigation and name isolation. Web release and unsigned iOS release build passed; browser profile/theme/language views checked.
- Build 18 signed locally and successfully installed over the existing iPhone app. Device launch of this update and retention of existing photos await user confirmation.


## 0.1.0-dev.17 - 2026-10-31
- Recorded owner-confirmed camera capture, issue photo save and persistence after full app close/reopen on iPhone 6s / iOS 15.8.8 (installed build 14). No app code changes or store publication.


## 0.1.0-dev.16 - 2026-10-31
- Recorded owner-confirmed launch of installed build 14 on the physical iPhone 6s (iOS 15.8.8): the home screen opens. No application code changed; camera and session checks remain pending.


## 0.1.0-dev.15 - 2026-10-31
- Added local development-signing helper: selects an existing wildcard profile that already includes the connected device and a matching available signing identity; no portal registration or private-key export.
- Retained Xcode project/scheme migration and pinned all explicit deployment targets to iOS 15 to avoid an automatic increase to the SDK's recommended version.
- Release app 0.1.0 build 14 with the new icon built, signed, verified and successfully installed on the connected iPhone 6s (iOS 15.8.8) using ideviceinstaller. App launch on hardware awaits user confirmation; no store upload.


## 0.1.0-dev.14 - 2026-10-31
- Replaced the Flutter placeholder icon with the Objectno orange room-plan mark on graphite. Original generated source and 1024/512 store assets included.
- Generated all iOS sizes, Android density/adaptive launcher icons, web and maskable icons; added reproducible macOS asset generation script.
- Validated all 19 iOS catalog entries for pixel sizes and RGB/no alpha. Apple asset compiler passed; Android debug APK built successfully.


## 0.1.0-dev.13 - 2026-10-31
- Set system status-bar appearance explicitly for light and dark themes. Fixed white status text on the light background found during native simulator review.
- Verified iOS simulator build and launch, inspected screenshots in both appearances; dart analysis clean and eight existing theme/text-scale journal tests passed.


## 0.1.0-dev.12 - 2026-10-31
- Added reproducible single-architecture iOS simulator build script, avoiding the Flutter 3.44.2/Xcode 27 multi-architecture lipo failure without changing the shared SDK.
- Build names now explicitly separate the three-component release version from the numeric build number in this script.
- Verified simulator build and launch (dev.11); script build dev.12 passed with version 0.1.0, build 12. Local signing identities are available; no physical device, signed archive or store upload verified.


## 0.1.0-dev.11 - 2026-10-31
- Documentation follow-up for dev.10: recorded delivered room entry, validation, storage, and verification. No app behavior changes.

## 0.1.0-dev.10 - 2026-10-31
- Added rooms inside a property: type, name, rectangular room dimensions and renovation wishes. Bathroom, toilet, kitchen, bedroom, living room and other types supported.
- Metres with comma or dot parse exactly into millimetres. Cards show floor area and gross wall area with an explicit note that openings are not yet deducted.
- Local room records follow account isolation and cascade deletion. UI strings translated into all eight languages.
- Validation: clean dart analysis, all 46 Flutter tests passed, web release built. Opening entry, work selection and material calculations are not connected to this screen yet.


## 0.1.0-dev.9 — 31.10.2026
- Добавлено общее расчётное ядро для помещений, поверхностей и проёмов: проверка геометрии, нетто-площадь, норма продукта, слои, запас и упаковки.
- Промежуточные вычисления BigInt; отсутствующие данные не подменяются нулевым расходом. Каталог, экран расчёта и инженерные трассы ещё не подключены.
- Восемь расчётных тестов прошли на native и Chrome; dart analyze lib test без замечаний.


## 0.1.0-dev.8 — 31.10.2026
- Минимальная версия iOS повышена с 13 до 15 для совместимости с установленным Xcode 27.2; устройства с iOS 13/14 не поддерживаются этой конфигурацией.
- Проверено: plutil проекта, успешная release-сборка iOS без подписи (build/ios/iphoneos/Runner.app, 17,7 МБ). Это не архив для отправки и не опубликованная версия.


## 0.1.0-dev.7 — 31.10.2026
- Подключён экран аккаунта: вход, регистрация, выход и удаление с подтверждением паролем; строки на восьми языках.
- Смена пользователя переключает раздел журнала и сбрасывает навигацию. Гостевые записи сохраняются отдельно. Без API явно показана недоступность входа.
- Исправлена валидация полей вне видимой области при крупном тексте.
- Проверено: анализ без замечаний, 35 Flutter-тестов, web release. iOS-сборка выявила устаревшую минимальную версию платформы; требуется отдельное исправление.


## 0.1.0-dev.6 — 31.10.2026
- Добавлены HTTP-клиент авторизации, контроллер сессии с объединением одновременных refresh и защищённое мобильное хранилище refresh token; web хранит сессию только в памяти.
- Добавлено разделение локального журнала по аккаунтам и удаление отдельного раздела без потери гостевых и чужих записей.
- Сетевой таймаут охватывает ожидание заголовков и тела; размер ответа ограничен при чтении потока. Production-конфигурация требует HTTPS.
- Проверено: dart analyze lib test, все 32 Flutter-теста. Экран входа и публичный API ещё не подключены; работа на реальных устройствах не проверена.


## 0.1.0-dev.5 — 31.10.2026
- Уточнены требования первого выпуска: ремонт разных помещений, общая модель и вопросы по составу работ; санузел остаётся примером.
- Зафиксирован выбор собственных вычислений без платных API моделей и разделение генерации и проверяемых расчётов. Функции ещё не реализованы.

Все заметные изменения описываются здесь. Завершённые изменения до релиза находятся в Unreleased. Выпущенных версий пока нет.

## Unreleased

## 0.1.0-dev.4 — 2026-10-31
### Добавлено
- Локальный Go API регистрации/входа: bcrypt, короткоживущий JWT, ротация refresh token, отзыв сессий и удаление аккаунта с повторной проверкой пароля.
- Постоянное хранение аккаунтов и хешей refresh-токенов, ограничение запросов и очистка истёкших сессий.
- Тесты, включая race detection, проверки JWT, replay, удаления и повторного запуска.
### Ограничения
- API ещё не развёрнут и не подключён к интерфейсу Flutter. Подтверждение email/восстановление и production-размещение ещё не готовы.


## 0.1.0-dev.3 — 2026-10-31
### Добавлено
- Русский, английский, испанский, французский, немецкий, итальянский, португальский и турецкий интерфейс через ARB/gen-l10n.
- Системный язык по умолчанию и ручной выбор с сохранением; старые строки экранов и сообщения перенесены в локализацию.
- Локализованные названия Android/iOS и iOS-пояснения разрешений; проверки полноты и переключения языков.


## 0.1.0-dev.2 — 2026-10-31
### Изменено
- По требованию Михаила каждое завершённое логическое изменение теперь фиксируется отдельным коммитом с новой dev-версией и записью изменений.

## История до dev.2 (ещё не выпущено)
### Добавлено
- Первый локальный Flutter-сценарий объектов и замечаний с фото, статусами, фильтрами и сохранением данных.
- Две темы с сохранением выбора и первые проверки увеличенного текста.
- Предложение Telegram Mini App как дополнительного канала.
- Девять проверок сценариев и хранения; web-сборка и Android debug APK. Авторизация и нативный релиз ещё не готовы.
- Flutter scaffold Android/iOS/web и требования к ежедневным релизам и безопасным сессиям; функции и публикация ещё не готовы.
- Правила проекта, предварительная спецификация дизайн-системы и каталог UI kit.
- Начальная структура приложения и журнал архитектурных решений.
- Независимый локальный Git, VERSION и правила выпуска версий.
- Решение использовать Go для сервера, если понадобится клиент-серверное взаимодействие.

- Описание гипотезы помощника по ремонту и подбора материалов по фото и пожеланию.

- Гипотеза фото/видеообхода квартиры со спецификацией, калькуляцией и идентификаторами материалов; описаны уровни точности результата.

- Предложение ограниченного BDUI на Go + Flutter с границами ответственности и планом одного экспериментального экрана.

### Изменено
- Выбранные фильтры используют оранжевую заливку.
- Статусы оформляются метками с цветной обводкой без заливки и обязательной текстовой подписью.
- Подписи полей закреплены над рамкой; уточнены размещение подсказок/ошибок и требования к доступности.
- Для второстепенной кнопки выбраны оранжевая обводка и текст без постоянной заливки.
- Для светлой темы выбран тёплый молочный фон; уточнены роли фона, поверхностей и текста обеих тем.
- Выбраны плавные и сдержанные анимации; добавлены требования к уменьшению движения и проверке переходов.
- Для карточек выбраны отличающийся фон, лёгкая тень и деликатная тонкая рамка; параметры предстоит проверить в обеих темах.
- Для полей ввода выбрана тонкая обводка с оранжевым фокусом.
- Согласованы системный режим темы по умолчанию и сохраняемый ручной выбор светлой/тёмной темы.
- Приняты контурные иконки с заливкой выбранного состояния и поддержка светлой/тёмной темы с начала разработки; добавлены правила тематизации и проверки.
- Для основной кнопки выбрана сплошная оранжевая заливка без градиента.
- Выбрана сбалансированная плотность; добавлены обязательные правила адаптации к системному масштабу текста и критерии проверки.
- Выбран геометричный технологичный характер типографики; конкретная гарнитура ещё не определена.
- Выбраны умеренные скругления кнопок и карточек; точные радиусы ещё подбираются.
- Дизайн-направление: выразительный технологичный интерфейс с чистым насыщенным оранжевым акцентом; тёмный графитовый фон; точные значения ещё подбираются.

### Ограничения
- Приложение, сервер, сборки и магазинные публикации ещё не созданы.
- Визуальное направление и аудитория уточняются; UI kit не проходил визуальную проверку.
