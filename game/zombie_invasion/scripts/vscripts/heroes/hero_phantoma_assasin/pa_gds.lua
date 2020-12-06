LinkLuaModifier("modifier_pa_gds", "heroes/hero_phantoma_assasin/pa_gds", LUA_MODIFIER_MOTION_NONE)

pa_gds = class ({})

function pa_gds:OnSpellStart()
local caster = self:GetCaster()
local ability = self
local effect = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
local buff_duration = self:GetSpecialValueFor("duration")
ParticleManager:CreateParticle(effect, PATTACH_CENTER_FOLLOW, caster)
caster:AddNewModifier(caster, ability, "modifier_pa_gds", {duration = buff_duration})
end

-------------------------------------------------

modifier_pa_gds = class({})

function modifier_pa_gds:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

    }
    return funcs
end

function modifier_pa_gds:IsHidden()
    return false
end

function modifier_pa_gds:IsPurgable()
    return false
end

function modifier_pa_gds:RemoveOnDeath()
    return false
end

function modifier_pa_gds:OnCreated()
                self.mnojitel = self:GetAbility():GetSpecialValueFor( "dmg" )
                    local caster = self:GetCaster()
    local damage_bonus = self.mnojitel * caster:GetAttackDamage()

    self:SetStackCount(damage_bonus)
end

function modifier_pa_gds:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end 


