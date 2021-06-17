dragon_fire_ball_lua = class({})
LinkLuaModifier( "modifier_dragon_fire_ball_lua_thinker", "heroes/hero_dragon/dragon_fire_ball/modifier_dragon_fire_ball_lua_thinker", LUA_MODIFIER_MOTION_NONE )

function dragon_fire_ball_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function dragon_fire_ball_lua:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_dragon_fire_ball_lua_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end