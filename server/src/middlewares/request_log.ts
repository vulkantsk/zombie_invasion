import type { NextFunction, Request, Response } from "express";

function redactBody(body: unknown): unknown {
	if (body === null || body === undefined) return body;
	if (typeof body !== "object" || Array.isArray(body)) return body;
	const copy = { ...(body as Record<string, unknown>) };
	if (typeof copy.api_key === "string" && copy.api_key.length > 0) {
		copy.api_key = `[скрыто, длина=${copy.api_key.length}]`;
	}
	return copy;
}

/** Лог каждого запроса: метод, URL, тело; после ответа — статус и время. */
export function requestLog(req: Request, res: Response, next: NextFunction) {
	const rid = Math.random().toString(36).slice(2, 10);
	const started = Date.now();
	const bodyStr = JSON.stringify(redactBody(req.body));
	console.log(`[Economy] ${rid} >>> ${req.method} ${req.originalUrl} body=${bodyStr}`);
	res.on("finish", () => {
		console.log(`[Economy] ${rid} <<< ${res.statusCode} ${Date.now() - started}ms`);
	});
	next();
}
