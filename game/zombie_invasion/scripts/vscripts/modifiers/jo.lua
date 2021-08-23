LinkLuaModifier("modifier_Jo_effect","modifiers/jo.lua", LUA_MODIFIER_MOTION_NONE)
function StartModif( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_Jo_effect", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_Jo_effect")
end

-----------------------------------------------------------------------------------------

modifier_Jo_effect = modifier_Jo_effect or class({})

function modifier_Jo_effect:IsHidden()
    return true
end

function modifier_Jo_effect:IsPassive()
    return false
end

function modifier_Jo_effect:IsPurgable()
    return false
end


function modifier_Jo_effect:RemoveOnDeath()  return true end
 

 