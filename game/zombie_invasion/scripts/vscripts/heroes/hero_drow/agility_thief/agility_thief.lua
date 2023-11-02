agility_thief = class({})
LinkLuaModifier("modifier_agility_thief", "heroes/hero_drow/agility_thief/agility_thief", LUA_MODIFIER_MOTION_NONE)
function agility_thief:GetIntrinsicModifierName()
    return "modifier_agility_thief"
end
modifier_agility_thief = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        } end,
})
function modifier_agility_thief:OnCreated( kv )
    self.bonus_attributes = self:GetAbility():GetSpecialValueFor("bonus_attributes")

    if IsServer() then
        self:SetStackCount(0)
    end
end
function modifier_agility_thief:OnRefresh( kv )
    self.bonus_attributes = self:GetAbility():GetSpecialValueFor("bonus_attributes")
end
function modifier_agility_thief:OnDeath( params )
    if IsServer() then
        self:DeathLogic( params )
        self:KillLogic( params )
    end
end
function modifier_agility_thief:GetModifierBonusStats_Agility()
    return self:GetStackCount() * self.bonus_attributes
end
function modifier_agility_thief:DeathLogic( params )
    local unit = params.unit
    if unit==self:GetParent() and params.reincarnate==false then
        local after_death = math.floor(self:GetStackCount())
    end
end
function modifier_agility_thief:KillLogic( params )
    local chance = self:GetAbility():GetSpecialValueFor("chance_to_stack")
    local target = params.unit
    local attacker = params.attacker
    if attacker == self:GetParent()   and target and attacker:IsAlive() then   
        if target:IsIllusion() and target:IsBuilding() then return  end
            if killer == parent and RollPercentage(chance) then
                 if not self:GetParent():PassivesDisabled() then
                    self:AddStack( 1 )
                     self:PlayEffects( target )
                end
            end
    end
end
function modifier_agility_thief:AddStack( value )
    local current = self:GetStackCount()
    local after = current + value
    self:SetStackCount( after )
end
function modifier_agility_thief:PlayEffects( target )
    local projectile_name
         projectile_name = "particles/econ/items/drow/drow_arcana/drow_ranger_arcana_revenge_kill_effect_caster_beam.vpcf"
    local info = {
        Target = self:GetParent(),
        Source = target,
        EffectName = projectile_name,
        iMoveSpeed = 400,
        vSourceLoc= target:GetAbsOrigin(),                -- Optional
        bDodgeable = false,                                -- Optional
        bReplaceExisting = false,                         -- Optional
        flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
        bProvidesVision = false,                           -- Optional
    }
    ProjectileManager:CreateTrackingProjectile(info)
end