LinkLuaModifier("modifier_item_bad_glasses", "items/carry/item_bad_glasses", LUA_MODIFIER_MOTION_NONE)

item_bad_glasses = class({})

function item_bad_glasses:GetIntrinsicModifierName()
    return "modifier_item_bad_glasses"
end

modifier_item_bad_glasses = class({
    IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }end,
})

function modifier_item_bad_glasses:OnCreated()
    self.bonus_damage_percent = self:GetAbility():GetSpecialValueFor("bonus_damage_percent")
    self.health_debuff = self:GetAbility():GetSpecialValueFor("health_debuff") 
    self.spell_amplify_bonus = self:GetAbility():GetSpecialValueFor("spell_amplify_bonus")
end

function modifier_item_bad_glasses:GetModifierProjectileName()
    return "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_ti9_summon_projectile_lava.vpcf"
end

function modifier_item_bad_glasses:GetModifierDamageOutgoing_Percentage()
    return self.bonus_damage_percent
end

function modifier_item_bad_glasses:GetModifierExtraHealthPercentage()
    return self.health_debuff
end

function modifier_item_bad_glasses:GetModifierSpellAmplify_Percentage()
    return self.spell_amplify_bonus
end