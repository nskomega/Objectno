import unittest
from worker import validate_texts

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
        with self.assertRaises(ValueError):
            reject_invented_finishes(['Тёмные стены'], ['Нанести лак на стены'])
        with self.assertRaises(ValueError):
            reject_invented_finishes(['Тёмные стены'], ['Нанести слой штукатурки'])
        with self.assertRaises(ValueError):
            reject_invented_finishes(['Тёмные стены'], ['Какова толщина слоя краски?'])

    def test_repeated_points_are_rejected(self):
        with self.assertRaises(ValueError):
            validate_texts('ru', ['Осветлить стены', 'осветлить стены'])

if __name__ == '__main__':
    unittest.main()
