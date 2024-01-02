LinkLuaModifier( "modifier_item_last_standing_shield", "items/item_last_standing_shield", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_last_standing_shield_aura", "items/item_last_standing_shield", LUA_MODIFIER_MOTION_NONE )

item_last_standing_shield = class({})

function item_last_standing_shield:OnSpellStart()
    if not IsServer() then return end
    local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(),nil,self:GetSpecialValueFor("radius"),DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
    for _,target in pairs(targets) do
        target:AddNewModifier(self:GetCaster(), self, "modifier_item_last_standing_shield_aura", {duration = 16})
        self:GetCaster():EmitSound("Hero_LegionCommander.Overwhelming.Cast")
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_symbol.vpcf", PATTACH_ABSORIGIN, target )
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 4, Vector(100*1.5, 100*1.5, 100*1.5))
    end
end

function item_last_standing_shield:GetIntrinsicModifierName() 
    return "modifier_item_last_standing_shield"
end

modifier_item_last_standing_shield = class({})
function modifier_item_last_standing_shield:IsHidden() return true end
function modifier_item_last_standing_shield:IsPurgable() return false end
function modifier_item_last_standing_shield:IsPurgeException() return false end
function modifier_item_last_standing_shield:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_last_standing_shield:DeclareFunctions()
    return  
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL,
    }
end

function modifier_item_last_standing_shield:GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_last_standing_shield:GetModifierHealthBonus()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_last_standing_shield:GetModifierBonusStats_Strength()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_last_standing_shield:GetModifierBonusStats_Agility()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_last_standing_shield:GetModifierBonusStats_Intellect()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_last_standing_shield:GetModifierConstantHealthRegen()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_item_last_standing_shield:GetModifierConstantManaRegen()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_item_last_standing_shield:GetModifierPhysical_ConstantBlockSpecial()
    if not self:GetAbility() then return end
    if RollPercentage(self:GetAbility():GetSpecialValueFor("damage_block_chance")) then
        return self:GetAbility():GetSpecialValueFor("damage_block")
    end
end

modifier_item_last_standing_shield_aura = class({})

function modifier_item_last_standing_shield_aura:OnCreated()
    if not IsServer() then return end

    self.crimson_guard_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    if self:GetParent():ScriptLookupAttachment( "attach_hitloc" ) == 0 then
        ParticleManager:SetParticleControl(self.crimson_guard_pfx, 1, self:GetParent():GetAbsOrigin() + Vector(0,0,120))
    else
        ParticleManager:SetParticleControlEnt(self.crimson_guard_pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
    end

    self:AddParticle(self.crimson_guard_pfx, false, false, -1, false, false)
end

function modifier_item_last_standing_shield_aura:DeclareFunctions()
    return  
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL,
    }
end

function modifier_item_last_standing_shield_aura:GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_armor_active")
end

function modifier_item_last_standing_shield_aura:GetModifierAttackSpeedBonus_Constant()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_last_standing_shield_aura:GetModifierMoveSpeedBonus_Percentage()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_item_last_standing_shield_aura:GetModifierPhysical_ConstantBlockSpecial()
    if not self:GetAbility() then return end
    return self:GetAbility():GetSpecialValueFor("damage_block") + (self:GetCaster():GetStrength() * (self:GetAbility():GetSpecialValueFor("block_procentage_active") / 100))
end

function modifier_item_last_standing_shield_aura:GetTexture()
    return "items/last_standing_shield"
end