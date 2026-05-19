juggernaut_blade_dance_lua = class({})

function juggernaut_blade_dance_lua:Precache(context)
	PrecacheAbilityResources({
	}, {
		"Hero_Juggernaut.BladeDance",
	}, context)
end

LinkLuaModifier( "modifier_juggernaut_blade_dance_lua", "heroes/hero_samurai/spells/modifier_juggernaut_blade_dance_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function juggernaut_blade_dance_lua:GetIntrinsicModifierName()
	return "modifier_juggernaut_blade_dance_lua"
end