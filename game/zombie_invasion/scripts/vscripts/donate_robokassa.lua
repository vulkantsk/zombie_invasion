--- Покупка донат-паков через Робокассу.
--- Список паков и создание платежа берутся с того же сервера, что и Economy
--- (ECONOMY_API_BASE / ECONOMY_API_KEY из economy_api.lua).
--- Игроку отдаётся paymentUrl; Panorama открывает его через ExternalBrowserGoToURL (как в defension).

local json = require("libraries.rxi_json")

if DonateRobokassa == nil then
	DonateRobokassa = class({})
end

DonateRobokassa._packages_by_id = DonateRobokassa._packages_by_id or {}
DonateRobokassa._last_buy_at = DonateRobokassa._last_buy_at or {}
DonateRobokassa._packages_loaded = DonateRobokassa._packages_loaded or false

local BUY_COOLDOWN = 2.0

--- Как в donate.lua / difficulty.lua: PlayerID берём из data, не из первого аргумента RegisterListener.
local function resolve_player_id(_event_source, data)
	if type(data) ~= "table" then
		return nil
	end
	local pid = data.PlayerID
	if pid == nil then
		pid = data.id
	end
	if pid == nil then
		pid = data.player_id
	end
	pid = tonumber(pid)
	if pid ~= nil and PlayerResource:IsValidPlayerID(pid) then
		return pid
	end
	return nil
end

local function http_create()
	return CreateHTTPRequestScriptVM or CreateHTTPRequest
end

--- Аналог Economy:HttpPost, но колбэк получает (code, data) — нужен,
--- чтобы маппить 400/403/404/503 от /donate/* в осмысленные ошибки клиенту.
function DonateRobokassa:_RawPost(route, body, onDone)
	local factory = http_create()
	if not factory then
		print("[DonateRobokassa] HTTP API недоступна")
		if onDone then onDone(-1, nil) end
		return
	end
	body = body or {}
	if ECONOMY_API_KEY and ECONOMY_API_KEY ~= "" then
		body.api_key = ECONOMY_API_KEY
	end
	local base = ECONOMY_API_BASE or ""
	local url = base .. route
	local enc = json.encode(body)
	local req = factory("POST", url)
	if not req then
		if onDone then onDone(-1, nil) end
		return
	end
	if req.SetHTTPRequestHeaderValue then
		req:SetHTTPRequestHeaderValue("Content-Type", "application/json; charset=utf-8")
	end
	if req.SetHTTPRequestRawPostBody then
		req:SetHTTPRequestRawPostBody("application/json", enc)
	end
	req:Send(function(res)
		local code = res and (res.StatusCode or res.statusCode) or -1
		local text = (res and (res.Body or res.body)) or ""
		local data = nil
		if type(text) == "string" and #text > 0 then
			local ok, parsed = pcall(json.decode, text)
			if ok then
				data = parsed
			end
		end
		if code ~= 200 then
			print("[DonateRobokassa] HTTP", route, code, string.sub(tostring(text), 1, 200))
		end
		if onDone then onDone(code, data) end
	end)
end

--- NetTable не любит вложенные lua-массивы с числовыми ключами — Panorama их не видит.
--- Поэтому раскладываем packages в map { "0" = {...}, "1" = {...}, ... }.
local function packages_to_net(list)
	local out = {}
	if type(list) ~= "table" then
		return out
	end
	local idx = 0
	for _, row in ipairs(list) do
		if type(row) == "table" and row.id ~= nil then
			out[tostring(idx)] = {
				id = tostring(row.id),
				title = tostring(row.title or ""),
				description = tostring(row.description or ""),
				priceRub = tonumber(row.priceRub) or 0,
				currency = tonumber(row.currency) or 0,
				upgradeCurrency = tonumber(row.upgradeCurrency) or 0,
				badge = tostring(row.badge or ""),
				imageUrl = tostring(row.imageUrl or ""),
			}
			idx = idx + 1
		end
	end
	return out
end

function DonateRobokassa:FetchPackages()
	self:_RawPost("/api/donate/bundles-ingame", {}, function(code, data)
		if code ~= 200 or type(data) ~= "table" or type(data.packages) ~= "table" then
			print("[DonateRobokassa] FetchPackages failed code=" .. tostring(code))
			return
		end
		self._packages_by_id = {}
		for _, pkg in ipairs(data.packages) do
			if type(pkg) == "table" and pkg.id ~= nil then
				self._packages_by_id[tostring(pkg.id)] = pkg
			end
		end
		local net_map = packages_to_net(data.packages)
		CustomNetTables:SetTableValue("economy", "donate_packages", net_map)
		self._packages_loaded = true
		local count = 0
		for _ in pairs(self._packages_by_id) do count = count + 1 end
		print("[DonateRobokassa] packages loaded: " .. tostring(count))
	end)
end

local ERROR_MESSAGES = {
	[400] = "Не удалось проверить Steam ID. Перезайди и попробуй ещё раз.",
	[403] = "Доступ запрещён. Свяжись с админом.",
	[404] = "Этот пак больше не доступен.",
	[503] = "Оплата временно недоступна, попробуй позже.",
}

function DonateRobokassa:_SendError(playerId, code, fallback)
	local player = PlayerResource:GetPlayer(playerId)
	if not player then return end
	local message = ERROR_MESSAGES[code] or fallback or "Не удалось создать платёж. Попробуй позже."
	CustomGameEventManager:Send_ServerToPlayer(player, "donate_robokassa_payment_error", {
		code = code,
		message = message,
	})
end

function DonateRobokassa:CreatePayment(playerId, packageId)
	if playerId == nil or not PlayerResource:IsValidPlayerID(playerId) then
		print("[DonateRobokassa] CreatePayment: неверный playerId=" .. tostring(playerId))
		return
	end
	print("[DonateRobokassa] CreatePayment playerId=" .. tostring(playerId) .. " packageId=" .. tostring(packageId))
	packageId = packageId and tostring(packageId) or nil
	if packageId == nil or packageId == "" then
		self:_SendError(playerId, 400, "Не указан пак.")
		return
	end
	local pkg = self._packages_by_id[packageId]
	if pkg == nil then
		self:_SendError(playerId, 404, "Пак не найден.")
		return
	end

	local now = GameRules and GameRules:GetGameTime() or 0
	local last = self._last_buy_at[playerId] or 0
	if (now - last) < BUY_COOLDOWN then
		print("[DonateRobokassa] CreatePayment: cooldown")
		return
	end
	self._last_buy_at[playerId] = now

	local acc = PlayerResource:GetSteamAccountID(playerId)
	if not acc or acc == 0 then
		self:_SendError(playerId, 400, "Не удалось определить Steam ID. Перезайди и попробуй ещё раз.")
		return
	end

	self:_RawPost("/api/donate/create-payment-ingame", {
		packageId = packageId,
		steam_account_id = tostring(acc),
	}, function(code, data)
		if code == 200 and type(data) == "table" and type(data.paymentUrl) == "string" then
			print("[DonateRobokassa] payment ready invId=" .. tostring(data.invId))
			local player = PlayerResource:GetPlayer(playerId)
			if not player then return end
			local title = ""
			if type(data.order) == "table" and data.order.title ~= nil then
				title = tostring(data.order.title)
			end
			if title == "" then
				title = tostring(pkg.title or "")
			end
			CustomGameEventManager:Send_ServerToPlayer(player, "donate_robokassa_payment_ready", {
				paymentUrl = data.paymentUrl,
				invId = tonumber(data.invId) or 0,
				packageId = packageId,
				title = title,
				priceRub = tonumber(pkg.priceRub) or 0,
				currency = tonumber(pkg.currency) or 0,
				upgradeCurrency = tonumber(pkg.upgradeCurrency) or 0,
			})
			return
		end
		local fallback = nil
		if type(data) == "table" and type(data.error) == "string" then
			fallback = data.error
		end
		self:_SendError(playerId, code, fallback)
	end)
end

function DonateRobokassa:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and not self._packages_loaded then
		self:FetchPackages()
	end
end

function DonateRobokassa:Init()
	print("[DonateRobokassa] Init")
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(DonateRobokassa, "OnGameRulesStateChange"), DonateRobokassa)
	CustomGameEventManager:RegisterListener("donate_robokassa_buy", function(_source, data)
		local pid = resolve_player_id(_source, data)
		local packageId = type(data) == "table" and data.packageId or nil
		if pid == nil then
			print("[DonateRobokassa] donate_robokassa_buy: не удалось определить PlayerID")
			return
		end
		DonateRobokassa:CreatePayment(pid, packageId)
	end)
	--- На случай горячей перезагрузки скрипта: если CUSTOM_GAME_SETUP уже прошёл, всё равно подтянем паки.
	if GameRules and GameRules.State_Get and GameRules:State_Get() >= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and not self._packages_loaded then
		self:FetchPackages()
	end
end

DonateRobokassa:Init()
