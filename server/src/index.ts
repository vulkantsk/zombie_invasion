import path from "node:path";
import { fileURLToPath } from "node:url";
import express from "express";
import dotenv from "dotenv";
import { playerRouter } from "./routes/player.js";
import { matchRouter } from "./routes/match.js";
import { storeRouter } from "./routes/store.js";
import { checkApiKey } from "./middlewares/apiKey.js";
import { requestLog } from "./middlewares/request_log.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, "..", ".env") });

const app = express();
const port = Number(process.env.PORT) || 3000;

app.use(express.json());
app.use(requestLog);

app.use("/api", checkApiKey, playerRouter);
app.use("/api", checkApiKey, matchRouter);
app.use("/api", checkApiKey, storeRouter);

app.listen(port, () => {
  console.log(`Economy API http://localhost:${port}`);
});
