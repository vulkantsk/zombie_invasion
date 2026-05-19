pudge_rot_tomb_1 = class({})

function pudge_rot_tomb_1:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

pudge_rot_tomb_2 = class({})

function pudge_rot_tomb_2:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

pudge_rot_tomb_3 = class({})

function pudge_rot_tomb_3:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

pudge_rot_tomb_4 = class({})

function pudge_rot_tomb_4:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

pudge_rot_tomb_clock = class({})

function pudge_rot_tomb_clock:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

LinkLuaModifier( "modifier_pudge_rot_lua", "modifiers/modifier_pudge_rot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_rot_lua_debuff", "modifiers/modifier_pudge_rot_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

 
--------------------------------------------------------------------------------
function pudge_rot_tomb_1:GetIntrinsicModifierName()
	return "modifier_pudge_rot_lua"
end


--------------------------------------------------------------------------------
function pudge_rot_tomb_2:GetIntrinsicModifierName()
	return "modifier_pudge_rot_lua"
end


--------------------------------------------------------------------------------

function pudge_rot_tomb_3:GetIntrinsicModifierName()
	return "modifier_pudge_rot_lua"
end


--------------------------------------------------------------------------------

function pudge_rot_tomb_4:GetIntrinsicModifierName()
	return "modifier_pudge_rot_lua"
end


--------------------------------------------------------------------------------

function pudge_rot_tomb_clock:GetIntrinsicModifierName()
	return "modifier_pudge_rot_lua"
end


--------------------------------------------------------------------------------
