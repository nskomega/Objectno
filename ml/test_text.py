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

class MultilingualPlanTest(unittest.TestCase):
    def test_non_russian_material_names_are_not_checked_as_russian(self):
        from worker import Plan,WorkItem,check_plan
        plan=Plan(concept='Use light wall paint and retain the existing kitchen layout.',
          work_steps=[WorkItem(work_scope='wall_paint',text='Paint the walls')],
          materials=[WorkItem(work_scope='wall_paint',text='Washable wall paint')],questions=['Which items should remain?','May the lights change?'],
          uncertainties=['The wall condition needs inspection'])
        for language in ['en','es','fr','de','it','pt','tr']:
            check_plan(['A wooden table'],plan,language)
        with self.assertRaises(ValueError):check_plan(['A wooden table'],plan,'ru')

if __name__ == '__main__':
    unittest.main()

class ScopedPlanTest(unittest.TestCase):
    def test_unselected_floor_work_is_rejected_even_if_text_is_valid(self):
        from worker import Plan,WorkItem,check_plan
        plan=Plan(concept='Refresh the room with subtle lighting and preserve the floor.',
            work_steps=[WorkItem(work_scope='floor_finish',text='Replace the floor covering')],
            materials=[WorkItem(work_scope='floor_finish',text='New floor covering')],questions=[],uncertainties=['Existing wall condition'])
        with self.assertRaisesRegex(ValueError,'scope_mismatch'):
            check_plan(['Visible floor'],plan,'en',['lighting'])

class ObservationLabelsTest(unittest.TestCase):
    def test_all_languages_cover_the_same_bounded_item_vocabulary(self):
        from worker import ITEM_TAGS,LANGUAGES,OBSERVATION_LABELS,Scene
        self.assertEqual(set(OBSERVATION_LABELS),set(LANGUAGES))
        for language,labels in OBSERVATION_LABELS.items():
            self.assertEqual(set(labels),set(ITEM_TAGS))
            self.assertTrue(all(isinstance(label,str) and label.strip() for label in labels.values()))
        self.assertEqual(OBSERVATION_LABELS['ru']['ceiling_fan'],'Потолочный вентилятор')
        with self.assertRaises(ValueError):Scene(items=['wind_generator'],scene_type='interior')
