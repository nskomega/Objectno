# Участие в Objectno

Спасибо за интерес к проекту. Ниже — минимальный контур для локальной проверки изменений.

## Перед pull request
1. `flutter pub get`
2. `dart analyze lib test`
3. `flutter test`
4. Для Go: `cd server && go test ./... && go vet ./...`
5. Для локального ML-воркера: `cd ml && .venv/bin/python -m unittest`

## Стиль изменений
- Одно логическое изменение — один PR.
- Пользовательские строки UI добавлять в ARB и все восемь языков.
- Не выдумывать метрики, опыт или результаты проверок.
- Веса моделей и личные данные в `private/` в Git не отправлять.

## Вопросы
Короткие вопросы по запуску и расчётам удобнее задавать в [Discussions → Q&A](https://github.com/nskomega/Objectno/discussions/categories/q-a).
