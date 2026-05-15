import express from "express";
import { matchController } from "../controllers/match.js";

export const matchRouter = express.Router();

matchRouter.post("/create_match", matchController.createMatch.bind(matchController));
