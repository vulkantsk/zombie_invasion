LinkLuaModifier( "modifier_blackshop_cursed_tonic_booster", "items/blackshop_items/blackshop_cursed/blackshop_cursed_tonic_booster", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blackshop_cursed_tonic_booster_debuff", "items/blackshop_items/blackshop_cursed/blackshop_cursed_tonic_booster", LUA_MODIFIER_MOTION_NONE )

item_blackshop_cursed_tonic_booster = class({})

function item_blackshop_cursed_tonic_booster:OnSpellStart()
    self.caster = self:GetCaster()
    self.caster:AddNewModifier(self.caster, self, "modifier_blackshop_cursed_tonic_booster", {duration = self:GetSpecialValueFor("duration")})
end

modifier_blackshop_cursed_tonic_booster = class({})

function modifier_blackshop_cursed_tonic_booster:IsHidden()
    return false
end

function modifier_blackshop_cursed_tonic_booster:IsDebuff()
    return false
end

function modifier_blackshop_cursed_tonic_booster:IsPurgable()
    return false
end

function modifier_blackshop_cursed_tonic_booster:RemoveOnDeath()
    return true
end

function modifier_blackshop_cursed_tonic_booster:OnDestroy()
    self.caster = self:GetCaster()
        if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
            local m = self.caster:FindModifierByName("modifier_blackshop_cursed_tonic_booster_debuff")
            if m then
                m:SetStackCount(m:GetStackCount() + 1)
            else
                self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_cursed_tonic_booster_debuff", {}):SetStackCount(1)
            end
        end
end

function modifier_blackshop_cursed_tonic_booster:GetEffectName()
    return "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf"
end

function modifier_blackshop_cursed_tonic_booster:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end

function modifier_blackshop_cursed_tonic_booster:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_blackshop_cursed_tonic_booster:GetModifierDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_blackshop_cursed_tonic_booster:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end

function modifier_blackshop_cursed_tonic_booster:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_blackshop_cursed_tonic_booster:GetModifierProjectileSpeedBonus()
    if self:GetParent():IsRangedAttacker() then
        return self:GetAbility():GetSpecialValueFor("bonus_projectile_speed")
    end
end

function modifier_blackshop_cursed_tonic_booster:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_blackshop_cursed_tonic_booster:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end


modifier_blackshop_cursed_tonic_booster_debuff = class({})

function modifier_blackshop_cursed_tonic_booster_debuff:IsHidden()
    return false
end

function modifier_blackshop_cursed_tonic_booster_debuff:IsDebuff() 
    return true
end

function modifier_blackshop_cursed_tonic_booster_debuff:IsPurgable()
    return false
end

function modifier_blackshop_cursed_tonic_booster_debuff:IsPurgeException()
    return false
end

function modifier_blackshop_cursed_tonic_booster_debuff:IsStunDebuff()
    return false
end

function modifier_blackshop_cursed_tonic_booster_debuff:RemoveOnDeath()
    return false
end

function modifier_blackshop_cursed_tonic_booster_debuff:DestroyOnExpire()
    return false
end

function modifier_blackshop_cursed_tonic_booster_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_blackshop_cursed_tonic_booster_debuff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():HasModifier("modifier_blackshop_cursed_tonic_booster") then
        return 0
    end
    return self:GetAbility():GetSpecialValueFor("debuff_movespeed") * self:GetStackCount()
end

function modifier_blackshop_cursed_tonic_booster_debuff:GetModifierDamageOutgoing_Percentage()
    if self:GetParent():HasModifier("modifier_blackshop_cursed_tonic_booster") then
        return 0
    end
    return self:GetAbility():GetSpecialValueFor("debuff_damage") * self:GetStackCount()
end

function modifier_blackshop_cursed_tonic_booster_debuff:GetModifierSpellAmplify_Percentage()
    if self:GetParent():HasModifier("modifier_blackshop_cursed_tonic_booster") then
        return 0
    end
    return self:GetAbility():GetSpecialValueFor("debuff_spell_amp") * self:GetStackCount()
end

function modifier_blackshop_cursed_tonic_booster_debuff:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent():HasModifier("modifier_blackshop_cursed_tonic_booster") then
        return 0
    end
    return self:GetAbility():GetSpecialValueFor("debuff_attack_speed") * self:GetStackCount()
end

function modifier_blackshop_cursed_tonic_booster_debuff:GetModifierProjectileSpeedBonus()
    if self:GetParent():IsRangedAttacker() then
        if self:GetParent():HasModifier("modifier_blackshop_cursed_tonic_booster") then
            return 0
        end
        return self:GetAbility():GetSpecialValueFor("debuff_projectile_speed") * self:GetStackCount()
    end
end

function modifier_blackshop_cursed_tonic_booster_debuff:GetModifierBonusStats_Strength()
    if self:GetParent():HasModifier("modifier_blackshop_cursed_tonic_booster") then
        return 0
    end
    return self:GetAbility():GetSpecialValueFor("debuff_strength") * self:GetStackCount()
end

