LinkLuaModifier( "modifier_bristleback", "items/book_of_heroes/heroes/item_npc_dota_hero_bristleback", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_bristleback", LUA_MODIFIER_MOTION_NONE )

item_npc_dota_hero_bristleback = class({})

function item_npc_dota_hero_bristleback:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("bristleback_buff_1") then 
          caster:AddAbility("bristleback_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



bristleback_buff_1 = class({})

function bristleback_buff_1:GetIntrinsicModifierName()
    return "modifier_bristleback"
end

modifier_bristleback = class({
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

    } end
})



function modifier_bristleback:OnCreated()
    self.return_damage = self:GetAbility():GetSpecialValueFor("return_damage")
    self.str_to_damage = self:GetAbility():GetSpecialValueFor("return_damage_str")
    self.modifier_self = "dragon_armor"
    self.modifier_unique = "dragon_armor_unique"

    -- Ability specials
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

function modifier_bristleback:OnRefresh()
    self:OnCreated()

end

function modifier_bristleback:GetTexture()
    return "dragon_armor"
end


function modifier_bristleback:OnAttackLanded(params)
 
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

        local particle = "particles/units/heroes/hero_centaur/centaur_return_buff_start_flame.vpcf"
        local fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, victim)
        ParticleManager:SetParticleControlEnt(fx, 0, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx)
    end
end

function modifier_bristleback:GetModifierExtraStrengthBonus()
    return self.bonus_strength 
end

function modifier_bristleback:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_bristleback:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor
end


function modifier_bristleback:OnDestroy()
    if IsServer() then
        -- if this is the last heart, remove the unique modifier
        if not self:GetCaster():HasModifier(self.modifier_self) then
            self:GetCaster():RemoveModifierByName(self.modifier_unique)
        end
    end
end

function modifier_bristleback:IsAura() return true end
function modifier_bristleback:GetAuraRadius() return self.aura_radius end
function modifier_bristleback:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_bristleback:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_bristleback:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_bristleback:GetModifierAura() return "modifier_bristleback_buff" end


function modifier_bristleback:GetModifierHealthRegenPercentage()


    return self.base_regen
end

function modifier_bristleback:GetIntrinsicModifierName()
    return "modifier_bristleback_buff"
end

modifier_bristleback_buff = modifier_bristleback_buff or class({})

function modifier_bristleback_buff:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf" 
end

function modifier_bristleback_buff:OnCreated()
    -- Ability specials 
    self.aura_str = self:GetAbility():GetSpecialValueFor("aura_str")    
end

function modifier_bristleback_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

    return decFuncs
end

function modifier_bristleback_buff:GetTexture()
    return ""
end


function modifier_bristleback_buff:IsHidden()
    return true
end


function modifier_bristleback_buff:GetModifierBonusStats_Strength()
    return self.aura_str
end