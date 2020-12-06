LinkLuaModifier("modifier_pa_skill", "heroes/hero_phantoma_assasin/pa_skill", LUA_MODIFIER_MOTION_NONE)

pa_skill = class ({})

function pa_skill:GetIntrinsicModifierName()
    return "modifier_pa_skill"
end

-------------------------------------------------

modifier_pa_skill = class({})

function modifier_pa_skill:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

    }
    return funcs
end

function modifier_pa_skill:IsHidden()
    return true
end

function modifier_pa_skill:IsPurgable()
    return false
end

function modifier_pa_skill:RemoveOnDeath()
    return false
end

function modifier_pa_skill:OnCreated( kv )
    self:StartIntervalThink(0.2)
end

function modifier_pa_skill:OnIntervalThink()
    self.miss = self:GetAbility():GetSpecialValueFor("miss")
    self.ms = self:GetAbility():GetSpecialValueFor("ms")
end

function modifier_pa_skill:GetModifierEvasion_Constant()
    return self.miss
end

function modifier_pa_skill:GetModifierMoveSpeedBonus_Percentage()
    return self.ms
end
function modifier_pa_skill:CheckState()
    local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
    return state
end


