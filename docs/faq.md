# Частые вопросы

Краткие ответы также доступны в [GitHub Discussions → Q&A](https://github.com/nskomega/Objectno/discussions/categories/q-a).

## Как запустить локальный анализ фото?
Нужны закреплённые веса, MLX-воркер на localhost и Go API с `LOCAL_VISION_URL`. Для iOS Simulator задайте `API_BASE_URL=http://127.0.0.1:8088`. Подробности: [local-analysis.md](local-analysis.md).

## Почему черновик модели не является обмером?
Модель предлагает предварительную концепцию по фото. Размеры и расчёт материалов берутся только из подтверждённых данных пользователя и нормы продукта. См. [quantity-calculation.md](quantity-calculation.md).
