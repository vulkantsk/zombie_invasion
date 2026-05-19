wraith_king_mortal_strike_lua = class({})

function wraith_king_mortal_strike_lua:Precache(context)
	PrecacheAbilityResources({
	}, {
		"Hero_SkeletonKing.CriticalStrike",
	}, context)
end

LinkLuaModifier( "modifier_wraith_king_mortal_strike_lua", "heroes/hero_skeleton_king/mortal_strike/modifier_wraith_king_mortal_strike_lua", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function wraith_king_mortal_strike_lua:GetIntrinsicModifierName()
	return "modifier_wraith_king_mortal_strike_lua"
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function wraith_king_mortal_strike_lua:OnAbilityPhaseStart()
	return true -- if success
end

 