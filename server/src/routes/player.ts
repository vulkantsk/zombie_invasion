import express from "express";
import { playerController } from "../controllers/player.js";

export const playerRouter = express.Router();

playerRouter.post("/player/:steam_id", playerController.getOrCreatePlayer.bind(playerController));
playerRouter.post("/player", playerController.getPlayerForRoute.bind(playerController));
playerRouter.post("/player_update", playerController.updatePlayer.bind(playerController));
