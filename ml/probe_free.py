import json,time
from pathlib import Path
from PIL import Image
from worker import engine
from mlx_vlm import generate
from mlx_vlm.prompt_utils import apply_chat_template
engine.load()
prompt='''Ты помощник по ремонту. Посмотри на фото и ответь только на русском языке.
Пожелание: сделать эту кухню светлее, сохранить планировку, современная спокойная отделка.
Верни один JSON без markdown с полями:
scene_matches (bool: показан ли интерьер), observations (список 2 видимых деталей),
concept (конкретная идея отделки в 2 предложениях), work_steps (3 этапа работ),
materials (3 категории отделочных материалов), questions (2 уточняющих вопроса),
uncertainties (1 неизвестное по фото).
Не придумывай размеры, расход, цены, товары или скрытые коммуникации.
Если на фото не помещение, scene_matches=false, concept="Нужно фото помещения", work_steps=[], materials=[].'''
formatted=apply_chat_template(engine.processor,engine.model.config,prompt,num_images=1)
started=time.monotonic()
r=generate(engine.model,engine.processor,formatted,image=[Image.open('private/fixtures/coco-397133.jpg')],max_tokens=1100,temperature=0.2,repetition_penalty=1.1,verbose=False)
Path('private/probe-free-4b.txt').write_text(r.text)
print('seconds',round(time.monotonic()-started,2))
