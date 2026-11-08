# Изменения

## 0.1.0-dev.48 - 2026-11-08
- Добавлен CONTRIBUTING.md с минимальным контуром проверки перед pull request.


## 0.1.0-dev.47 - 2026-11-08
- В README добавлена ссылка на публичные Q&A в GitHub Discussions.


## 0.1.0-dev.46 - 2026-11-01
- Создан публичный репозиторий nskomega/Objectno, подключён origin, исходная история из 66 коммитов отправлена в main без переписывания.
- README, статус и процесс релизов обновлены: новые завершённые этапы отправляются на GitHub с проверкой SHA. Это публикация кода; магазинных релизов нет.
- Только документация и номер версии: git diff --check, проверка публичности репозитория и удалённой ветки; сборки dev.44 не пересобирались.

## 0.1.0-dev.45 - 2026-11-01
- Подготовлена открытая публикация: MIT для исходного кода, отдельные лицензии зависимостей/моделей и оценочных фото сохранены.
- Проверены пути и шаблоны ключей во всех 65 предшествующих коммитах: совпадений ключей не найдено, из чувствительных путей только шаблон server/.env.example. Это ограниченная проверка, не гарантия отсутствия всех секретов.
- Установлен официальный GitHub CLI; отправка ожидает авторизации владельца. История не переписана.

## 0.1.0-dev.44 - 2026-11-01
- Добавлен повторяемый нативный integration test: настоящий локальный анализ, явный выбор света, результат на экране, повторное открытие БД и восстановление той же сессии из iOS Keychain. Отдельный bundle ID и временная БД защищают обычный журнал от изменений теста.
- Тест прошёл; получен и просмотрен нативный снимок экрана без ручного управления заблокированным Mac. Камера и полный перезапуск процесса этим тестом не проверяются.
- Все 70 widget/unit-тестов прошли. Добавлены SDK integration_test и стабильные ключи элементов; production main.dart не менялся. После теста точка входа восстановлена. Обычные Android debug APK и iOS Simulator build 44 собраны.

## 0.1.0-dev.43 - 2026-11-01
- Первый проход модели выбирает до пяти предметов из ограниченного словаря; подписи переводятся на восемь языков без генерации произвольных технических названий. API проверяет допустимость и уникальность кодов предметов; сохраняется detected_items. Prompt 10.
- На тех же фото ванная распознана как ванна/душ/раковина/дверь/шкаф, спальня — кровать/потолочный вентилятор/балдахин/дерево/светильник. Ветрогенератор больше не появляется в подписи. Это не гарантия отсутствия ошибочных классификаций.
- Реальные API-проверки: ванная 13,0 с, спальня 21,4 с, кухня только со светом 15,3 с, скриншот с клавиатурой отклонён за 1,2 с. Планы соответствуют выбранным категориям; профессиональная пригодность ещё не принята.
- Двенадцать Python-тестов прошли, Go analysis race-тесты и vet прошли. Изменений Flutter нет; последняя сборка симулятора — 42.

## 0.1.0-dev.42 - 2026-11-01
- Добавлен выбор работ у исходного фото: покраска стен, пол, светильники и текстиль. До выбора анализ отключён; выбранные категории передаются в API и сохраняются с предложением. Восемь языков.
- Клиент отклоняет ответ с расширенным набором работ. Все 70 Flutter-тестов прошли, включая 3x в обеих темах; анализ чистый. Сборка 42 успешно установлена на симулятор.
- Нативно проверено отключение кнопки без выбора. Положительный запрос с выбором отложен: Mac повторно заблокирован. Сквозные серверные проверки ванной и спальни относятся к dev.41.

## 0.1.0-dev.41 - 2026-11-01
- Analysis API now requires explicit work_scopes: wall_paint, floor_finish, lighting, textiles. Empty/unknown/duplicate scopes and changed response scopes are rejected. The model grammar restricts step/material categories to the requested selection.
- Prompt 9 no longer forces three wall/floor/light tasks. The bedroom case now proposes only lighting and textiles and leaves wood unchanged; bathroom returns wall-paint/light work. Real API runs: 15.8 s and 25.9 s. Scene descriptions still contain errors, so quality is not approved.
- Eleven Python tests and Go analysis race tests passed; vet clean. Flutter selection UI follows in dev.42; old client builds do not supply the new mandatory field.

## 0.1.0-dev.40 - 2026-11-01
- Исправлено чтение JPEG/MPO: используется основной кадр, применяется EXIF-ориентация, метаданные удаляются из изображения для модели. Лимиты размера сохранены. Десять Python-тестов прошли.
- Добавлена воспроизводимая проверка через Go API для ванной и спальни, с источниками/лицензиями/хешами и приватными отчётами. Сами фото в Git не входят.
- Качество модели не принято: спальня содержит ошибочное распознавание и нарушение пожелания сохранить дерево; ванная после исправления чтения всё ещё не проходит генерацию плана.

## 0.1.0-dev.39 - 2026-11-01
- На симуляторе со сборкой 37 подтверждён полный путь: проём 1×2 м → площадь стен 23 м² → тестовая норма 100 мл/м², 2 слоя, 10% запаса → 5060 мл и 3 упаковки по 2500 мл.
- После полного перезапуска проём и расчёт сохранились. Просмотрены нативные формы, схема и карточка результата. Документационная версия; бинарники остаются dev.37.

## 0.1.0-dev.38 - 2026-11-01
- STATUS.md сокращён до актуальных функций, проверок, ограничений и следующего шага. Прежние подробные записи сохранены в docs/testing-history.md.
- README и решения приведены к текущему состоянию: локальный анализ, планы и расчёты реализованы, публичный API и магазинные релизы ещё не готовы. Поведение приложения не менялось; последние бинарники — dev.37.

## 0.1.0-dev.37 - 2026-11-01
- Добавлен план по обмерам внутри объекта: пропорции помещения, номера стен, проёмы и размеры. Геометрия берётся из сохранённых измерений; створки и инженерные сети не придумываются.
- Восемь языков, светлая и графитовая темы. Текст и подписи учитывают системный масштаб. Визуальные рендеры при 3x проверены отдельно; для читаемого тестового рендера использован локальный Arial, шрифт приложения не менялся.
- Все 69 Flutter-тестов прошли; статический анализ чистый. Go race-тесты и vet прошли, семь Python-тестов модели прошли ранее в dev.34. Нативная проверка новых форм и схемы ожидает разблокировки Mac.

## 0.1.0-dev.36 - 2026-11-01
- Добавлена форма расчёта по конкретному продукту: поверхности, источник нормы, единицы, расход на слой, фасовка, слои и запас. Каталог не имитируется: данные продукта вводит и проверяет пользователь.
- Результат отображается в общей истории: площадь работ, потребность, упаковки и исходные нормы. Восемь языков, две темы, системный масштаб текста.
- Все 67 Flutter-тестов прошли, статический анализ чистый. Проверены ввод и возврат в историю при 3x в обеих темах. Сборка 36 для симулятора успешна; нативная проверка новой формы ещё продолжается.

## 0.1.0-dev.35 - 2026-11-01
- Material calculations can be saved as history entries with selected surfaces, a measurement snapshot, product consumption/source, layers, waste, required quantity and package count. Later opening changes do not rewrite old calculations.
- New test passed: 23.4 m² × synthetic 100 ml/m² × 2 coats × 10% waste = 5148 ml, three 2500 ml packages. Synthetic inputs are test data, not a product recommendation. Unknown surfaces and another account are rejected. UI follows separately.

## 0.1.0-dev.34 - 2026-11-01
- Russian-only lexical checks no longer reject material names in other languages. Retry instructions use the requested language; prompt version is 8. General JSON and text checks remain enabled.
- Seven Python tests passed. Real authenticated API checks returned English in 14.6 s and Spanish in 12.7 s on the same kitchen photo. These checks establish language routing only, not professional quality: Spanish still called natural light a material.

## 0.1.0-dev.33 - 2026-11-01
- Добавлено пропущенное описание dev.32 отдельным коммитом без переписывания истории. Поведение приложения не изменено.

## 0.1.0-dev.32 - 2026-11-01
- Встроены проёмы дверей и окон: выбор стены, размеры и координаты, удаление ошибочной записи, площадь стен за вычетом проёмов. Восемь языков.
- Все 64 Flutter-теста прошли; анализ чистый. После добавления hint-подписей повторно прошли три теста проёмов. Сборка 32 для симулятора успешна.
- Нативно сохранены размеры 3 × 2 × 2,5 м и открыта форма. Нативное сохранение проёма ещё не подтверждено; в widget-тестах проверено изменение 25 → 23,4 м² и отказ неверного размера.

## 0.1.0-dev.31 - 2026-11-01
- Прямоугольные обмеры соединены с расчётным ядром: пол, потолок, четыре стены и проёмы с координатами. Вычитается площадь конкретного проёма на конкретной стене.
- Проёмы сохраняются в существующей комнате без миграции старых данных; пересечения и выход за границы отклоняются до записи. Проверены сохранение, отказ ошибочного обновления и изоляция аккаунтов. Интерфейс проёмов — следующий этап.

## 0.1.0-dev.30 - 2026-11-01
- Анализ доступен у каждой записи исходного состояния, использует её фото и пожелания и сохраняет правильный sourceHistoryId. Ключ состояния привязан к записи.
- На симуляторе проверен реальный сценарий кухни: запрос к модели, предложение в истории, полный перезапуск и повторное открытие без потери предложения. Проверка на бинарнике 28 с исправленной подписью dev.29.
- Тесты обеих тем при 3x теперь используют два исходника и проверяют выбор второго. Модель по-прежнему выдаёт предварительные общие идеи без точных количеств.

## 0.1.0-dev.29 - 2026-11-01
- Исправлена сборка симулятора: Xcode создаёт подпись и simulated entitlements, необходимые Keychain. Причина ошибки анализа — -34018 при сохранении refresh-токена в неподписанной сборке.
- Нативный запрос теперь достигает модели: фото цветов отклонено как неподходящее помещение, план в историю не добавлен. Память вместо Keychain не используется. Диагностика debug пишет только категорию ошибки.

## 0.1.0-dev.28 - 2026-11-01
- Подключён Flutter-клиент анализа и сохранение предварительного предложения в общую историю с привязкой к исходному фото и происхождением модели. Восемь языков, ожидание, ошибки и повтор.
- Все 59 Flutter-тестов прошли, анализ чистый. Сборка 28 запущена на симуляторе; создание с фото прошло, реальный нативный запрос пока завершился ошибкой и требует исправления. Работа модели через Go подтверждена отдельно в dev.27.

## 0.1.0-dev.27 - 2026-11-01
- Добавлен единый запуск локальных Go API и ML-воркера для симулятора; секрет создаётся в private с правами 0600, завершение останавливает оба процесса.
- Убрана запись отклонённых ответов модели на диск.
- Реальный запрос через гостевую сессию и Go API распознал кухню и вернул три этапа за 16,7 с. Шесть Python-тестов и все Go-тесты прошли. Flutter ещё не показывает результат.

## 0.1.0-dev.26 - 2026-11-01
- Черновик ремонта отбрасывается, если этап начинается с осмотра, материал не называет краску, пол или свет, в вопросе есть расход, либо предложены плёнка, лак, прозрачный слой, невидимая плитка или штукатурка.
- На том же кухонном снимке ответ за 15,0 с при пике 3,95 ГБ назвал повара, пироги и висящую посуду. План: светлая матовая краска стен без снятия посуды, светлый матовый пол, замена старых светильников без переноса. В приложение не выводится. Упоминание рисунка пола не подтверждено кадром. Другие помещения этим текстом не проверялись.


## 0.1.0-dev.25 - 2026-11-01
- Локальный разбор сначала описывает снимок, затем смотрит на фото ещё раз и составляет план. Повтор отбрасывает латиницу, плёнки, лак, невидимую штукатурку и плитку, а также вопросы про расход.
- На одном кухонном снимке ответ назвал повара, пироги и подвесную посуду и предложил светлую краску стен и покрытие пола, не заменяя технику. В приложение результат не выводится. Один кадр не доказывает устойчивость на других помещениях.


## 0.1.0-dev.24 - 2026-11-01
- Добавлен локальный воркер зрения и `POST /v1/analysis`: сессия проверяется до и после расчёта, принимаются только JPEG/PNG в заданных пределах, ответ с чужого адреса и сломанный JSON отклоняются.
- Снимок сначала описывается и классифицируется. План ремонта запрашивается только если это интерьер; для клавиатуры и других неподходящих кадров план не создаётся.
- В приложение результат не выводится. Пробный прогон 4-битной Qwen3-VL-4B ещё смешивает языки и предлагает слишком общие работы. Это не выбранная продуктовая модель.


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
