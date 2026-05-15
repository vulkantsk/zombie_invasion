/** Каталог магазина: цены по умолчанию (можно править). Герои = item_*_change из donate. */

export type ShopKind = "hero" | "item";

export type ShopEntry = { name: string; price: number; kind: ShopKind };

const HERO_DEFAULT = 450;
const ARTIFACT_DEFAULT = 280;
const ADMIN_DEFAULT = 120;

/** Герои (слот donate `heroes`) — в БД хранятся в `Player.heroes`. */
export const SHOP_HEROES: ShopEntry[] = [
  { name: "item_saitama_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_tech_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_change_templar_assassins_creed", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_larks_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_sargatanas_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_strenobu_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_sf_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_sara_change", price: HERO_DEFAULT, kind: "hero" },
  { name: "item_alucard_change", price: HERO_DEFAULT, kind: "hero" },
];

const ARTIFACTS: { name: string; price?: number }[] = [
  { name: "item_midas_donate" },
  { name: "item_color_fuchsia", price: 400 },
  { name: "item_golda" },
  { name: "item_kefteme", price: 350 },
  { name: "item_smoky_miron" },
  { name: "item_piggy_bank" },
  { name: "item_maikl" },
  { name: "item_sheepstick", price: 200 },
  { name: "item_dagon", price: 200 },
];

const ADMIN_ITEMS: { name: string; price?: number }[] = [
  { name: "item_rom" },
  { name: "item_blink" },
  { name: "item_ban_hammer" },
  { name: "item_milk" },
  { name: "item_tvorog" },
  { name: "item_quest_cm_shield" },
  { name: "item_meat" },
  { name: "item_bewstheaks" },
  { name: "item_big_meat" },
  { name: "item_law_frog" },
  { name: "item_eggs" },
  { name: "item_testo" },
  { name: "item_bone" },
  { name: "item_cursed_shield" },
  { name: "item_dragon_armor" },
  { name: "item_dragon_helmet" },
  { name: "item_dragon_sword" },
  { name: "item_dragon_hand" },
  { name: "item_dragon_boots" },
  { name: "item_dragon_shield" },
  { name: "item_piercing_blade" },
  { name: "item_brevno" },
  { name: "item_resist" },
  { name: "item_yad" },
  { name: "item_prox_phoenix" },
  { name: "item_bad_glasses" },
  { name: "item_pirog_tank" },
  { name: "item_pirog_support" },
  { name: "item_pirog_dps" },
  { name: "item_pirog_universal" },
  { name: "item_pirog_magic" },
  { name: "item_admin", price: 500 },
  { name: "item_error", price: 1 },
];

export const SHOP_ITEMS: ShopEntry[] = [
  ...ARTIFACTS.map((a) => ({
    name: a.name,
    price: a.price ?? ARTIFACT_DEFAULT,
    kind: "item" as ShopKind,
  })),
  ...ADMIN_ITEMS.map((a) => ({
    name: a.name,
    price: a.price ?? ADMIN_DEFAULT,
    kind: "item" as ShopKind,
  })),
];

const catalogByName: Map<string, ShopEntry> = new Map();
for (const e of SHOP_HEROES) catalogByName.set(e.name, e);
for (const e of SHOP_ITEMS) catalogByName.set(e.name, e);

export function getShopEntry(name: string): ShopEntry | undefined {
  return catalogByName.get(name);
}

export function getStorePayload() {
  return {
    heroes: SHOP_HEROES,
    items: SHOP_ITEMS,
  };
}
