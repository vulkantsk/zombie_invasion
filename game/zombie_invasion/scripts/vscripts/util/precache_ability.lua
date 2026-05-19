-- Helpers for per-ability Precache(context): particles and hero sound packs (.vsndevts).

local SOUND_PACK_PREFIX = "soundevents/game_sounds_heroes/game_sounds_"
local VO_PACK_PREFIX = "soundevents/voscripts/game_sounds_vo_"

local CUSTOM_SOUND_PACKS = {
	["hood_shoot"] = "soundevents/invasion_sounds_custom.vsndevts",
	["gate_dead"] = "soundevents/invasion_sounds_custom.vsndevts",
	["gate_dead_theme"] = "soundevents/invasion_sounds_custom.vsndevts",
	["gate_dead_after"] = "soundevents/invasion_sounds_custom.vsndevts",
	["limiter"] = "soundevents/invasion_sounds_items.vsndevts",
	["evolution"] = "soundevents/invasion_sounds_items.vsndevts",
}

local HERO_SOUND_OVERRIDES = {
	["DoomBringer"] = "doombringer",
	["SkeletonKing"] = "skeleton_king",
	["WraithKing"] = "skeleton_king",
	["CrystalMaiden"] = "crystalmaiden",
	["Crystal_Maiden"] = "crystalmaiden",
	["Nevermore"] = "nevermore",
	["Necrolyte"] = "necrolyte",
	["Zuus"] = "zuus",
	["Windrunner"] = "windrunner",
	["VengefulSpirit"] = "vengefulspirit",
	["QueenOfPain"] = "queenofpain",
	["KeeperOfTheLight"] = "keeper_of_the_light",
	["LifeStealer"] = "life_stealer",
	["ShadowShaman"] = "shadow_shaman",
	["TemplarAssassin"] = "templar_assassin",
	["PhantomAssassin"] = "phantom_assassin",
	["SkywrathMage"] = "skywrath_mage",
	["DragonKnight"] = "dragon_knight",
	["DarkSeer"] = "dark_seer",
	["DarkWillow"] = "dark_willow",
	["OgreMagi"] = "ogre_magi",
	["ChaosKnight"] = "chaos_knight",
	["AncientApparition"] = "ancient_apparition",
	["WinterWyvern"] = "winter_wyvern",
	["FacelessVoid"] = "faceless_void",
	["ShadowDemon"] = "shadow_demon",
	["NightStalker"] = "nightstalker",
	["DeathProphet"] = "death_prophet",
	["SpiritBreaker"] = "spirit_breaker",
	["LegionCommander"] = "legion_commander",
	["EarthSpirit"] = "earth_spirit",
	["ArcWarden"] = "arc_warden",
	["AbyssalUnderlord"] = "abyssal_underlord",
	["Underlord"] = "abyssal_underlord",
	["DrowRanger"] = "drow_ranger",
	["Grimstroke"] = "grimstroke",
	["SkywrathMage"] = "skywrath_mage",
}

local function camel_to_snake(name)
	local s = name:gsub("(%u)(%l)", "%1_%2"):gsub("(%l)(%u)", "%1_%2")
	return s:lower():gsub("^_", "")
end

function ResolveSoundPackFromEvent(eventName)
	if eventName == nil or eventName == "" then
		return nil
	end

	local custom = CUSTOM_SOUND_PACKS[eventName]
	if custom then
		return custom
	end

	if eventName:sub(1, 5) == "hero_" or eventName:sub(1, 6) == "Hero_" then
		local heroPart = eventName:match("^%a+_([%w_]+)%.")
		if heroPart then
			local override = HERO_SOUND_OVERRIDES[heroPart]
			local slug = override or camel_to_snake(heroPart)
			return SOUND_PACK_PREFIX .. slug .. ".vsndevts"
		end
	end

	if eventName:sub(1, 9) == "Hero_" or eventName:sub(1, 9) == "hero_" then
		local heroPart = eventName:match("^Hero_([%w_]+)%.") or eventName:match("^hero_([%w_]+)%.")
		if heroPart then
			local override = HERO_SOUND_OVERRIDES[heroPart]
			local slug = override or camel_to_snake(heroPart)
			return SOUND_PACK_PREFIX .. slug .. ".vsndevts"
		end
	end

	if eventName:sub(1, 9) == "Ability." then
		if eventName:find("Assassinate") then
			return SOUND_PACK_PREFIX .. "sniper.vsndevts"
		end
	end

	if eventName:find("Crystal") or eventName:find("crystal") then
		return "soundevents/invasion_sounds_custom.vsndevts"
	end

	return "soundevents/invasion_sounds_custom.vsndevts"
end

function PrecacheAbilityParticles(particleList, context)
	if particleList == nil or context == nil then
		return
	end
	local seen = {}
	for _, path in ipairs(particleList) do
		if path and path ~= "" and not seen[path] then
			seen[path] = true
			PrecacheResource("particle", path, context)
		end
	end
end

function PrecacheAbilitySoundPacks(packList, context)
	if packList == nil or context == nil then
		return
	end
	local seen = {}
	for _, pack in ipairs(packList) do
		if pack and pack ~= "" and not seen[pack] then
			seen[pack] = true
			PrecacheResource("soundfile", pack, context)
		end
	end
end

function PrecacheAbilitySoundEvents(soundEvents, context)
	if soundEvents == nil or context == nil then
		return
	end
	local packs = {}
	local seen = {}
	for _, eventName in ipairs(soundEvents) do
		local pack = ResolveSoundPackFromEvent(eventName)
		if pack and not seen[pack] then
			seen[pack] = true
			packs[#packs + 1] = pack
		end
	end
	PrecacheAbilitySoundPacks(packs, context)
end

function PrecacheAbilityResources(particles, soundEvents, context)
	PrecacheAbilityParticles(particles, context)
	PrecacheAbilitySoundEvents(soundEvents, context)
end
