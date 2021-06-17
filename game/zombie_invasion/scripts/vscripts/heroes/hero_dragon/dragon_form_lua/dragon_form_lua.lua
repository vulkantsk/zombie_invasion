dragon_form_lua = class({})
LinkLuaModifier( "modifier_dragon_form_lua", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_form_lua_corrosive", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua_corrosive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_form_lua_frost", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua_frost", LUA_MODIFIER_MOTION_NONE )


function dragon_form_lua:OnSpellStart()

	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dragon_form_lua", -- modifier name
		{ duration = duration } -- kv
	)
end