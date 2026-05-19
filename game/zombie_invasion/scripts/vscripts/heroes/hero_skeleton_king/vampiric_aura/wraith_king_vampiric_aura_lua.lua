wraith_king_vampiric_aura_lua = class({})

function wraith_king_vampiric_aura_lua:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf",
	}, {
	}, context)
end

LinkLuaModifier( "modifier_wraith_king_vampiric_aura_lua", "heroes/hero_skeleton_king/vampiric_aura/modifier_wraith_king_vampiric_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wraith_king_vampiric_aura_lua_lifesteal", "heroes/hero_skeleton_king/vampiric_aura/modifier_wraith_king_vampiric_aura_lua_lifesteal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function wraith_king_vampiric_aura_lua:GetIntrinsicModifierName()
	return "modifier_wraith_king_vampiric_aura_lua"
end

function wraith_king_vampiric_aura_lua:ProcsMagicStick()
	return false
end

function wraith_king_vampiric_aura_lua:OnToggle()
end