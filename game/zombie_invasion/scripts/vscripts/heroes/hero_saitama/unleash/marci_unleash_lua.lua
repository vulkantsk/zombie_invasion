--------------------------------------------------------------------------------
marci_unleash_lua = class({})
LinkLuaModifier( "modifier_marci_unleash_lua", "heroes/hero_saitama/unleash/modifier_marci_unleash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_animation", "heroes/hero_saitama/unleash/modifier_marci_unleash_lua_animation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_fury", "heroes/hero_saitama/unleash/modifier_marci_unleash_lua_fury", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_debuff", "heroes/hero_saitama/unleash/modifier_marci_unleash_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_recovery", "heroes/hero_saitama/unleash/modifier_marci_unleash_lua_recovery", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function marci_unleash_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

function marci_unleash_lua:Spawn()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Ability Start
function marci_unleash_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_marci_unleash_lua", -- modifier name
		{ duration = duration } -- kv
	)

end