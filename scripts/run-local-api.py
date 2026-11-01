#!/usr/bin/env python3
"""Run the authenticated Go API and offline ML worker on this Mac only."""
import base64
import os
from pathlib import Path
import secrets
import shutil
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]

def main():
    python = ROOT / 'ml/.venv/bin/python'
    if not python.exists() or not (ROOT / 'private/models/qwen3-vl-4b-4bit/objectno-model.json').exists():
        sys.exit('Install ml dependencies and download the pinned model first; see docs/local-analysis.md')
    go = shutil.which('go')
    if not go:
        sys.exit('Go is required')
    private = ROOT / 'private'
    private.mkdir(mode=0o700, exist_ok=True)
    key = private / 'local-auth.key'
    try:
        fd = os.open(key, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    except FileExistsError:
        pass
    else:
        with os.fdopen(fd, 'w') as output:
            output.write(base64.b64encode(secrets.token_bytes(32)).decode())
    env = dict(os.environ, AUTH_SIGNING_KEY=key.read_text().strip(),
               AUTH_DB_PATH=str(private / 'local-auth.db'), LISTEN_ADDR='127.0.0.1:8088',
               LOCAL_VISION_URL='http://127.0.0.1:8091/analyze',
               ALLOWED_ORIGINS='http://127.0.0.1:8767,http://localhost:8767',
               HF_HUB_OFFLINE='1', TRANSFORMERS_OFFLINE='1')
    binary = private / 'objectno-local-api'
    subprocess.run([go, 'build', '-o', str(binary), './cmd/objectno'], cwd=ROOT/'server', check=True)
    children = []
    def stop(_signal=None, _frame=None):
        for child in children:
            if child.poll() is None:
                child.terminate()
    signal.signal(signal.SIGINT, stop)
    signal.signal(signal.SIGTERM, stop)
    try:
        children.append(subprocess.Popen([str(python), 'ml/worker.py'], cwd=ROOT, env=env))
        children.append(subprocess.Popen([str(binary)], cwd=ROOT, env=env))
        print('Local API: http://127.0.0.1:8088 — simulator only; Ctrl+C stops both processes.', flush=True)
        while all(child.poll() is None for child in children):
            time.sleep(0.3)
    finally:
        stop()
        for child in children:
            try:
                child.wait(timeout=12)
            except subprocess.TimeoutExpired:
                child.kill()
                child.wait()
    return max((child.returncode for child in children if child.returncode > 0), default=0)

if __name__ == '__main__':
    sys.exit(main())
