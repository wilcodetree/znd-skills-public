"""Scoped, read-only file evidence. Never claims live instruction loading."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys


def audit(root, home=None, manifest=None, reply=None, forbid=False):
    root = root.resolve()
    bounds = [root] + ([home.resolve()] if home else [])
    checks = []

    def add(kind, path, verdict, **details):
        checks.append(dict(kind=kind, path=str(path), verdict=verdict, **details))

    def read(path, kind):
        try:
            resolved = path.resolve()
            if not any(resolved == b or b in resolved.parents for b in bounds):
                add(kind, path, 'UNVERIFIED', reason='outside selected scope')
                return None
            if path.stat().st_size > 2 * 1024 * 1024:
                add(kind, path, 'UNVERIFIED', reason='over 2 MiB inspection limit')
                return None
            return path.read_bytes()
        except FileNotFoundError:
            add(kind, path, 'FAIL', reason='missing')
        except (OSError, RuntimeError) as exc:
            add(kind, path, 'UNVERIFIED', reason=type(exc).__name__)
        return None

    def instruction(path, chain=()):
        resolved = path.resolve()
        if resolved in chain:
            add('import', path, 'FAIL', reason='import cycle')
            return
        if len(chain) >= 10:
            add('import', path, 'UNVERIFIED', reason='import depth limit')
            return
        data = read(path, 'instruction')
        if data is None:
            return
        try:
            text = data.decode('utf-8-sig')
        except UnicodeError:
            add('instruction', path, 'UNVERIFIED', reason='not UTF-8')
            return
        add('instruction', path, 'PASS', bytes=len(data), sha256=hashlib.sha256(data).hexdigest(),
            meaning='readable file only; authority and loading unverified')
        for target in re.findall(r'^@([^\r\n]+)$', text, re.M):
            instruction(path.parent / target.strip(), chain + (resolved,))

    candidates = [root / n for n in ('AGENTS.override.md', 'AGENTS.md', 'CLAUDE.md', 'CLAUDE.local.md')]
    candidates += [root / '.github/copilot-instructions.md', root / '.claude/CLAUDE.md']
    if home:
        candidates += [home / '.codex/AGENTS.override.md', home / '.codex/AGENTS.md', home / '.claude/CLAUDE.md']
        candidates += sorted((home / '.copilot/instructions').glob('*.md'))
    existing = [p for p in candidates if p.exists()]
    if not root.is_dir():
        add('scope', root, 'UNVERIFIED', reason='not an accessible directory')
    if not existing:
        add('discovery', root, 'UNVERIFIED', reason='no known entry point found')
    for path in existing:
        instruction(path)
    configs = [root / '.claude/settings.json', root / '.claude/settings.local.json', root / '.codex/hooks.json']
    configs += sorted((root / '.github/hooks').glob('*.json'))
    if home:
        configs += [home / '.claude/settings.json', home / '.codex/hooks.json']
        configs += sorted((home / '.copilot/hooks').glob('*.json'))
    for path in configs:
        if not path.exists():
            continue
        data = read(path, 'hooks')
        if data is None:
            continue
        try:
            hooks = json.loads(data).get('hooks', {})
            if not isinstance(hooks, dict):
                raise ValueError()
            add('hooks', path, 'PASS', events=sorted(hooks), meaning='JSON parsed; schema, trust and execution unverified')
        except (ValueError, AttributeError, UnicodeError):
            add('hooks', path, 'UNVERIFIED', reason='unsupported or malformed configuration')
    if manifest:
        data = read(manifest, 'manifest')
        if data is not None:
            try:
                entries = json.loads(data)['files']
                if not isinstance(entries, list) or not entries:
                    raise ValueError()
                for item in entries:
                    path = Path(item['path'])
                    if not path.is_absolute():
                        path = manifest.parent / path
                    expected = item['sha256']
                    if not isinstance(expected, str) or not re.fullmatch('[0-9a-fA-F]{64}', expected):
                        raise ValueError()
                    content = read(path, 'drift')
                    if content is not None:
                        add('drift', path, 'PASS' if hashlib.sha256(content).hexdigest() == expected.lower() else 'FAIL')
            except (ValueError, KeyError, TypeError, UnicodeError):
                add('manifest', manifest, 'UNVERIFIED', reason='unsupported or malformed manifest')
    if reply:
        data = read(reply, 'reply')
        if data is not None:
            try:
                count = data.decode('utf-8-sig').count(chr(0x2014))
                add('reply', reply, ('FAIL' if count else 'PASS') if forbid else 'UNVERIFIED',
                    forbidden_count=count if forbid else None, meaning='sample only; policy check requires --forbid-em-dash')
            except UnicodeError:
                add('reply', reply, 'UNVERIFIED', reason='not UTF-8')
    return {'root': str(root), 'checks': checks, 'runtime_loading': 'UNVERIFIED',
            'runtime_enforcement': 'UNVERIFIED', 'not_inspected': [
                'nested rules', 'TOML overrides', 'editor JSONC', 'account preferences', 'plugins', 'hook trust/execution']}


def exit_code(report):
    verdicts = {c['verdict'] for c in report['checks']}
    return 2 if 'UNVERIFIED' in verdicts else (1 if 'FAIL' in verdicts else 0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, required=True)
    parser.add_argument('--home', type=Path)
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--reply', type=Path)
    parser.add_argument('--forbid-em-dash', action='store_true')
    args = parser.parse_args()
    result = audit(args.root, args.home, args.manifest, args.reply, args.forbid_em_dash)
    print(json.dumps(result, indent=2, ensure_ascii=True))
    sys.exit(exit_code(result))
