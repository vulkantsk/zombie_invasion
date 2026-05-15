import type { Request, Response } from "express";
import { prisma } from "../vars.js";
import { BaseAPIController } from "./base_api.js";
import { getShopEntry, getStorePayload } from "../shop_catalog.js";

type JsonMap = Record<string, unknown>;

class StoreController extends BaseAPIController {
  async getStoreInfo(_req: Request, res: Response): Promise<void> {
    res.json(getStorePayload());
  }

  async buy(req: Request, res: Response): Promise<void> {
    const { id, kind, name } = req.body as { id?: string; kind?: string; name?: string };
    if (!id || !kind || !name) {
      res.status(400).json({ error: "id, kind and name required" });
      return;
    }
    if (kind !== "hero" && kind !== "item") {
      res.status(400).json({ error: "kind must be hero or item" });
      return;
    }

    const entry = getShopEntry(name);
    if (!entry || entry.kind !== kind) {
      res.status(403).json({ error: "Нет в магазине" });
      return;
    }

    const player =
      (await this.db.player.findUnique({ where: { steam_id: id } })) ??
      (await this.db.player.create({ data: { steam_id: id } }));

    const field = kind === "hero" ? "heroes" : "items";
    const table = { ...(player[field] as JsonMap) };

    if (table[name]) {
      res.status(403).json({ error: "Уже куплено" });
      return;
    }

    if (player.currency < entry.price) {
      res.status(403).json({ error: "Не хватает валюты" });
      return;
    }

    table[name] = {};

    const updated = await this.db.player.update({
      where: { steam_id: id },
      data: {
        currency: player.currency - entry.price,
        [field]: table,
      },
    });

    res.json({ user: updated, name, kind });
  }
}

declare global {
  var storeController: StoreController;
}

if (!global.storeController) {
  global.storeController = new StoreController(prisma);
}

export const storeController = global.storeController;
