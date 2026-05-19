#!/usr/bin/env python3
"""Remove invalid modifier :Precache blocks (modifiers are nil at load time)."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VSCRIPTS = ROOT / "game" / "zombie_invasion" / "scripts" / "vscripts"

MODIFIER_PRECACHE = re.compile(
    r"\n[ \t]*function modifier_[A-Za-z0-9_]+:Precache\(context\)\n"
    r"[ \t]*PrecacheAbilityResources\(\{.*?\n[ \t]*\}, context\)\n"
    r"[ \t]*end\n",
    re.DOTALL,
)

# Fix precache trapped inside `if X == nil then ... end`
IF_NIL_PRECACHE = re.compile(
    r"if (\w+) == nil then\s*\n\s*\1 = class\(\{\}\)\s*\n+"
    r"(function \1:Precache\(context\)\n"
    r"\tPrecacheAbilityResources\(\{.*?\n\t\}, context\)\n"
    r"end)\s*\n+"
    r"end",
    re.DOTALL,
)


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8", errors="replace")
    new_text = MODIFIER_PRECACHE.sub("\n", text)
    new_text = IF_NIL_PRECACHE.sub(
        r"if \1 == nil then\n    \1 = class({})\nend\n\n\2\n",
        new_text,
    )
    # collapse excessive blank lines
    new_text = re.sub(r"\n{4,}", "\n\n\n", new_text)
    if new_text == text:
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
