LinkLuaModifier("modifier_phantom_assassin_death_rush", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_passive", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_jug_death", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_rush_cooldown", "heroes/hero_samurai/spells/death_jug", LUA_MODIFIER_MOTION_NONE)

jugger_dead = class({})

function jugger_dead:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_death_rush", { duration = 10})
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
            damage = 100,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(), --Optional.
        }
        ApplyDamage(damageTable)
 end
end

 function modifier_phantom_assassin_death_rush:GetModifierModelChange()
    return "models/items/warlock/golem/grimoires_pitlord_ultimate/grimoires_pitlord_ultimate.vmdl"
end



function modifier_phantom_assassin_death_rush:OnDestroy()
     local caster = self:GetCaster()
 
        caster:AddNewModifier(caster, self, "modifier_phantom_assassin_jug_death", { duration = 8})
 
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
    IsHidden                = function(self) return false end,
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
        
        self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_DISABLED, 1)     
 
end  

 

function modifier_phantom_assassin_jug_death:OnDestroy()
self:GetCaster():ForceKill(false)
 
end
