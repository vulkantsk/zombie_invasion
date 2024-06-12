LinkLuaModifier("modifier_death_or_life", "heroes/hero_oracle/death_or_life", LUA_MODIFIER_MOTION_NONE)

death_or_life = class({})

function death_or_life:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local ability = self
local buff_duration = self:GetSpecialValueFor("buff_duration")
local dmg = (target:GetMaxHealth() / 100) * ability:GetSpecialValueFor("hp_proc")
local effect = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg_stroke_tgt.vpcf"
local effect1 = "particles/addons_gameplay/tower_good_tintable_lamp_end.vpcf"
local dick = {
victim = target,
attacker = caster,
damage = dmg,
damage_type = DAMAGE_TYPE_PURE,
}


       if RollPercentage(ability:GetSpecialValueFor("kill_chance")) then

    ParticleManager:CreateParticle(effect, PATTACH_CENTER_FOLLOW, target)
     ApplyDamage(dick)
    elseif RollPercentage(ability:GetSpecialValueFor("buff_chance")) then
    target:AddNewModifier(caster, ability, "modifier_death_or_life", {duration = buff_duration})
    ParticleManager:CreateParticle(effect1, PATTACH_CENTER_FOLLOW, target)
    
    end
 
 
end
 

modifier_death_or_life = class({
    IsHidden                = function(self) return false end,
 
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        } end,
})

function modifier_death_or_life:OnCreated()
                self.mnojitel = self:GetAbility():GetSpecialValueFor( "mnojitel" )
                    local caster = self:GetCaster()
    local target = self:GetParent()
    local damage_bonus = self.mnojitel * caster:GetIntellect(true) * target:GetAttackDamage()

    self:SetStackCount(damage_bonus)
end

function modifier_death_or_life:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end  
