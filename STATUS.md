# Состояние Objectno
Обновлено: 01.11.2026. Исходники: 0.1.0-dev.35.

## Цель и объём
Подготовить первую отправку в App Store и Google Play, затем ежедневные полезные обновления. Цель не выполнена, публикаций нет. Актуальные требования: docs/product-proposal.md. Помощник по ремонту ванной, кухни, спальни и других помещений; санузел — пример. Фото, текст/голос, уточнения, визуализация, размерные схемы, расчёты материалов, реальные товары, инструкции и заказ исполнителей входят в требования первого выпуска, но ещё не реализованы. Модели должны работать на собственных вычислениях без платных API; кандидат Qwen3-VL-4B проверен на одном кухонном кадре, качество для продукта ещё не принято.

## Реализовано
- Локальные объекты и замечания с фото, статусом и фильтрами; сохранение Sembast, каскадное удаление. Фото пока base64, максимум 8 МБ.
- Две темы, системный масштаб текста; восемь языков ru/en/es/fr/de/it/pt/tr, сохраняемый ручной выбор темы и языка плюс системный режим. Шрифт пока системный.
- Go API регистрации, входа, refresh, logout, удаления аккаунта с bbolt, bcrypt, подписанными JWT и ротацией refresh.
- Flutter-клиент сессии, secure storage на мобильных платформах, память на web; экран аккаунта, вход/регистрация/выход/удаление. Смена пользователя сбрасывает навигацию и переключает локальный раздел. Гостевые данные остаются отдельно; синхронизации нет.

## Проверено
- dev.7: dart analyze lib test без замечаний; 35 Flutter-тестов прошли. Есть сценарии хранения, изоляции аккаунтов, ротации токенов, входа/выхода с mock HTTP, локализации и увеличенного текста. Тесты не заменяют проверку secure storage и камеры на устройстве.
- dev.7: web release собран. Первичная визуальная проверка относится к раннему прототипу; новый экран аккаунта визуально ещё не проверен.
- Go API: go test -race ./... и go vet ./... прошли в dev.4.
- dev.8: Xcode 27.2 (27B52), минимальная iOS 15.0; flutter build ios --release --no-codesign успешно, build/ios/iphoneos/Runner.app (17,7 МБ). Это неподписанная сборка, не магазинный архив.
- Android debug APK пока dev.3; после auth новая Android-сборка ещё не выполнена. OpenJDK 17 установлен, есть scripts/build-android-debug.sh.

## Необходимо до отправки
Публичный HTTPS API и конфигурация API_BASE_URL (сейчас не задана: вход явно недоступен, гостевой журнал работает); восстановление доступа/подтверждение email; проверка нативной камеры и хранилища; подпись, идентификаторы и доступ к магазинам; политика данных, поддержка и удаление аккаунта; материалы карточек. Домен danilovit.pro и reg.ru Хост-А есть со слов владельца, поддержка Go-процесса не подтверждена. Расширенный сценарий ремонта выше требует реализации и проверки. Remote GitHub, лицензия и теги пока не настроены.

## Следующий шаг
Настроить и проверить iOS-подпись/запуск на устройстве, собрать актуальный Android; проверить auth с настоящим Go API. Параллельно реализовать общую модель помещений и работ с воспроизводимыми расчётами, затем подключать проверенные локальные модели. Не считать сборку публикацией.

## Дополнительные направления
Telegram: docs/telegram-mini-app.md. BDUI: docs/bdui-proposal.md. Они не заменяют магазинные релизы. История версий и проверок — CHANGELOG.md.

## Расчёты dev.9
Добавлено общее ядро подтверждённых поверхностей и проёмов с расчётом потребности/упаковок по норме продукта, слоям и запасу. Все восемь новых тестов прошли native/Chrome, анализ без замечаний. Подробнее docs/quantity-calculation.md. UI, каталог и сохранение результатов ещё не подключены; это не готовый сквозной помощник по ремонту.

## Rooms - dev.10 / documentation dev.11
The room icon inside a property opens rooms and a measurement form: room type, name, length/width/height, wishes. Areas are gross; openings are not deducted and materials are not calculated on screen. Measurements are stored exactly in mm. Data survives reopen and follows per-account stores and cascade deletion. Eight languages and both themes supported. All 46 tests passed, including the 3x-text room creation flow, dropdown selection, persistence and account isolation; dart analysis clean and web release built. New screen visual verification on a real device remains pending. Native artifacts remain iOS dev.8 / Android dev.3.
Next renovation step: openings, work selection and connecting the calculation core; then photos/local models and real product data. No product rates or supplier links are invented.

## iOS simulator - dev.12
Apple Development and Distribution identities are present; no physical iPhone detected. Simulator build and launch succeeded on iPhone 18 Pro (arm64). Initial home screenshot output/preview/ios-first-launch.png was inspected: app renders, but status bar text needs a light-theme contrast fix. Rooms were not manually exercised on iOS yet. scripts/build-ios-simulator.sh passed; artifact short version 0.1.0 and build number 12 verified. Signing/provisioning and store upload remain pending. Details: docs/ios-build.md.

## Native appearance check - dev.13
Fixed status-bar contrast using theme-specific system overlay styles. Simulator app build 13 (short version 0.1.0) built and launched successfully. Inspected output/preview/ios-light-statusbar.png and ios-dark-statusbar.png: home renders and status text is readable in each theme. Eight existing journal theme/scale tests passed and dart analysis is clean. This checks native home appearance, not camera, secure storage, room creation, physical-device signing or store readiness.

## App icon - dev.14
Custom icon replaces the Flutter placeholder on iOS, Android and web. Source: assets/branding/objectno-icon-source.png (AI-generated using the imagegen skill); distribution assets are derived with scripts/generate-icons.py. All 19 iOS asset entries checked for exact pixel dimensions and no alpha; actool compilation passed. Android debug APK dev.14 built successfully with adaptive launcher resources. No store upload performed.

## iPhone 6s connection
Finder and ideviceinfo confirm iOS 15.8.8 and working USB trust. Xcode 27.2 supports deployment targets starting at iOS 15 but physical-device development only from iOS 17 (Apple system requirements). Local wildcard development profile includes this phone. Direct manual xcodebuild signing failed due package targets/profile selection and duplicate certificate names. Resolved by building unsigned, then signing with the existing matching certificate/profile using scripts/sign-ios-development.py. Release app 0.1.0 build 14 with the new icon was successfully installed via ideviceinstaller; the owner confirmed that the home screen opens. Xcode project migration is retained in dev.15 with explicit iOS 15 targets.

## Device installation - dev.15
ideviceinfo independently confirms iOS 15.8.8. Release app built (18.8 MB), signed locally, codesign verification passed, ideviceinstaller reported Complete and the installed app query confirms dev.objectno.objectno. Installed artifact is build 14; dev.15 records the signing tool and project migration. The owner confirmed the home screen opens on the physical iPhone 6s. Camera capture and photo persistence after force-close/reopen are owner-confirmed; secure-storage checks remain pending; this is user-reported launch evidence, not an automated hardware test. No App Store upload performed.

## Hardware launch confirmed - dev.16
On 2026-10-31 the owner opened the installed app on iPhone 6s / iOS 15.8.8 and reported that the home screen appeared. Installed artifact remains 0.1.0 build 14. This documentation version introduces no app behavior changes. The owner subsequently confirmed camera capture, saving an issue photo, and persistence after force-close/reopen. Authentication still needs a configured public API before end-to-end account testing.

## Camera and persistence - dev.17
Owner-confirmed on physical iPhone 6s / iOS 15.8.8, installed build 14: create test property, add issue, capture photo, save, fully close the app, reopen the same issue; the photo remains visible. This is manual test evidence provided by the owner. Gallery import, denied permissions, interrupted capture, storage exhaustion, account isolation and secure storage have not been verified on hardware. No application behavior changed in this documentation version.

## Profile and tabs - dev.18
Two bottom root tabs, Properties and Profile. Appearance/language now open full scrollable selection pages from Profile; old app-bar popup menus removed. Local profile name can be edited and is isolated per guest/account. Authentication remains in the account screen; public API is still missing. No server profile-name sync claimed.

Validation: dart analysis clean, all 48 Flutter tests passed. New profile tests cover 320x568 at 3x text in both themes; regression tests cover language persistence, account switching and profile-name isolation. Web release and iOS release build succeeded. Browser screenshots inspected: output/preview/profile-tabs-web.png, profile-light-web.png; selection pages observed through accessibility. Build 18 signed and installed successfully, installed CFBundleVersion independently queried as 18. Existing stores were not migrated or deleted, but physical-device photo retention after this update remains unconfirmed. Previous hardware camera/persistence checks were on build 14.

## Compact tabs dev.19
Reduced normal tab height while retaining scalable text. Two 3x profile tests passed. Installed hardware app is still build 18; unified object-history implementation is next.

## Единый объект ремонта — dev.20
Реализовано создание объекта с обязательным исходным фото, названием и пожеланиями в одной форме. Объект и первая запись сохраняются атомарно. Основной экран — общая история с датами: исходное состояние, ход работ, результат. Обмеры раскрываются на этой же странице. Существующие записи помещений показываются внутри объекта; старые замечания/фото остаются в прежних хранилищах и включаются в историю по objectId. Работа со статусами старых замечаний доступна через дополнительное действие. Никакой разрушительной миграции или подмены старых фото «исходным состоянием» нет.

Генерация предложений ещё не подключена — это явно указано в интерфейсе. Локальные модели, визуализация и подбор товаров остаются обязательной незавершённой работой, а не готовыми функциями.

Проверено: dart analyze lib test без замечаний; 52 теста прошли. После дополнительного усиления теста удаления аккаунта три теста истории повторно прошли. Проверены атомарное создание, перезапуск БД, порядок этапов, разделение аккаунтов, удаление только нужной истории, сохранность старого фото, создание с фото и история при 3x в обеих темах; нормальный таббар укладывается в 48–56 логических px без нижнего safe area. Web release и iOS release build 20 (19,1 МБ) собраны. В браузере проверены компактные вкладки и новая форма; output/preview/compact-tabs-web.png и unified-project-create-web.png. Новая история на физическом устройстве ещё не проверена.

На iPhone остаётся сборка 18. При попытке подписи/установки сборки 20 устройство отсутствовало, idevice_id также не показал подключённых телефонов; пользователь получил запрос подключения. Новая сборка ещё не подписана и не установлена. После подключения — подписать существующим профилем, обновить без удаления приложения и проверить старые фото/новую историю.

## Device update - 2026-11-01 / dev.21
After the owner reconnected the phone, build 20 was signed with the existing local development profile and installed over the existing app. codesign verification passed; ideviceinstaller reported Complete and the installed-app query confirmed CFBundleVersion 20. The prior disconnected-device status above is historical. App launch, display of legacy data in the new history and photo retention on this build require owner confirmation. No app uninstall was performed. dev.21 records installation only; the physical device runs build 20.

## Hardware history checks - 2026-11-01 / dev.22
The owner confirmed both scenarios on the physical iPhone with installed build 20:
- Existing object: legacy issue and keyboard photo remain visible in the unified renovation history after updating.
- New object: entering wishes and an initial photo, then saving, opens its history with the Before entry and the supplied photo.
These are owner-reported manual results, separate from automated widget/database tests. Progress/final entries, inline measurements on hardware, local-model inference and end-to-end authenticated operation are not proven by these checks. Installed device build remains 20; dev.22 records evidence only.

## Anonymous analysis sessions - dev.23
The client can obtain a normal revocable JWT/refresh session lazily for a guest when an authenticated API operation is requested. No fabricated email/password; guest user flag is explicit. The local journal remains in the existing guest namespace and the profile still offers sign-in. Registered account data remains separate. Go race test covers independent guest identities, rotation and revocation; Flutter tests cover coalescing initial guest requests and preservation of visible guest records. The model/API integration remains work in progress.

## Локальный разбор снимка — dev.24
Кандидат для проверки на своём компьютере: `mlx-community/Qwen3-VL-4B-Instruct-4bit`, ревизия `2fd8dacbdb8f1e54b8c005f081ec5bf79c56376b`. Веса лежат в `private/` и в Git не входят. Воркер слушает только localhost. Go принимает запрос лишь с действующей сессией, проверяет размер и формат снимка и форму ответа. Одновременно выполняется один разбор.

Сначала модель описывает кадр и выбирает тип сцены. План по пожеланиям строится только для интерьера. Если снимок не подходит, этапы и материалы не возвращаются.

`go test ./internal/analysis/` прошёл в dev.24. Flutter-клиент этот ответ не показывает. Модель не принята как продуктовая. На телефоне по-прежнему сборка 20.

## Проверка ответа на кухне — dev.25
Четыре теста текста прошли: латиница, повтор пункта, плёнка, невидимая плитка, лак, штукатурка и вопрос про толщину отклоняются. На снимке кухни прогон prompt 5 занял 14,2 с при пике 3,95 ГБ. Ответ назвал повара в белой рубашке, пироги на столе и висящие кастрюли со сковородами. План: светлая матовая краска стен, светлое покрытие пола, дополнительный свет без перестановки ламп; технику не заменяет. Первый проход ещё предлагал штукатурку и был отброшен. Вопросы остаются общими. Это один кадр, не проверка ванной, спальни и постороннего предмета на текущем тексте. В интерфейс не выводится.

## Кухонный черновик — dev.26
Шесть тестов текста прошли. Прогон prompt 7 того же снимка: 15,0 с, пик MLX 3,95 ГБ. Описание: повар в белой рубашке с подтяжками, пироги и миски на столе, кастрюли и сковороды на стене. План оставляет технику и посуду, красит стены светлой матовой краской, кладёт светлый матовый пол и предлагает заменить светильники, не перенося их. Вопросы: какие предметы оставить и можно ли менять светильники. Фраза про рисунок пола кадром не подтверждена. В интерфейс не выводится. Клавиатура и другие комнаты этим текстом запроса не прогонялись.

## Сквозной локальный API — dev.27
Единый запуск: scripts/run-local-api.py, инструкция docs/local-analysis.md. Проверен реальный HTTP-путь: гостевая сессия → Go → локальная модель → проверенный ответ. Кухня, prompt 7: scene_matches=true, три этапа, 16,7 с с холодным запуском. Это один кадр; качество на других комнатах не подтверждено. Все Go-тесты и шесть Python-тестов прошли. Отклонённые тексты модели больше не пишутся в private/last-reject.json. Следующий этап — Flutter-клиент, сохранение предложения в историю и проверка на симуляторе.

## Предложение в истории — dev.28
Flutter подключён к /v1/analysis: кнопка у исходного фото, ожидание, ошибка и повтор, проверка смены аккаунта. Принятый ответ сохраняется отдельной записью с sourceHistoryId, моделью, ревизией и версией запроса. В карточке: концепция, наблюдения, этапы, категории материалов, вопросы и неизвестные. Это предварительный черновик без количеств и инженерных инструкций. Неподходящее фото не получает запись предложения. Восемь языков.

Проверено: dart analyze lib test — без замечаний; все 59 Flutter-тестов прошли, включая отображение предложения при 3x в обеих темах, привязку к исходнику и отказ после удаления/смены пользователя. В тестах клиента используется mock HTTP; реальная модель отдельно проверена через Go в dev.27. iOS simulator build 28 собран и запущен на iOS 27.2; объект с фото создан через UI. Нативная кнопка анализа показала ошибку запроса — сквозной сценарий на симуляторе НЕ прошёл. Причина пока не установлена (проверить нативную сессию/Keychain и локальное HTTP-соединение). Пользовательский iPhone не обновлялся, на нём остаётся сборка 20.

Следующий фактический шаг: устранить ошибку нативного запроса, получить и повторно открыть реальное предложение на симуляторе; затем расширить проверку модели на другие помещения и неподходящие кадры. Публикаций в магазинах нет.

## Keychain симулятора — dev.29
Причина нативной ошибки dev.28 подтверждена журналом securityd: -34018, нет application-identifier/keychain entitlements. Скрипт теперь включает штатную подпись Xcode (CODE_SIGNING_ALLOWED=YES, CODE_SIGN_IDENTITY=-), которая формирует simulated entitlements в Mach-O. Ручная запись restricted entitlements в ad-hoc подпись не подходит и в итоговый код не включена. Нативный запрос после пересборки прошёл через Keychain и модель: фото цветов отклонено как не-помещение, предложение не сохранено. Проверка проведена на промежуточном бинарнике с номером 28; исходники изменения — dev.29. Следом — реальное фото интерьера, сохранение и перезапуск.

## Исходники и реальное предложение — dev.30
Положительная нативная проверка пройдена: исходное кухонное фото и пожелания → локальная модель → карточка предложения → полный перезапуск → та же карточка в истории. Проверены видимые этапы, категории материалов, вопросы и происхождение. Бинарник проверки — 28 с подписью, исправленной в dev.29; устройство пользователя остаётся на 20. Кандидат модели пока не принят: ответы общие, отдельные детали наблюдений могут быть ошибочны. Новое поведение dev.30: кнопка анализа у каждой записи before, с её собственными фото/текстом; тесты при 3x проверяют второй исходник и его привязку. Следом: подтверждённые обмеры, проёмы и соединение с расчётным ядром, расширение проверки модели на другие комнаты.

## Геометрия с проёмами — dev.31
Добавлены преобразование прямоугольной комнаты в шесть поверхностей расчётного ядра и сохранение/удаление проёмов на одной из четырёх стен. Стены 1/3 соответствуют длине, 2/4 — ширине; отсчёт положения от левого края выбранной стены и пола. Пересечения и выход за границы запрещены. Старые комнаты без openings читаются как комнаты без вычтенных проёмов. Два новых теста прошли. UI и нормы конкретных продуктов пока не подключены.

## Openings UI - dev.32 / documentation dev.33
Openings can be added and removed inside the object measurements. Net wall area uses the calculation core; eight languages are supported. All 64 Flutter tests passed, analysis was clean, and three opening tests passed again after adding input hints. Simulator build 32 succeeded; native room dimensions were saved and the opening form opened. Saving an opening on native iOS remains unverified. Widget tests cover 25 to 23.4 square metres, invalid bounds and 3x text in both themes. The dev.32 changelog write failed before its commit; dev.33 adds the missing release description without rewriting history.

## Model languages - dev.34
Fixed Russian lexical validators incorrectly applied to every language; retries now respect the requested language. Prompt version 8. Seven Python tests passed; real Go API checks returned English (14.6 s) and Spanish (12.7 s) on the known kitchen photo. Quality remains provisional: the Spanish material list included natural light. No product quantities or professional approval are inferred from those results. Other rooms and the remaining model languages still need evaluation.

## Material history - dev.35
Repository now computes and saves an estimate from current confirmed surfaces inside one transaction. It retains the measurement snapshot, selected surfaces, user-entered product/source/rate, layers, waste, quantity, packages and calculation version. Old estimates survive later geometry edits unchanged. New persistence/isolation test passed; analysis clean. Synthetic test rates are not recommendations. The entry form and result rendering follow separately.
