LinkLuaModifier( "modifier_ability_firecleave_creep", "heroes/hero_sargatanas/summons/summons_abilities/firecleave_creep" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_firecleave_creep_fire", "heroes/hero_sargatanas/summons/summons_abilities/firecleave_creep" ,LUA_MODIFIER_MOTION_NONE )


if ability_firecleave_creep == nil then
    ability_firecleave_creep = class({})
end

--------------------------------------------------------------------------------
    
function modifier_ability_firecleave_creep:GetIntrinsicModifierName()
    return "modifier_ability_firecleave_creep"
end

--------------------------------------------------------------------------------


modifier_ability_firecleave_creep = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_EVENT_ON_ATTACK_LANDED
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_ability_firecleave_creep:OnRefresh()
    self:OnCreated()
end 


function modifier_ability_firecleave_creep:OnAttackLanded(k)
    local caster = self:GetParent()
    local target = k.target
    local attacker = k.attacker
    local duration = self:GetAbility():GetSpecialValueFor("duration")
    if caster == attacker and not caster:PassivesDisabled() then
        target:AddNewModifier(caster,self:GetAbility(),"modifier_ability_firecleave_creep",{duration = duration})
    end
end


modifier_ability_firecleave_creep_fire = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return false end,
    GetEffectName           = function(self) return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_flame_circulate.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_ability_firecleave_creep_fire:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_ability_firecleave_creep_fire:OnIntervalThink()
    local damage = self:GetAbility():GetSpecialValueFor("fire_damage")
    local damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage * self:GetParent():DamageHell(),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)
end
