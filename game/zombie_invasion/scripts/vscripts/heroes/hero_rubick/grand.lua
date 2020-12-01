LinkLuaModifier("modifier_grand", "heroes/hero_rubick/grand", LUA_MODIFIER_MOTION_NONE)

grand = class({})

function grand:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function grand:GetIntrinsicModifierName()
    return "modifier_grand"
end

-------------------------------------------------

modifier_grand = class({})

function modifier_grand:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,

    }
    return funcs
end

function modifier_grand:IsHidden()
    return true
end

function modifier_grand:IsPurgable()
    return false
end

function modifier_grand:RemoveOnDeath()
    return false
end

function modifier_grand:OnCreated( kv )
    self:StartIntervalThink(0.2)
end

function modifier_grand:OnIntervalThink()
    self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
    self.mana = self:GetAbility():GetSpecialValueFor("spell")
end

function modifier_grand:GetModifierPercentageCooldown()
    return self.cooldown
end

function modifier_grand:GetModifierPercentageManacost()
    return self.mana
end