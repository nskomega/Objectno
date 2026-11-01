"""Run explicit local-photo cases through the authenticated Go API.

Reports remain private. Passing transport/schema checks is not a quality verdict.
"""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import time
import urllib.error
import urllib.parse
import urllib.request

ROOT = Path(__file__).resolve().parents[1]

def run(manifest, api, output):
    parsed = urllib.parse.urlsplit(api)
    if parsed.scheme != 'http' or parsed.hostname not in ('localhost', '127.0.0.1', '::1') or parsed.username or parsed.query or parsed.fragment or parsed.path not in ('', '/'):
        raise ValueError('Evaluation accepts a loopback API only')
    class NoRedirect(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, *args, **kwargs):
            return None
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}), NoRedirect())
    def post(path, body, token=None):
        headers = {'Content-Type': 'application/json'}
        if token: headers['Authorization'] = 'Bearer '+token
        request = urllib.request.Request(api.rstrip('/')+path, data=json.dumps(body).encode(), headers=headers)
        with opener.open(request, timeout=170) as response:
            data = response.read(65537)
            if len(data)>65536: raise ValueError('Response exceeds limit')
            return json.loads(data) if data else {}
    cases = json.loads(manifest.read_text())
    session = post('/v1/auth/guest', {})
    reports = []
    try:
        for case in cases:
            started = time.monotonic()
            report = {'id': case['id'], 'language': case['language'], 'quality_review': 'pending'}
            try:
                photo = (ROOT / case['photo']).resolve()
                if not photo.is_relative_to(ROOT/'private'): raise ValueError('Fixtures must remain private')
                raw = photo.read_bytes()
                if len(raw)>8*1024*1024: raise ValueError('Photo exceeds limit')
                if case.get('sha256') and hashlib.sha256(raw).hexdigest()!=case['sha256']:
                    raise ValueError('Fixture checksum mismatch')
                result = post('/v1/analysis', {'photo':base64.b64encode(raw).decode(), 'wish':case['wish'], 'language':case['language'],'work_scopes':case['work_scopes']}, session['access_token'])
                proposal = result['proposal']
                report.update(result=result, structural_pass=(set(result.get('work_scopes',[]))==set(case['work_scopes']) and proposal['scene_matches']==case['interior'] and
                  (not case['interior'] or bool(proposal['concept'].strip())) and
                  (case['interior'] or (not proposal['work_steps'] and not proposal['materials']))))
            except urllib.error.HTTPError as error:
                report.update(structural_pass=False, error='HTTPError', http_status=error.code, api_error=error.read(1024).decode(errors='replace'))
            except Exception as error:
                report.update(structural_pass=False, error=type(error).__name__)
            report['wall_seconds'] = round(time.monotonic()-started, 2)
            reports.append(report)
            print(json.dumps({key: report[key] for key in ('id','language','structural_pass','wall_seconds')}, ensure_ascii=False), flush=True)
    finally:
        try: post('/v1/auth/logout', {'refresh_token':session['refresh_token']})
        finally:
            output = output.resolve()
            if not output.is_relative_to(ROOT/'private'): raise ValueError('Reports must remain private')
            output.parent.mkdir(parents=True, exist_ok=True)
            output.write_text(json.dumps(reports, ensure_ascii=False, indent=2)+'\n')
    return all(r['structural_pass'] for r in reports)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', type=Path)
    parser.add_argument('--api', default='http://127.0.0.1:8088')
    parser.add_argument('--output', type=Path, default=ROOT/'private/evaluation/latest.json')
    args = parser.parse_args()
    raise SystemExit(0 if run(args.manifest,args.api,args.output) else 1)
