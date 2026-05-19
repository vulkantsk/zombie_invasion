#!/usr/bin/env python3
"""Scan custom ability Lua and emit / inject Precache(context) blocks."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VSCRIPTS = ROOT / "game" / "zombie_invasion" / "scripts" / "vscripts"

SCAN_DIRS = [
    VSCRIPTS / "heroes",
    VSCRIPTS / "abilities",
    VSCRIPTS / "items" / "book_of_heroes",
]

PARTICLE_RE = re.compile(r'["\'](particles/[^"\']+\.vpcf)["\']', re.I)
SOUND_RE = re.compile(
    r'(?:EmitSoundOn|EmitSoundOnClient|EmitSoundOnLocationWithCaster|EmitSound|EmitGlobalSound|StopSoundOn|StartSoundEvent)\s*\(\s*["\']([^"\']+)["\']',
    re.I,
)
SOUND_VAR_RE = re.compile(
    r'(?:local\s+)?(?:self\.)?sound_\w+\s*=\s*["\']([^"\']+)["\']',
    re.I,
)
CLASS_RE = re.compile(r"([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*class\s*\(", re.M)
LINK_MOD_RE = re.compile(
    r'LinkLuaModifier\s*\(\s*["\']([^"\']+)["\']\s*,\s*["\']([^"\']+)["\']',
    re.I,
)
PRECACHE_RE = re.compile(r"function\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*:\s*Precache\s*\(", re.I)


def lua_path_to_file(mod_path: str, base_file: Path) -> Path | None:
    p = mod_path.replace("\\", "/")
    if not p.endswith(".lua"):
        p = p + ".lua"
    candidates = [
        VSCRIPTS / p,
        base_file.parent / Path(p).name,
        base_file.parent / p,
    ]
    for c in candidates:
        if c.is_file():
            return c
    return None


def read_resources(path: Path) -> tuple[set[str], set[str]]:
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return set(), set()
    particles = set(PARTICLE_RE.findall(text))
    sounds = set(SOUND_RE.findall(text)) | set(SOUND_VAR_RE.findall(text))
    return particles, sounds


def find_ability_classes(text: str) -> list[str]:
    found = CLASS_RE.findall(text)
    # Prefer ability-like names over modifier_* when both exist in one file
    abilities = [c for c in found if not c.startswith("modifier_")]
    return abilities if abilities else found


def collect_for_file(path: Path) -> tuple[set[str], set[str], list[str]]:
    text = path.read_text(encoding="utf-8", errors="replace")
    particles, sounds = read_resources(path)
    classes = find_ability_classes(text)
    linked: list[str] = []
    for _, mod_path in LINK_MOD_RE.findall(text):
        mod_file = lua_path_to_file(mod_path, path)
        if mod_file:
            linked.append(str(mod_file.relative_to(VSCRIPTS)).replace("\\", "/"))
            p2, s2 = read_resources(mod_file)
            particles |= p2
            sounds |= s2
    return particles, sounds, classes


def resolve_sound_pack(event: str) -> str:
    custom = {
        "hood_shoot": "soundevents/invasion_sounds_custom.vsndevts",
        "gate_dead": "soundevents/invasion_sounds_custom.vsndevts",
        "gate_dead_theme": "soundevents/invasion_sounds_custom.vsndevts",
        "gate_dead_after": "soundevents/invasion_sounds_custom.vsndevts",
        "limiter": "soundevents/invasion_sounds_items.vsndevts",
        "evolution": "soundevents/invasion_sounds_items.vsndevts",
    }
    if event in custom:
        return custom[event]
    if event.startswith("Ability.") and "Assassinate" in event:
        return "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts"

    m = re.match(r"^[Hh]ero_([A-Za-z0-9_]+)\.", event)
    if not m:
        if "crystal" in event.lower() or "Crystal" in event:
            return "soundevents/invasion_sounds_custom.vsndevts"
        return "soundevents/invasion_sounds_custom.vsndevts"

    hero = m.group(1)
    overrides = {
        "DoomBringer": "doombringer",
        "SkeletonKing": "skeleton_king",
        "CrystalMaiden": "crystalmaiden",
        "Nevermore": "nevermore",
        "TemplarAssassin": "templar_assassin",
        "PhantomAssassin": "phantom_assassin",
        "SkywrathMage": "skywrath_mage",
        "DragonKnight": "dragon_knight",
        "DarkSeer": "dark_seer",
        "DarkWillow": "dark_willow",
        "OgreMagi": "ogre_magi",
        "LegionCommander": "legion_commander",
        "AncientApparition": "ancient_apparition",
        "WinterWyvern": "winter_wyvern",
        "DrowRanger": "drow_ranger",
        "Invoker": "invoker",
        "Medusa": "medusa",
        "Luna": "luna",
        "Tidehunter": "tidehunter",
        "Abaddon": "abaddon",
        "ChaosKnight": "chaos_knight",
        "Hoodwink": "hoodwink",
        "Marci": "marci",
        "Silencer": "silencer",
        "Sniper": "sniper",
        "Slark": "slark",
        "Rubick": "rubick",
        "Ursa": "ursa",
        "Axe": "axe",
        "Juggernaut": "juggernaut",
        "Enigma": "enigma",
        "Viper": "viper",
        "Warlock": "warlock",
        "Terrorblade": "terrorblade",
        "Bristleback": "bristleback",
        "Centaur": "centaur",
        "Razor": "razor",
        "Lion": "lion",
        "Jakiro": "jakiro",
        "Alchemist": "alchemist",
        "Undying": "undying",
        "Wisp": "wisp",
        "VengefulSpirit": "vengefulspirit",
    }
    slug = overrides.get(hero)
    if not slug:
        slug = re.sub(r"(?<!^)(?=[A-Z])", "_", hero).lower()
    return f"soundevents/game_sounds_heroes/game_sounds_{slug}.vsndevts"


def make_precache_block(class_name: str, particles: set[str], sounds: set[str]) -> str:
    packs = sorted({resolve_sound_pack(s) for s in sounds if s})
    lines = [
        f"function {class_name}:Precache(context)",
        "\tPrecacheAbilityResources({",
    ]
    plist = sorted(particles)
    if plist:
        lines.append("\t\t" + ",\n\t\t".join(f'"{p}"' for p in plist) + ",")
    lines.append("\t}, {")
    if sounds:
        slist = sorted(sounds)
        lines.append("\t\t" + ",\n\t\t".join(f'"{s}"' for s in slist) + ",")
    lines.append("\t}, context)")
    lines.append("end")
    lines.append("")
    return "\n".join(lines)


def inject_precache(path: Path, dry_run: bool = False) -> bool:
    text = path.read_text(encoding="utf-8", errors="replace")
    if "modifier_" in path.name and " = class(" not in text:
        return False
    classes = find_ability_classes(text)
    ability_classes = [c for c in classes if not c.startswith("modifier_")]
    if not ability_classes:
        ability_classes = classes
    if not ability_classes:
        return False

    particles, sounds, _ = collect_for_file(path)
    if not particles and not sounds:
        return False  # skip abilities with no VFX/SFX references in lua

    changed = False
    new_text = text

    for cls in ability_classes:
        if re.search(rf"function\s+{re.escape(cls)}\s*:\s*Precache\s*\(", new_text, re.I):
            continue
        block = make_precache_block(cls, particles, sounds)
        # Empty class({}) — insert after declaration
        m = re.search(rf"{re.escape(cls)}\s*=\s*class\s*\(\s*\{{\s*\}}\s*\)", new_text)
        if m:
            insert_at = m.end()
            after = new_text[insert_at : insert_at + 32]
            if after.lstrip().startswith("end"):
                end_m = re.match(r"\s*end", new_text[insert_at:])
                if end_m:
                    insert_at = insert_at + end_m.end()
            new_text = new_text[:insert_at] + "\n\n" + block + new_text[insert_at:]
            changed = True
            continue
        # Inline modifier table class({ IsHidden = ... }) — insert BEFORE class line
        m2 = re.search(rf"^(\s*){re.escape(cls)}\s*=\s*class\s*\(\s*\{{", new_text, re.M)
        if m2:
            insert_at = m2.start()
            new_text = new_text[:insert_at] + block + "\n" + new_text[insert_at:]
            changed = True
            continue
        # Plain table ability: name = {}
        m3 = re.search(rf"^(\s*){re.escape(cls)}\s*=\s*\{{\s*\}}\s*$", new_text, re.M)
        if m3:
            insert_at = m3.end()
            new_text = (
                new_text[:insert_at]
                + f"\n\n{cls} = class({{}})\n\n"
                + block
                + new_text[insert_at:]
            )
            # Remove old `name = {}` line
            new_text = re.sub(
                rf"^{re.escape(m3.group(1))}{re.escape(cls)}\s*=\s*\{{\s*\}}\s*\n",
                "",
                new_text,
                count=1,
                flags=re.M,
            )
            changed = True

    if changed and not dry_run:
        if "PrecacheAbilityResources" in new_text and "precache_ability" not in new_text:
            # util loaded from addon_game_mode
            pass
        path.write_text(new_text, encoding="utf-8", newline="\n")
    return changed


def main() -> int:
    inject = "--inject" in sys.argv
    dry = "--dry-run" in sys.argv
    count = 0
    for scan_dir in SCAN_DIRS:
        if not scan_dir.exists():
            continue
        for path in sorted(scan_dir.rglob("*.lua")):
            if path.name.startswith("modifier_") and " = class(" not in path.read_text(
                encoding="utf-8", errors="replace"
            ):
                continue
            if inject_precache(path, dry_run=dry or not inject):
                count += 1
                rel = path.relative_to(ROOT)
                print(f"{'[dry] ' if dry or not inject else ''}{rel}")
    print(f"Total: {count} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
