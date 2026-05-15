import type { NextFunction, Request, Response } from "express";
import { getCustomGameKey } from "../vars.js";

export function checkApiKey(req: Request, res: Response, next: NextFunction) {
  const expected = getCustomGameKey();
  if (!expected) {
    next();
    return;
  }
  const key = (req.body as { api_key?: string })?.api_key;
  if (key !== expected) {
    res.status(403).json({ error: "Invalid api_key" });
    return;
  }
  next();
}
