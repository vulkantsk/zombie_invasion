import express from "express";
import { storeController } from "../controllers/store.js";

export const storeRouter = express.Router();

storeRouter.post("/store/store_info", storeController.getStoreInfo.bind(storeController));
storeRouter.post("/store/buy", storeController.buy.bind(storeController));
