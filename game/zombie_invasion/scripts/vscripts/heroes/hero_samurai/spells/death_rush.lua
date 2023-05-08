LinkLuaModifier("modifier_jugger_miracle", "heroes/hero_samurai/spells/death_rush", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jugger_miracle_passive", "heroes/hero_samurai/spells/death_rush", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jugger_death_rush_buff", "heroes/hero_samurai/spells/death_rush", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jugger_miracle_rush_cooldown", "heroes/hero_samurai/spells/death_rush", LUA_MODIFIER_MOTION_NONE)

jugger_miracle = class({})

function jugger_miracle:GetIntrinsicModifierName()
    return "modifier_jugger_miracle_passive"
end

modifier_jugger_miracle_passive = class({
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
function modifier_jugger_miracle_passive:GetMinHealth()
    if self:GetAbility():IsCooldownReady() or not self:GetCaster():IsRealHero() then
        return 1
    else
        return 
    end

end

function modifier_jugger_miracle_passive:OnTakeDamage( keys )
    if not  IsServer() then
        return
    end
    if keys.unit ~= self:GetCaster() then
        return
    end
    if self:GetCaster():FindModifierByName("modifier_jugger_miracle_rush_cooldown") then
        return
    end

    if not self:GetAbility():IsCooldownReady() then
        return
    end

    if self:GetCaster():GetHealth() <= 1 then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("duration")
      
        caster:AddNewModifier(caster, ability, "modifier_jugger_miracle", { duration = duration})
                  self:GetCaster():Purge( false, true, false, true, true )
        ability:UseResources(true, true, true,true)
   
    end
end

modifier_jugger_miracle = class({
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
                                MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
                    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
                    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        } end,
    CheckState      = function(self) return 
        {
         
        
        } end,
})

function modifier_jugger_miracle:OnDestroy()
 
end

function modifier_jugger_miracle:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_jugger_miracle:GetAbsoluteNoDamageMagical()
    return 1
end


function modifier_jugger_miracle:GetAbsoluteNoDamagePhysical()
    return 1
end


function modifier_jugger_miracle:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("dmg_bonus")
end

function modifier_jugger_miracle:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("ms_bonus")
end

function modifier_jugger_miracle:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("as_bonus")
end

function modifier_jugger_miracle:GetEffectName()
    return "particles/heroes/death/samurai_purple_ambient_3.vpcf"
end
