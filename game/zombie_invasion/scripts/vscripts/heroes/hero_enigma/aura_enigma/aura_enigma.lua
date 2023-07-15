LinkLuaModifier( "modifier_ability_enigma_aura", "heroes/hero_enigma/aura_enigma/aura_enigma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_enigma_aura_buff", "heroes/hero_enigma/aura_enigma/aura_enigma", LUA_MODIFIER_MOTION_NONE )

if ability_enigma_aura == nil then
    ability_enigma_aura = class({})
end

function ability_enigma_aura:GetIntrinsicModifierName()
    return "modifier_ability_enigma_aura"
end

modifier_ability_enigma_aura = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_ability_enigma_aura:IsAura()
    return true
end

function modifier_ability_enigma_aura:GetModifierAura()
    return "modifier_ability_enigma_aura_buff"
end

function modifier_ability_enigma_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_ability_enigma_aura:GetAuraDuration()
    return 0.5
end

function modifier_ability_enigma_aura:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ability_enigma_aura:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_ability_enigma_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end


modifier_ability_enigma_aura_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
            MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        }
    end,
})

function modifier_ability_enigma_aura_buff:GetModifierAttackRangeBonus()
        return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_ability_enigma_aura_buff:GetModifierBonusStats_Strength()
        return self:GetAbility():GetSpecialValueFor("bonus_attributes")
end

function modifier_ability_enigma_aura_buff:GetModifierBonusStats_Agility()
        return self:GetAbility():GetSpecialValueFor("bonus_attributes")
end

function modifier_ability_enigma_aura_buff:GetModifierBonusStats_Intellect()
        return self:GetAbility():GetSpecialValueFor("bonus_attributes")
end

function modifier_ability_enigma_aura_buff:GetModifierProcAttack_BonusDamage_Pure()
        return ((self:GetAbility():GetSpecialValueFor("Pure_reflex") * (100 / 100 * 4)) + (self:GetCaster():GetIntellect() / 100 * 10))
end
