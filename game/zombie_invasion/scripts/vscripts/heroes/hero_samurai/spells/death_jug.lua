LinkLuaModifier("modifier_phantom_assassin_death_rush", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_passive", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_jug_death", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_cooldown", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_jug_death_after", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
  
jugger_dead = class({})

function jugger_dead:OnAbilityPhaseStart()
    if IsServer() then
        EmitSoundOn("gate_dead",  self:GetCaster())
      self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 3.00)  
  end
  return true
   end
function jugger_dead:OnAbilityPhaseInterrupted()
    if IsServer() then
      StopSoundOn("gate_dead", self:GetCaster())     
      self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
  end
  return true
end

function jugger_dead:OnSpellStart()

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_death_rush", { duration =  self:GetSpecialValueFor("duration")})
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
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
            MODIFIER_PROPERTY_MIN_HEALTH,
        } end,
    CheckState      = function(self) return 
        {
        
  
        } end,
})
   function  modifier_phantom_assassin_death_rush:OnCreated()
  
   
        self:StartIntervalThink( 0.2 )
  
end
 
    function  modifier_phantom_assassin_death_rush:OnIntervalThink()
    if IsServer() then
   
                local damageTable = {
            victim = self:GetCaster(),
            attacker = self:GetCaster(),
            damage = (self:GetCaster():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("damage_self")/100)) *0.2,
            damage_type = DAMAGE_TYPE_PURE,  
            ability = self:GetAbility(), --Optional.
        }
        ApplyDamage(damageTable)
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
         caster:AddNewModifier(caster, self, "modifier_phantom_assassin_jug_death", { duration = 10})
 
end

function modifier_phantom_assassin_death_rush:GetModifierIgnoreMovespeedLimit()  
    return 1
end


function modifier_phantom_assassin_death_rush:GetMinHealth()
    return 1
end

function modifier_phantom_assassin_death_rush:GetModifierStatusResistanceStacking( params )
 
        return self:GetAbility():GetSpecialValueFor("status_resist")
 
end

function modifier_phantom_assassin_death_rush:GetModifierPercentageCooldown()
    return self:GetAbility():GetSpecialValueFor("cooldown")
end

function modifier_phantom_assassin_death_rush:GetModifierTurnRate_Percentage()
    return self:GetAbility():GetSpecialValueFor("turn")
end

function modifier_phantom_assassin_death_rush:GetModifierBaseAttackTimeConstant()
    return self:GetAbility():GetSpecialValueFor("attack_base")
end

function modifier_phantom_assassin_death_rush:GetModifierPercentageCasttime()
    return 100
end


function modifier_phantom_assassin_death_rush:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("dmg_bonus")
end

function modifier_phantom_assassin_death_rush:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("ms_bonus")
end

function modifier_phantom_assassin_death_rush:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("as_bonus")
end
 
 
 
function modifier_phantom_assassin_death_rush:GetEffectName()
    return "particles/heroes/death/samurai_golem_ambient.vpcf"
end

 

 modifier_phantom_assassin_jug_death = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
 
        } end,
    CheckState      = function(self) return 
        {
                  
            [MODIFIER_STATE_INVULNERABLE] = true, 
            [MODIFIER_STATE_ROOTED] = true, 
            [MODIFIER_STATE_DISARMED] = true, 
            [MODIFIER_STATE_STUNNED] = true, 
 
        } end,
})

       function  modifier_phantom_assassin_jug_death:OnCreated()
               EmitSoundOn("gate_dead_after",  self:GetCaster())     
 
end  

 

function modifier_phantom_assassin_jug_death:OnDestroy()
 
self:GetCaster():ForceKill(false)
 
 
     
end

 modifier_phantom_assassin_jug_death_after = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, 
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