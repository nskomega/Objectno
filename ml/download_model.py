"""Download pinned public weights; never upload input images."""
import json
import os
import shutil
from pathlib import Path
from huggingface_hub import snapshot_download
ROOT = Path(__file__).resolve().parents[1]
os.environ['HF_HUB_DISABLE_TELEMETRY'] = '1'
os.environ['HF_HOME'] = str(ROOT / 'private/huggingface')
MODEL_ID = 'mlx-community/Qwen3-VL-4B-Instruct-4bit'
REVISION = '2fd8dacbdb8f1e54b8c005f081ec5bf79c56376b'
if shutil.disk_usage(ROOT).free < 8 * 1024**3:
    raise SystemExit('At least 8 GiB free space required before model download.')
path = ROOT / 'private/models/qwen3-vl-4b-4bit'
snapshot_download(MODEL_ID, revision=REVISION, local_dir=path,
    allow_patterns=['*.json','*.safetensors','*.txt','*.model','*.jinja','README.md','LICENSE*'])
(path / 'objectno-model.json').write_text(json.dumps({'id':MODEL_ID,'revision':REVISION,'license':'Apache-2.0'},indent=2)+'\n')
print('Pinned model downloaded to', path)
