import { PrismaClient } from "@prisma/client";
import { config as load_dotenv } from "dotenv";

declare global {
  var prisma: PrismaClient;
  var _loaded_dotenv: boolean;
}

if (!global._loaded_dotenv) {
  load_dotenv();
  global._loaded_dotenv = true;
}

if (!global.prisma) {
  global.prisma = new PrismaClient();
}

export const prisma = global.prisma;

export function getCustomGameKey(): string {
  return process.env.CUSTOM_GAME_KEY ?? "";
}
