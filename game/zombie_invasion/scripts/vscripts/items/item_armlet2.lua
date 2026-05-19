LinkLuaModifier( "modifier_item_armlet2", "items/item_armlet2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_armlet2_buff", "items/item_armlet2", LUA_MODIFIER_MOTION_NONE )

item_armlet2 = class({})

function item_armlet2:GetIntrinsicModifierName()
    return "modifier_item_armlet2"
end

function item_armlet2:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_item_armlet2_buff") then
        return "armlet2"
    else
        return "armlet2_off"
    end
end

function item_armlet2:OnToggle()
    local caster = self:GetCaster()
    local toggle = self:GetToggleState()

    if not IsServer() then return end

    if toggle then
        self:EndCooldown()
        self.modifier = caster:AddNewModifier( caster, self, "modifier_item_armlet2_buff", {} )
    else
        local mod = self:GetCaster():FindModifierByName("modifier_item_armlet2_buff")
        if mod then
            mod:Destroy()
            self:UseResources(false, false, false, true)
        end
    end
end

modifier_item_armlet2 = class({})

function modifier_item_armlet2:IsHidden() return true end

function modifier_item_armlet2:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_armlet2:IsPurgable()
    return false
end

function modifier_item_armlet2:OnDestroy()
    if not IsServer() then return end
    local mod = self:GetParent():FindModifierByName("modifier_item_armlet2_buff")
    if mod then
        mod:Destroy()
    end
end

function modifier_item_armlet2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_item_armlet2:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_armlet2:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_armlet2:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_armlet2:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_item_armlet2:OnTakeDamage(params)
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then return end
    if self:GetParent() == params.unit then return end
    if params.unit:IsBuilding() then return end
    if params.unit:IsWard() then return end
    if params.inflictor == nil and not self:GetParent():IsIllusion() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then 
        local heal = self:GetAbility():GetSpecialValueFor("lifesteal") / 100 * params.damage
        self:GetParent():Heal(heal, self:GetAbility())

        local particle = "particles/generic_gameplay/generic_lifesteal.vpcf"

       

        local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, params.attacker )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end
end


modifier_item_armlet2_buff = class({})

function modifier_item_armlet2_buff:IsPurgable()
    return false
end

function modifier_item_armlet2_buff:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(0.1)
    self:OnIntervalThink()
end

function modifier_item_armlet2_buff:OnIntervalThink()
    if not IsServer() then return end
    self:GetParent():SetHealth(math.max( self:GetParent():GetHealth() - (100 * 0.25), 1))
end

function modifier_item_armlet2_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_item_armlet2_buff:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage_active") 
end

function modifier_item_armlet2_buff:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("movespeed_active")
end

function modifier_item_armlet2_buff:GetModifierPercentageCasttime()
    return self:GetAbility():GetSpecialValueFor("cast_point_active")
end

function modifier_item_armlet2_buff:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_str_active")
end

function modifier_item_armlet2_buff:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("armor_active")
end

function modifier_item_armlet2_buff:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed_active")
end

function modifier_item_armlet2_buff:OnTakeDamage(params)
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then return end
    if self:GetParent() == params.unit then return end
    if params.unit:IsBuilding() then return end
    if params.unit:IsWard() then return end

    if params.inflictor == nil then
        if not self:GetParent():IsIllusion() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
           
            local lifesteal = (self:GetAbility():GetSpecialValueFor("lifesteal_active")) / 100
            self:GetParent():Heal(params.damage * lifesteal, self:GetAbility())
            local particle = "particles/generic_gameplay/generic_lifesteal.vpcf"

           
            local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, params.attacker )
            
            ParticleManager:ReleaseParticleIndex( effect_cast )
        end
    else
        if not self:GetParent():IsIllusion() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
            local bonus_percentage = 0
            for _, mod in pairs(self:GetParent():FindAllModifiers()) do
                if mod.GetModifierSpellLifestealRegenAmplify_Percentage and mod:GetModifierSpellLifestealRegenAmplify_Percentage() then
                    bonus_percentage = bonus_percentage + mod:GetModifierSpellLifestealRegenAmplify_Percentage()
                end
            end
    
            local lifesteal = (self:GetAbility():GetSpecialValueFor("magic_lifesteal_active")) / 100
            local heal = params.damage * lifesteal
            heal = heal * (bonus_percentage / 100 + 1)
            self:GetParent():Heal(heal, self:GetAbility())
            local octarine = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
            ParticleManager:ReleaseParticleIndex( octarine )
        end
    end
end


function modifier_item_armlet2_buff:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf" 
end

function modifier_item_armlet2_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW 
end
