 LinkLuaModifier("modifier_lava_damage","metel.lua", LUA_MODIFIER_MOTION_NONE)
function StartTouchDamage( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_lava_damage", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_lava_damage")
end

-----------------------------------------------------------------------------------------

modifier_lava_damage = modifier_lava_damage or class({})

function modifier_lava_damage:IsHidden()
    return false
end

function modifier_lava_damage:IsPassive()
    return false
end

function modifier_lava_damage:IsPurgable()
    return false
end

function modifier_lava_damage:OnCreated()
    if not IsServer() then return end
 
end

function modifier_lava_damage:DeclareFunctions()
	local funcs = {
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

 

function modifier_lava_damage:GetModifierMoveSpeedBonus_Percentage()
 return  -50
end