# Состояние Objectno
Обновлено: 31.10.2026. Исходники: 0.1.0-dev.13.

## Цель и объём
Подготовить первую отправку в App Store и Google Play, затем ежедневные полезные обновления. Цель не выполнена, публикаций нет. Актуальные требования: docs/product-proposal.md. Помощник по ремонту ванной, кухни, спальни и других помещений; санузел — пример. Фото, текст/голос, уточнения, визуализация, размерные схемы, расчёты материалов, реальные товары, инструкции и заказ исполнителей входят в требования первого выпуска, но ещё не реализованы. Модели должны работать на собственных вычислениях без платных API; конкретные веса и качество ещё не проверены.

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
