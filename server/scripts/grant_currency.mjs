/**
 * Выдать валюту игроку в БД (для тестов магазина).
 *
 * Использование из папки server:
 *   node scripts/grant_currency.mjs <steam_account_id> [сумма]
 * Пример:
 *   node scripts/grant_currency.mjs 123456789 500000
 *
 * steam_account_id — тот же числовой ID, что PlayerResource:GetSteamAccountID в Dota (не Steam64).
 * Берёт API_KEY и PORT из server/.env (скопируй из .env.example и выставь CUSTOM_GAME_KEY).
 */
import path from "node:path";
import { fileURLToPath } from "node:url";
import dotenv from "dotenv";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, "..", ".env") });

const base = `http://127.0.0.1:${Number(process.env.PORT) || 3000}`;
const apiKey = process.env.CUSTOM_GAME_KEY ?? "";

const steamId = process.argv[2];
const amount = Number(process.argv[3] ?? "500000");

if (!steamId || !/^\d+$/.test(steamId)) {
  console.error("Укажи Steam Account ID (только цифры), например: node scripts/grant_currency.mjs 123456789 500000");
  process.exit(1);
}

if (!Number.isFinite(amount) || amount < 0) {
  console.error("Некорректная сумма");
  process.exit(1);
}

const body = (extra) => JSON.stringify({ api_key: apiKey, ...extra });

async function main() {
  const r1 = await fetch(`${base}/api/player/${steamId}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=utf-8" },
    body: body({}),
  });
  const t1 = await r1.text();
  if (!r1.ok) {
    console.error("POST /api/player/:steam_id", r1.status, t1);
    process.exit(1);
  }

  const r2 = await fetch(`${base}/api/player_update`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=utf-8" },
    body: body({ id: steamId, currency: amount }),
  });
  const t2 = await r2.text();
  if (!r2.ok) {
    console.error("POST /api/player_update", r2.status, t2);
    process.exit(1);
  }

  console.log("OK, валюта установлена:", amount, "steam_id:", steamId);
  console.log(JSON.parse(t2));
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
