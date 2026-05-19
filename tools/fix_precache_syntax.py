#!/usr/bin/env python3
"""Move Precache() blocks wrongly injected inside class({ ... }) to before the class."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VSCRIPTS = ROOT / "game" / "zombie_invasion" / "scripts" / "vscripts"

BROKEN = re.compile(
    r"^(\s*)([A-Za-z_][A-Za-z0-9_]*)\s*=\s*class\(\{\s*\n"
    r"\s*\n"
    r"(function \2:Precache\(context\)\s*\n"
    r"(?:.*\n)*?"
    r"end)\s*\n",
    re.MULTILINE,
)


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8", errors="replace")
    new_text, n = BROKEN.subn(r"\1\3\n\n\1\2 = class({\n", text)
    if n == 0:
        return False
    path.write_text(new_text, encoding="utf-8", newline="\n")
    return True


def main() -> int:
    count = 0
    for path in sorted(VSCRIPTS.rglob("*.lua")):
        if fix_file(path):
            count += 1
            print(path.relative_to(ROOT))
    print(f"Fixed {count} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
