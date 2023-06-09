LinkLuaModifier( "modifier_demon_aura", "heroes/hero_demonslayer/demon_aura/demon_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_aura_debuff", "heroes/hero_demonslayer/demon_aura/demon_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_aura_stack", "heroes/hero_demonslayer/demon_aura/demon_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_aura_permanent_stack", "heroes/hero_demonslayer/demon_aura/demon_aura", LUA_MODIFIER_MOTION_NONE )


demon_aura = {}

function demon_aura:GetIntrinsicModifierName()
    return "modifier_demon_aura"
end

modifier_demon_aura_stack = class({})

function modifier_demon_aura_stack:IsHidden()
    return true
end

function modifier_demon_aura_stack:IsDebuff()
    return false
end

function modifier_demon_aura_stack:IsPurgable()
    return false
end

function modifier_demon_aura_stack:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_demon_aura_stack:RemoveOnDeath()
    return false
end

function modifier_demon_aura_stack:OnDestroy()
    if not IsServer() then return end
    self.parent:RemoveStack( self.bonus )
end

modifier_demon_aura_permanent_stack = {}

function modifier_demon_aura_permanent_stack:IsHidden()
    return false
end

function modifier_demon_aura_permanent_stack:IsDebuff()
    return false
end

function modifier_demon_aura_permanent_stack:IsPurgable()
    return false
end

function modifier_demon_aura_permanent_stack:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_demon_aura_permanent_stack:RemoveOnDeath()
    return false
end

function modifier_demon_aura_permanent_stack:OnCreated( kv )
    if not IsServer() then return end
    self:SetStackCount( kv.bonus )
end

function modifier_demon_aura_permanent_stack:OnRefresh( kv )
    if not IsServer() then return end
    self:SetStackCount( self:GetStackCount() + kv.bonus )
end

function modifier_demon_aura_permanent_stack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_demon_aura_permanent_stack:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

modifier_demon_aura_debuff = {}

function modifier_demon_aura_debuff:IsHidden()
    return false
end

function modifier_demon_aura_debuff:IsDebuff()
    return true
end

function modifier_demon_aura_debuff:IsStunDebuff()
    return false
end

function modifier_demon_aura_debuff:IsPurgable()
    return true
end

function modifier_demon_aura_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_demon_aura_debuff:OnCreated( kv )
    self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_pct" )
end

function modifier_demon_aura_debuff:OnRefresh( kv )
    self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_pct" ) 
end

function modifier_demon_aura_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_demon_aura_debuff:GetModifierBaseDamageOutgoing_Percentage( params )
    return -self.reduction
end

modifier_demon_aura = {}

function modifier_demon_aura:IsHidden()
    return self:GetStackCount()==0
end

function modifier_demon_aura:IsDebuff()
    return false
end

function modifier_demon_aura:IsStunDebuff()
    return false
end

function modifier_demon_aura:IsPurgable()
    return false
end

function modifier_demon_aura:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_demon_aura:RemoveOnDeath()
    return false
end

function modifier_demon_aura:DestroyOnExpire()
    return false
end

function modifier_demon_aura:OnCreated( kv )
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.hero_bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage_from_hero" )
    self.creep_bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage_from_creep" )
    self.bonus = self:GetAbility():GetSpecialValueFor( "permanent_bonus" )
    self.duration = self:GetAbility():GetSpecialValueFor( "bonus_damage_duration" )
    self.duration_scepter = self:GetAbility():GetSpecialValueFor( "bonus_damage_duration_scepter" )

    if not IsServer() then return end

    self.scepter_aura = self:GetParent():AddNewModifier(
        self:GetParent(),
        self:GetAbility(),
        "modifier_demon_aura_scepter",
        {}
    )
end

function modifier_demon_aura:OnRefresh( kv )
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.hero_bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage_from_hero" )
    self.creep_bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage_from_creep" )
    self.bonus = self:GetAbility():GetSpecialValueFor( "permanent_bonus" )
    self.duration = self:GetAbility():GetSpecialValueFor( "bonus_damage_duration" )
    self.duration_scepter = self:GetAbility():GetSpecialValueFor( "bonus_damage_duration_scepter" )

    if not IsServer() then return end

    self.scepter_aura:ForceRefresh()
end

function modifier_demon_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_demon_aura:OnDeath( params )
    if not IsServer() then return end
    local parent = self:GetParent()

    if parent:PassivesDisabled() then return end

    if params.unit:IsIllusion() then return end

    if not params.unit:FindModifierByNameAndCaster( "modifier_demon_aura_debuff", parent ) then return end

    local hero = params.unit:IsHero()
    local bonus
    if hero then
        bonus = self.hero_bonus
    else
        bonus = self.creep_bonus
    end

    local duration
    if parent:HasScepter() then
        duration = self.duration_scepter
    else
        duration = self.duration
    end

    self:SetStackCount( self:GetStackCount() + bonus )

    local modifier = parent:AddNewModifier(
        parent,
        self:GetAbility(),
        "modifier_demon_aura_stack",
        { duration = duration }
    )
    modifier.parent = self
    modifier.bonus = bonus

    self:SetDuration( self.duration, true )

    if hero then
        parent:AddNewModifier(
            parent,
            self:GetAbility(),
            "modifier_demon_aura_permanent_stack",
            { bonus = self.bonus }
        )
    end
end

function modifier_demon_aura:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

function modifier_demon_aura:RemoveStack( value )
    self:SetStackCount( self:GetStackCount() - value )
end

function modifier_demon_aura:IsAura()
    return (not self:GetCaster():PassivesDisabled())
end

function modifier_demon_aura:GetModifierAura()
    return "modifier_demon_aura_debuff"
end

function modifier_demon_aura:GetAuraRadius()
    return self.radius
end

function modifier_demon_aura:GetAuraDuration()
    return 0.5
end

function modifier_demon_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_demon_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_demon_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_demon_aura:IsAuraActiveOnDeath()
    return false
end

function modifier_demon_aura:GetAuraEntityReject( hEntity )
    if IsServer() then
        if hEntity==self:GetCaster() then return true end
    end

    return false
end