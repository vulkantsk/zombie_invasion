item_dragon_set = class({})

function item_dragon_set:GetIntrinsicModifierName()
    return "modifier_item_dragon_set_passive"
end

function item_dragon_set:OnSpellStart()
    local caster = self:GetCaster()

    
    caster:AddNewModifier(caster, self, "modifier_item_dragon_set_active", {duration = self:GetSpecialValueFor("duration")})
    
    EmitSoundOn("Hero_DragonKnight.DragonTail.Target", caster)
end

LinkLuaModifier("modifier_item_dragon_set_passive", "items/item_dragon_set.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dragon_set_active", "items/item_dragon_set.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dragon_set_armor_reduction", "items/item_dragon_set.lua", LUA_MODIFIER_MOTION_NONE)

modifier_item_dragon_set_passive = class({})

function modifier_item_dragon_set_passive:IsHidden() return false end
function modifier_item_dragon_set_passive:IsDebuff() return false end
function modifier_item_dragon_set_passive:IsPurgable() return false end
function modifier_item_dragon_set_passive:RemoveOnDeath() return false end

function modifier_item_dragon_set_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_item_dragon_set_passive:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_dragon_set_passive:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_dragon_set_passive:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_dragon_set_passive:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_dragon_set_passive:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect") 
end

function modifier_item_dragon_set_passive:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_dragon_set_passive:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_dragon_set_passive:OnTakeDamage(keys)
    if keys.unit == self:GetParent() then
        if keys.attacker:IsHero() or keys.attacker:IsCreep() then
            local return_damage = self:GetAbility():GetSpecialValueFor("return_damage")
            local return_damage_str = self:GetAbility():GetSpecialValueFor("return_damage_str")
            local str = self:GetParent():GetStrength()
            
            local damage = ((return_damage + (str * return_damage_str/100)) / 100) * keys.original_damage
            
            ApplyDamage({
                victim = keys.attacker,
                attacker = self:GetParent(),
                damage = damage,
                damage_type = DAMAGE_TYPE_PURE
            })
        end
    end
end

function modifier_item_dragon_set_passive:IsAura()
    return true
end

function modifier_item_dragon_set_passive:GetModifierAura()
    return "modifier_item_dragon_set_aura"
end

function modifier_item_dragon_set_passive:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_dragon_set_passive:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_dragon_set_passive:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

LinkLuaModifier("modifier_item_dragon_set_aura", "items/item_dragon_set.lua", LUA_MODIFIER_MOTION_NONE)

modifier_item_dragon_set_aura = class({})

function modifier_item_dragon_set_aura:IsHidden() return false end
function modifier_item_dragon_set_aura:IsDebuff() return false end
function modifier_item_dragon_set_aura:IsPurgable() return false end

function modifier_item_dragon_set_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
    return funcs
end

function modifier_item_dragon_set_aura:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage") * 0.5
end

function modifier_item_dragon_set_aura:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor") * 0.5
end

function modifier_item_dragon_set_aura:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health") * 0.5
end

function modifier_item_dragon_set_aura:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength") * 0.5
end

function modifier_item_dragon_set_aura:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("spell_amp") * 0.5
end

function modifier_item_dragon_set_aura:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility") * 0.5
end

function modifier_item_dragon_set_aura:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect") * 0.5
end

modifier_item_dragon_set_active = class({})

function modifier_item_dragon_set_active:IsHidden() return false end
function modifier_item_dragon_set_active:IsDebuff() return false end
function modifier_item_dragon_set_active:IsPurgable() return true end

function modifier_item_dragon_set_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_item_dragon_set_active:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_dragon_set_active:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_dragon_set_active:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_item_dragon_set_active:GetModifierPreAttack_CriticalStrike()
    if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
        return self:GetAbility():GetSpecialValueFor("crit_damage")
    end
    return nil
end

function modifier_item_dragon_set_active:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
        local target = params.target
        local modifier = target:FindModifierByName("modifier_item_dragon_set_armor_reduction")
        if not modifier then
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_dragon_set_armor_reduction", {duration = self:GetAbility():GetSpecialValueFor("armor_reduction_duration")}):SetStackCount(1)
        else
            modifier:SetStackCount(modifier:GetStackCount() + 1)
        end
    end
end

function modifier_item_dragon_set_active:GetEffectName()
    return "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
end

function modifier_item_dragon_set_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_item_dragon_set_armor_reduction = class({})

function modifier_item_dragon_set_armor_reduction:IsHidden() return false end
function modifier_item_dragon_set_armor_reduction:IsDebuff() return true end
function modifier_item_dragon_set_armor_reduction:IsPurgable() return true end

function modifier_item_dragon_set_armor_reduction:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_item_dragon_set_armor_reduction:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("armor_reduction_per_stack") * self:GetStackCount()
end

function modifier_item_dragon_set_armor_reduction:GetEffectName()
    return "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf"
end

function modifier_item_dragon_set_armor_reduction:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
