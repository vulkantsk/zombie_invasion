import type { PrismaClient } from "@prisma/client";

export class BaseAPIController {
  private _db: PrismaClient;

  constructor(db: PrismaClient) {
    this._db = db;
  }

  get db(): PrismaClient {
    return this._db;
  }
}
