"""Local smoke probe. Results stay private and are not public demo data."""
import base64,json,sys
from pathlib import Path
from worker import AnalysisInput,engine
source=Path(sys.argv[1]);output=Path(sys.argv[2])
result=engine.analyze(AnalysisInput(photo=base64.b64encode(source.read_bytes()).decode(),
    wish='Хочу обновить эту кухню: сделать светлее, сохранить планировку и получить современный спокойный интерьер.',language='ru',work_scopes=['wall_paint','floor_finish','lighting']))
output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'scene_matches':result['proposal']['scene_matches'],'elapsed_ms':result['elapsed_ms'],'peak_memory_gb':result['peak_memory_gb']},ensure_ascii=False))
