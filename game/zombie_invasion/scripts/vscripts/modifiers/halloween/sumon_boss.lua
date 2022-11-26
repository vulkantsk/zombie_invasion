LinkLuaModifier("modifier_sumon","modifiers/halloween/sumon_boss.lua", LUA_MODIFIER_MOTION_NONE)
function StartModif( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_sumon", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_sumon")
end

-----------------------------------------------------------------------------------------

modifier_sumon = modifier_sumon or class({})

function modifier_sumon:IsHidden()
    return true
end

function modifier_sumon:IsPassive()
    return false
end

function modifier_sumon:IsPurgable()
    return false
end


function modifier_sumon:RemoveOnDeath()  return true end
 

 