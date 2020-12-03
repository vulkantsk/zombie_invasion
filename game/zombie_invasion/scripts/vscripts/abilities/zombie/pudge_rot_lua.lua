pudge_rot_tomb_1 = class({})
pudge_rot_tomb_2 = class({})
pudge_rot_tomb_3 = class({})
pudge_rot_tomb_4 = class({})

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
