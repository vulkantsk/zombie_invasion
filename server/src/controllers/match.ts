import type { Request, Response } from "express";
import { prisma } from "../vars.js";
import { BaseAPIController } from "./base_api.js";

const CURRENCY_WIN = 20;

class MatchController extends BaseAPIController {
  async createMatch(req: Request, res: Response): Promise<void> {
    const {
      difficulty,
      isWin,
      waves_cleared,
      heroes,
      players,
      players_give_reward,
      wager_total,
      wager_multiplier,
    } = req.body as {
      difficulty?: string;
      isWin?: boolean;
      waves_cleared?: number;
      heroes?: string[];
      players?: string[];
      players_give_reward?: string[];
      wager_total?: number;
      wager_multiplier?: number;
    };

    try {
      const heroList = heroes ?? [];
      const playerList = players ?? [];
      const rewardList = players_give_reward ?? [];

      const normalizedHeroes = playerList.map((_, i) => heroList[i] ?? "unknown");

      for (const steam_id of new Set([...playerList, ...rewardList])) {
        if (!steam_id) continue;
        await this.db.player.upsert({
          where: { steam_id },
          update: {},
          create: { steam_id },
        });
      }

      for (const heroName of new Set(normalizedHeroes)) {
        await this.db.hero.upsert({
          where: { name: heroName },
          update: {},
          create: { name: heroName },
        });
      }

      const playersReward: Record<string, { currency: number }> = {};

      if (isWin === true) {
        for (const steam_id of rewardList) {
          const p = await this.db.player.findUnique({ where: { steam_id } });
          if (!p) continue;
          await this.db.player.update({
            where: { steam_id },
            data: {
              currency: { increment: CURRENCY_WIN },
            },
          });
          playersReward[steam_id] = { currency: CURRENCY_WIN };
        }
      }

      const participations = playerList.map((steam_id: string, index: number) => ({
        player: { connect: { steam_id } },
        hero: { connect: { name: normalizedHeroes[index] ?? "unknown" } },
      }));

      const match = await this.db.match.create({
        data: {
          difficulty: difficulty ?? "unknown",
          isWin: !!isWin,
          wavesCleared: waves_cleared ?? 0,
          heroes: normalizedHeroes,
          wagerTotal: wager_total ?? 0,
          wagerMultiplier: wager_multiplier ?? 1.0,
          participations: {
            create: participations,
          },
        },
        include: {
          participations: {
            include: {
              player: true,
              hero: true,
            },
          },
        },
      });

      res.json({ match, playersReward });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Match creation failed" });
    }
  }
}

declare global {
  var matchController: MatchController;
}

if (!global.matchController) {
  global.matchController = new MatchController(prisma);
}

export const matchController = global.matchController;
