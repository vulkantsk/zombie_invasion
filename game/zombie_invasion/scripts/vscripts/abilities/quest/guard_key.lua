
LinkLuaModifier( "modifier_guard_key", "abilities/quest/guard_key", LUA_MODIFIER_MOTION_NONE )

guard_key = class ({})

function guard_key:GetIntrinsicModifierName()
	return "modifier_guard_key"
end


modifier_guard_key = class({})

 
function modifier_guard_key:RemoveOnDeath()
    return true
end

function modifier_guard_key:IsHidden()
    return true
end

function modifier_guard_key:OnCreated()
 
end
 
function modifier_guard_key:OnIntervalThink()
 
end
 
 