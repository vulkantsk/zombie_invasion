LinkLuaModifier("modifier_sumon_boss_fight","modifiers/halloween/sumon_boss_fight.lua", LUA_MODIFIER_MOTION_NONE)
function StartModif( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_sumon_boss_fight", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_sumon_boss_fight")
end

-----------------------------------------------------------------------------------------

modifier_sumon_boss_fight = modifier_sumon_boss_fight or class({})

function modifier_sumon_boss_fight:IsHidden()
    return true
end

function modifier_sumon_boss_fight:IsPassive()
    return false
end

function modifier_sumon_boss_fight:IsPurgable()
    return false
end


function modifier_sumon_boss_fight:RemoveOnDeath()  return true end
 

 