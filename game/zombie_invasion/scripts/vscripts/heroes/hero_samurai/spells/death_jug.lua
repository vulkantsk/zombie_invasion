LinkLuaModifier("modifier_phantom_assassin_death_rush", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_passive", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_jug_death", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_cooldown", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_jug_death_after", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_buff", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
jugger_dead = class({})

function jugger_dead:GetIntrinsicModifierName()
    return "modifier_phantom_assassin_death_rush_buff"
end

function jugger_dead:OnSpellStart()

    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_phantom_assassin_death_rush", {duration = 30})
            EmitSoundOn("gate_dead_theme",  self:GetCaster())
     
    self:PlayEffects()
end

function jugger_dead:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/heroes/death/gate_death.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        "attach_mouth",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end

 

modifier_phantom_assassin_death_rush_passive = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MIN_HEALTH,
            MODIFIER_EVENT_ON_TAKEDAMAGE
        } end,

})
 
 

modifier_phantom_assassin_death_rush = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_MODEL_CHANGE,
            MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
            MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
            MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
            MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
            MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
            MODIFIER_PROPERTY_MIN_HEALTH,
        } end,
    })
function  modifier_phantom_assassin_death_rush:OnCreated()
    self:StartIntervalThink( 0.2 )
  
end
 
function  modifier_phantom_assassin_death_rush:OnIntervalThink()
        if IsServer() then
            self:GetParent():SetHealth(math.max( self:GetParent():GetHealth() - (100 * 8.25), 1))
        end
end

function modifier_phantom_assassin_death_rush:GetModifierModelChange()
    return "models/items/warlock/golem/puppet_summoner_golem/puppet_summoner_golem.vmdl"
end

 

function modifier_phantom_assassin_death_rush:OnDestroy()
       local caster = self:GetCaster()
       local stack =  caster:GetModifierStackCount("modifier_phantom_assassin_jug_death_after", nil)
        caster:AddNewModifier(caster, self, "modifier_phantom_assassin_jug_death_after", { })
        caster:SetModifierStackCount("modifier_phantom_assassin_jug_death_after", nil, (stack + 1))
        caster:AddNewModifier(caster, self, "modifier_phantom_assassin_jug_death_after", { })
end

function modifier_phantom_assassin_death_rush:GetMinHealth()
    return 1
end
 
function modifier_phantom_assassin_death_rush:GetEffectName()
    return "particles/heroes/death/samurai_golem_ambient.vpcf"
end

modifier_phantom_assassin_jug_death_after = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
             MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
             MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
             MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
        } end,
 
})

function  modifier_phantom_assassin_jug_death_after:OnCreated()

end  

function modifier_phantom_assassin_jug_death_after:OnDestroy()
 
end

 function modifier_phantom_assassin_jug_death_after:GetTexture()
    return "death"
 end
  
 
function modifier_phantom_assassin_jug_death_after:GetModifierDamageOutgoing_Percentage()
    return -(self:GetStackCount() * 15)
end

function modifier_phantom_assassin_jug_death_after:GetModifierBonusStats_Strength()
    return -(self:GetStackCount() * ((15 / 100) * self:GetCaster():GetBaseStrength()))
end

function modifier_phantom_assassin_jug_death_after:GetModifierBonusStats_Agility()
    return -(self:GetStackCount() * ((15 / 100) * self:GetCaster():GetBaseAgility()))
end

function modifier_phantom_assassin_jug_death_after:GetModifierBonusStats_Intellect()
    return -(self:GetStackCount() * ((15 / 100) * self:GetCaster():GetBaseIntellect()))
end



modifier_phantom_assassin_death_rush_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
            MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
            MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
            MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        } end,
    })

function modifier_phantom_assassin_death_rush_buff:OnCreated()
    self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
    self.attack_base = self:GetAbility():GetSpecialValueFor("attack_base")
    self.dmg_bonus = self:GetAbility():GetSpecialValueFor("dmg_bonus")
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("ms_bonus")
    self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")

end

function modifier_phantom_assassin_death_rush_buff:GetModifierPercentageCooldown()
    return self.cooldown
end

function modifier_phantom_assassin_death_rush_buff:GetModifierBaseAttackTimeConstant()
    return self.attack_base
end

function modifier_phantom_assassin_death_rush_buff:GetModifierBaseAttack_BonusDamage()
    return self.dmg_bonus
end

function modifier_phantom_assassin_death_rush_buff:GetModifierMoveSpeedBonus_Constant()
    return self.ms_bonus
end

function modifier_phantom_assassin_death_rush_buff:GetModifierAttackSpeedBonus_Constant()
    return self.as_bonus
end
