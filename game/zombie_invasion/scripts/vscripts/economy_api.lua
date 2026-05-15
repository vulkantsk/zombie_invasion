 
if Economy == nil then
	Economy = class({})
end

local json = require("libraries.rxi_json")

--- База URL без завершающего слэша (например http://127.0.0.1:3000)
ECONOMY_API_BASE = ECONOMY_API_BASE or "http://127.0.0.1:3010"
ECONOMY_API_KEY  = ECONOMY_API_KEY  or "BC7BD311B52FB9A50D2057B66FFCE9A095CD2755"

Economy._player = Economy._player or {}
Economy._match_reported = Economy._match_reported or false
Economy._catalog_sent = Economy._catalog_sent or false

local function http_create()
	return CreateHTTPRequestScriptVM or CreateHTTPRequest
end

function Economy:HttpPost(route, body, onSuccess, onError)
	local factory = http_create()
	if not factory then
		print("[Economy] HTTP API недоступна")
		if onError then
			onError(-1)
		end
		return
	end
	body = body or {}
	if ECONOMY_API_KEY ~= "" then
		body.api_key = ECONOMY_API_KEY
	end
	local url = ECONOMY_API_BASE .. route
	local enc = json.encode(body)
	local req = factory("POST", url)
	if not req then
		if onError then
			onError(-1)
		end
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
		if code ~= 200 then
			print("[Economy] HTTP", route, code, string.sub(tostring(text), 1, 200))
			if onError then
				onError(code)
			end
			return
		end
		local ok, data = pcall(json.decode, text)
		if not ok or type(data) ~= "table" then
			print("[Economy] JSON decode", route)
			if onError then
				onError(code)
			end
			return
		end
		if onSuccess then
			onSuccess(data)
		end
	end)
end

function Economy:GetForPlayer(playerId)
	local row = self._player[playerId]
	if not row then
		return { currency = 0, heroes = {}, items = {} }
	end
	return row
end

--- Custom Net Tables до Panorama: вложенные списки с числовыми ключами Lua (1,2,3) часто не синхронизируются — нужны строковые ключи.
local function economy_catalog_list_to_net(list)
	local out = {}
	if type(list) ~= "table" then
		return out
	end
	local idx = 0
	local n = #list
	if n > 0 then
		for i = 1, n do
			local row = list[i]
			if type(row) == "table" and row.name ~= nil then
				out[tostring(idx)] = {
					name = tostring(row.name),
					price = tonumber(row.price) or 0,
					kind = tostring(row.kind or "item"),
				}
				idx = idx + 1
			end
		end
	else
		for _, row in pairs(list) do
			if type(row) == "table" and row.name ~= nil then
				out[tostring(idx)] = {
					name = tostring(row.name),
					price = tonumber(row.price) or 0,
					kind = tostring(row.kind or "item"),
				}
				idx = idx + 1
			end
		end
	end
	return out
end

local function economy_count_keys(t)
	local c = 0
	if type(t) ~= "table" then
		return 0
	end
	for _ in pairs(t) do
		c = c + 1
	end
	return c
end

function Economy:FetchCatalogThenPlayers()
	self:HttpPost("/api/store/store_info", {}, function(data)
		local heroes_net = economy_catalog_list_to_net(data.heroes or {})
		local items_net = economy_catalog_list_to_net(data.items or {})
		DeepPrintTable(data)
		print('asdasdasdasd')
		CustomNetTables:SetTableValue("economy", "catalog", {
			heroes = heroes_net,
			items = items_net,
		})
		print(
			"[Economy] NetTable economy.catalog set heroes=" .. tostring(economy_count_keys(heroes_net)) .. " items=" .. tostring(economy_count_keys(items_net))
		)
		self._catalog_sent = true
		for p = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(p) then
				self:SyncPlayer(p)
			end
		end
	end)
end

function Economy:SyncPlayer(playerId)
	if not PlayerResource:IsValidPlayerID(playerId) then
		return
	end
	local acc = PlayerResource:GetSteamAccountID(playerId)
	local sid = tostring(acc)
	if acc == 0 then
		self._player[playerId] = { currency = 0, heroes = {}, items = {} }
		CustomNetTables:SetTableValue("economy", tostring(playerId), self._player[playerId])
		if Donate and Donate.RebuildForPlayer then
			Donate:RebuildForPlayer(playerId)
		end
		return
	end
	self:HttpPost("/api/player", { id = sid }, function(data)
		self:ApplyPlayerData(playerId, data)
	end)
end

function Economy:OnCustomGameSetup()
	self._match_reported = false
	self._catalog_sent = false
	self:FetchCatalogThenPlayers()
end

function Economy:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:OnCustomGameSetup()
	end
end

function Economy:RequestBuy(playerId, steamStr, kind, name)
	if not PlayerResource:IsValidPlayerID(playerId) then
		return
	end
	if tostring(PlayerResource:GetSteamAccountID(playerId)) ~= steamStr then
		return
	end
	self:HttpPost("/api/store/buy", { id = steamStr, kind = kind, name = name }, function()
		self:SyncPlayer(playerId)
	end)
end

function Economy:ApplyPlayerData(playerId, data)
	self._player[playerId] = {
		currency = tonumber(data.currency) or 0,
		heroes = type(data.heroes) == "table" and data.heroes or {},
		items = type(data.items) == "table" and data.items or {},
	}
	CustomNetTables:SetTableValue("economy", tostring(playerId), {
		currency = self._player[playerId].currency,
		heroes = self._player[playerId].heroes,
		items = self._player[playerId].items,
	})
	if Donate and Donate.RebuildForPlayer then
		Donate:RebuildForPlayer(playerId)
	end
end

function Economy:RefreshPlayerInfo(playerId)
	if not PlayerResource:IsValidPlayerID(playerId) then
		return
	end
	local player = PlayerResource:GetPlayer(playerId)
	if not player then
		return
	end
	local acc = PlayerResource:GetSteamAccountID(playerId)
	if not acc or acc == 0 then
		CustomGameEventManager:Send_ServerToPlayer(player, "refresh_player_info_done", {
			error = "Не удалось определить Steam ID. Перезайди и попробуй ещё раз.",
		})
		return
	end
	local sid = tostring(acc)
	self:HttpPost("/api/player", { id = sid }, function(data)
		self:ApplyPlayerData(playerId, data)
		CustomGameEventManager:Send_ServerToPlayer(player, "refresh_player_info_done", {})
	end, function()
		CustomGameEventManager:Send_ServerToPlayer(player, "refresh_player_info_done", {
			error = "Не удалось обновить баланс. Попробуй позже.",
		})
	end)
end

function Economy:OnRefreshPlayerInfo(data)
	if type(data) ~= "table" then
		return
	end
	local pid = tonumber(data.PlayerID or data.id)
	if pid == nil or not PlayerResource:IsValidPlayerID(pid) then
		return
	end
	self:RefreshPlayerInfo(pid)
end

function Economy:OnEconomyBuy(_senderPlayerId, data)
	if data == nil or type(data) ~= "table" then
		return
	end
	local pid = data.PlayerID
	if pid == nil then
		return
	end
	pid = tonumber(pid)
	if not PlayerResource:IsValidPlayerID(pid) then
		return
	end
	local kind = data.kind
	local name = data.name
	if type(kind) ~= "string" or type(name) ~= "string" then
		return
	end
	local steam = tostring(PlayerResource:GetSteamAccountID(pid))
	if steam == "0" then
		return
	end
	self:RequestBuy(pid, steam, kind, name)
end

local function difficulty_string()
	if Difficulty and type(Difficulty.leader) == "string" then
		return Difficulty.leader
	end
	return "normal"
end

function Economy:OnMatchDone(keys)
	if self._match_reported then
		return
	end
	self._match_reported = true
	local winningteam = keys.winningteam or keys.WinningTeam
	local isWin = (winningteam == DOTA_TEAM_GOODGUYS)
	local players = {}
	local heroes = {}
	local reward = {}
	for p = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		local isFake = PlayerResource.IsFakeClient and PlayerResource:IsFakeClient(p)
		if PlayerResource:IsValidPlayerID(p) and not isFake then
			local acc = PlayerResource:GetSteamAccountID(p)
			if acc ~= 0 then
				local sid = tostring(acc)
				local hname = nil
				if PlayerResource.GetSelectedHeroName then
					hname = PlayerResource:GetSelectedHeroName(p)
				end
				if hname == nil or hname == "" then
					local ent = PlayerResource:GetSelectedHeroEntity(p)
					if ent then
						hname = ent:GetUnitName()
					end
				end
				hname = hname or "unknown"
				table.insert(players, sid)
				table.insert(heroes, hname)
				if isWin and PlayerResource:GetPlayerTeam(p) == DOTA_TEAM_GOODGUYS then
					table.insert(reward, sid)
				end
			end
		end
	end
	self:HttpPost("/api/create_match", {
		difficulty = difficulty_string(),
		isWin = isWin,
		waves_cleared = 0,
		heroes = heroes,
		players = players,
		players_give_reward = reward,
		wager_total = 0,
		wager_multiplier = 1.0,
	}, function()
		for p = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(p) then
				self:SyncPlayer(p)
			end
		end
	end)
end

function Economy:Init()
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(Economy, "OnGameRulesStateChange"), Economy)
	ListenToGameEvent("dota_match_done", Dynamic_Wrap(Economy, "OnMatchDone"), Economy)
	--- Клиент шлёт (playerId, data); Dynamic_Wrap с ":" подставляет первый аргумент в self → ломается. Оборачиваем явно.
	CustomGameEventManager:RegisterListener("economy_buy", function(playerId, data)
		Economy:OnEconomyBuy(playerId, data)
	end)
	CustomGameEventManager:RegisterListener("refresh_player_info", function(_, data)
		Economy:OnRefreshPlayerInfo(data)
	end)
end

Economy:Init()
