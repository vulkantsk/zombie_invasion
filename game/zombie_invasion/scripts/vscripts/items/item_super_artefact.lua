LinkLuaModifier("modifier_item_super_artefact_return", "items/item_super_artefact.lua", 0)
LinkLuaModifier("modifier_item_super_artefact_buff", "items/item_super_artefact", LUA_MODIFIER_MOTION_NONE)

item_super_artefact = class({
    GetIntrinsicModifierName = function() return "modifier_item_super_artefact_return" end
})


modifier_item_super_artefact_return = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    DeclareFunctions = function() return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        

    } end
})


function modifier_item_super_artefact_return:OnCreated()
    self.return_damage = self:GetAbility():GetSpecialValueFor("return_damage")
    self.str_to_damage = self:GetAbility():GetSpecialValueFor("return_damage_str")
    self.modifier_self = "super_artefact"
    self.modifier_unique = "super_artefact_unique"

    -- Ability specials
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_resistance = self:GetAbility():GetSpecialValueFor("bonus_resistance")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")  

    self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
    self.base_regen = self:GetAbility():GetSpecialValueFor("base_regen")
    self.noncombat_regen = self:GetAbility():GetSpecialValueFor("noncombat_regen")

    if IsServer() then
        -- If this is the first heart, add the unique modifier
        if not self:GetCaster():HasModifier(self.modifier_unique) then
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_unique, {})
        end
    end
end

function modifier_item_super_artefact_return:OnRefresh()
    self:OnCreated()

end

function modifier_item_super_artefact_return:GetTexture()
    return "item_super_artefact"
end


function modifier_item_super_artefact_return:OnAttackLanded(params)
 
    local victim = params.target
    if victim == self:GetParent() then
 
        local str_damage = self:GetParent():GetStrength() / 100 * self.str_to_damage
        local damage = self.return_damage + str_damage
        ApplyDamage({
            victim = params.attacker,
            attacker = victim,
            ability = self:GetAbility(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
        })

        local particle = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
        local fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, victim)
        ParticleManager:SetParticleControlEnt(fx, 0, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx)
    end
end

function modifier_item_super_artefact_return:GetModifierExtraStrengthBonus()
    return self.bonus_strength 
end

function modifier_item_super_artefact_return:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_super_artefact_return:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor
end


function modifier_item_super_artefact_return:OnDestroy()
    if IsServer() then
        -- if this is the last heart, remove the unique modifier
        if not self:GetCaster():HasModifier(self.modifier_self) then
            self:GetCaster():RemoveModifierByName(self.modifier_unique)
        end
    end
end

function modifier_item_super_artefact_return:IsAura() return true end
function modifier_item_super_artefact_return:GetAuraRadius() return self.aura_radius end
function modifier_item_super_artefact_return:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_super_artefact_return:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_super_artefact_return:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_item_super_artefact_return:GetModifierAura() return "modifier_item_super_artefact_buff" end


function modifier_item_super_artefact_return:GetModifierHealthRegenPercentage()


    return self.base_regen
end

function modifier_item_super_artefact_return:GetIntrinsicModifierName()
    return "modifier_item_super_artefact_buff"
end

modifier_item_super_artefact_buff = modifier_item_super_artefact_buff or class({})

function modifier_item_super_artefact_buff:GetEffectName()
    return "particles/items_fx/armlet_b.vpcf" 
end

function modifier_item_super_artefact_buff:OnCreated()
    -- Ability specials 
    self.aura_str = self:GetAbility():GetSpecialValueFor("aura_str")    
end

function modifier_item_super_artefact_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

    return decFuncs
end

function modifier_item_super_artefact_buff:GetTexture()
    return "item_super_artefact"
end


function modifier_item_super_artefact_buff:IsHidden()
    return true
end


function modifier_item_super_artefact_buff:GetModifierBonusStats_Strength()
    return self.aura_str
end

function modifier_item_super_artefact_buff:GetModifierBonusStats_Agility()
    return self.bonus_agility 
end

function modifier_item_super_artefact_buff:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

function modifier_item_super_artefact_buff:GetModifierMagicalResistanceBonus()
    return self.bonus_resistance 
end

function modifier_item_super_artefact_buff:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end