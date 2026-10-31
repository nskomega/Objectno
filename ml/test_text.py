import unittest
from worker import reject_materials, reject_quantity_questions, reject_weak_steps, validate_texts

class TextValidationTest(unittest.TestCase):
    def test_russian_rejects_latin_words(self):
        with self.assertRaises(ValueError):
            validate_texts('ru', ['На стене висят кухонные utensils'])

    def test_russian_accepts_visible_details(self):
        validate_texts('ru', [
            'На стене висит медная посуда',
            'На деревянном столе лежат пироги',
            ['Осветлить стены', 'Сохранить плиту'],
        ])

    def test_film_and_unseen_tile_are_rejected(self):
        from worker import reject_invented_finishes
        with self.assertRaises(ValueError):
            reject_invented_finishes(['На стене висит посуда'], ['Светлые пленки для пола'])
        with self.assertRaises(ValueError):
            reject_invented_finishes(['На стене висит посуда'], ['Не меняя расположение плитки'])
        reject_invented_finishes(['Видна напольная плитка'], ['Обновить плитку пола'])
        reject_invented_finishes(['На стене есть крепления'], ['Оставить крепления на месте'])
        with self.assertRaises(ValueError):
            reject_invented_finishes(['Тёмный пол'], ['Прозрачное покрытие пола'])
        with self.assertRaises(ValueError):
            reject_invented_finishes(['Тёмные стены'], ['Нанести лак на стены'])
        with self.assertRaises(ValueError):
            reject_invented_finishes(['Тёмные стены'], ['Нанести слой штукатурки'])
        with self.assertRaises(ValueError):
            reject_quantity_questions(['Какова толщина слоя краски?'])
        reject_quantity_questions(['Какие предметы оставить?'])

    def test_inspection_only_step_is_rejected(self):
        with self.assertRaises(ValueError):
            reject_weak_steps(['Оценить состояние поверхностей перед началом работ'])
        reject_weak_steps(['Добавить свет, не меняя расположение ламп'])
        with self.assertRaises(ValueError):
            reject_weak_steps(['Проверить освещение и заменить светильники'])

    def test_material_must_name_a_finish(self):
        with self.assertRaises(ValueError):
            reject_materials(['Светлый грунтованный полимерный состав для пола'])
        reject_materials(['Светлая матовая краска для стен', 'Светлое покрытие пола'])

    def test_repeated_points_are_rejected(self):
        with self.assertRaises(ValueError):
            validate_texts('ru', ['Осветлить стены', 'осветлить стены'])

if __name__ == '__main__':
    unittest.main()
