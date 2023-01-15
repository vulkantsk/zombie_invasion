juggernaut_blade_fury_lua = class({})
LinkLuaModifier( "modifier_juggernaut_blade_fury_lua", "heroes/hero_samurai/spells/modifier_juggernaut_blade_fury_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_jug", "heroes/hero_samurai/spells/modifier_generic_silenced_jug", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function juggernaut_blade_fury_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_phantom_assassin_death_rush") then 
		return nil 
	else
	-- load data
	local bDuration = self:GetSpecialValueFor("duration")
 	caster:Purge( false, true, false, true, true )
	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_juggernaut_blade_fury_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_silenced_jug", -- modifier name
		{ duration = bDuration } -- kv
	)
 
	end
end

 