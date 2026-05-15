import type { Request, Response } from "express";
import type { Prisma } from "@prisma/client";
import { prisma } from "../vars.js";
import { BaseAPIController } from "./base_api.js";

type JsonMap = Record<string, unknown>;

class PlayerController extends BaseAPIController {
  async getOrCreatePlayer(req: Request, res: Response): Promise<void> {
    const steam_id = typeof req.params.steam_id === "string" ? req.params.steam_id : req.params.steam_id?.[0];
    if (!steam_id) {
      res.status(400).json({ error: "steam_id required" });
      return;
    }
    const player =
      (await this.db.player.findUnique({ where: { steam_id } })) ??
      (await this.db.player.create({ data: { steam_id } }));
    res.json(player);
  }

  async getPlayerForRoute(req: Request, res: Response): Promise<void> {
    const id = (req.body as { id?: string })?.id;
    if (!id) {
      res.status(400).json({ error: "id is not defined" });
      return;
    }
    const include = {
      participations: {
        include: {
          match: true,
          hero: true,
        },
      },
    };
    let player = await this.db.player.findUnique({
      where: { steam_id: id },
      include,
    });
    if (!player) {
      await this.db.player.create({ data: { steam_id: id } });
      player = await this.db.player.findUnique({
        where: { steam_id: id },
        include,
      });
    }
    if (!player) {
      res.status(500).json({ error: "failed to load player" });
      return;
    }
    res.json(player);
  }

  async updatePlayer(req: Request, res: Response): Promise<void> {
    const { id, currency, heroes, items } = req.body as {
      id?: string;
      currency?: number;
      heroes?: JsonMap;
      items?: JsonMap;
    };
    if (!id) {
      res.status(400).json({ error: "id required" });
      return;
    }
    const player = await this.db.player.findUnique({ where: { steam_id: id } });
    if (!player) {
      res.status(404).json({ error: "not found" });
      return;
    }
    const updated = await this.db.player.update({
      where: { steam_id: id },
      data: {
        currency: currency !== undefined ? Math.max(0, currency) : undefined,
        heroes: heroes !== undefined ? (heroes as Prisma.InputJsonValue) : undefined,
        items: items !== undefined ? (items as Prisma.InputJsonValue) : undefined,
      },
    });
    res.json(updated);
  }
}

declare global {
  var playerController: PlayerController;
}

if (!global.playerController) {
  global.playerController = new PlayerController(prisma);
}

export const playerController = global.playerController;
