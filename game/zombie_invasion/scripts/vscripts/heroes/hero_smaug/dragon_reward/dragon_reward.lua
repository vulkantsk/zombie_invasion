dragon_reward = class({})

function dragon_reward:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/legion/legion_fallen/legion_fallen_press_buff.vpcf",
	}, {
	}, context)
end

LinkLuaModifier( "modifier_dragon_reward", "heroes/hero_smaug/dragon_reward/dragon_reward", LUA_MODIFIER_MOTION_NONE )
function dragon_reward:GetIntrinsicModifierName()
    return "modifier_dragon_reward"
end

modifier_dragon_reward = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

        } end,
})
function modifier_dragon_reward:OnCreated( kv )
    self.max = self:GetAbility():GetSpecialValueFor("max")
    self.bonus_attributes = self:GetAbility():GetSpecialValueFor("bonus_attributes")

    if IsServer() then
        self:SetStackCount(0)
    end
end
function modifier_dragon_reward:OnRefresh( kv )
    self.max = self:GetAbility():GetSpecialValueFor("max")
    self.bonus_attributes = self:GetAbility():GetSpecialValueFor("bonus_attributes")
end
function modifier_dragon_reward:OnDeath( params )
    if IsServer() then
        self:DeathLogic( params )
        self:KillLogic( params )
    end
end
function modifier_dragon_reward:GetModifierBonusStats_Strength()
    return self:GetStackCount() * self.bonus_attributes
end
function modifier_dragon_reward:GetModifierBonusStats_Agility()
    return self:GetStackCount() * self.bonus_attributes
end
function modifier_dragon_reward:GetModifierBonusStats_Intellect()
    return self:GetStackCount() * self.bonus_attributes
end
function modifier_dragon_reward:DeathLogic( params )
    local unit = params.unit
    if unit==self:GetParent() and params.reincarnate==false then
        local after_death = math.floor(self:GetStackCount())
    end
end
function modifier_dragon_reward:KillLogic( params )
    local target = params.unit
    local attacker = params.attacker
    if attacker == self:GetParent()   and target and attacker:IsAlive() then   
        if target:IsIllusion() and target:IsBuilding() then return  end
    if not self:GetParent():PassivesDisabled() then
        self:AddStack( 1 )
        self:PlayEffects( target )
    end
    end
end
function modifier_dragon_reward:AddStack( value )
    local current = self:GetStackCount()
    local after = current + value
    if after > self.max then
        after = self.max
    end
    self:SetStackCount( after )
end
function modifier_dragon_reward:PlayEffects( target )
    local projectile_name
         projectile_name = "particles/econ/items/legion/legion_fallen/legion_fallen_press_buff.vpcf"
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