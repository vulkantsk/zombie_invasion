ghost_elusive_1 = class({})
ghost_elusive_2 = class({})
ghost_elusive_3 = class({})

LinkLuaModifier( "modifier_ghost_elusive", "abilities/zombie/modifier_ghost_elusive", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function ghost_elusive_1:GetIntrinsicModifierName()
	return "modifier_ghost_elusive"
end

function ghost_elusive_2:GetIntrinsicModifierName()
	return "modifier_ghost_elusive"
end

function ghost_elusive_3:GetIntrinsicModifierName()
	return "modifier_ghost_elusive"
end


 