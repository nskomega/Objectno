# Инструменты разработки

Для разработки нужны Flutter/Dart SDK и настроенный toolchain выбранной платформы. Команды запуска и проверки приведены в README.md.

## Android toolchain
Установлен OpenJDK 17 через Homebrew. Локальная debug-сборка: scripts/build-android-debug.sh. Скрипт использует JAVA_HOME, а на этом Mac при его отсутствии — Homebrew JDK. Глобальные Java-настройки не изменены. Runtime GoLand не содержит jlink и для этой Android-сборки не подходит.
