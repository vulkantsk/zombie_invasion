LinkLuaModifier( "modifier_ability_firecleave", "heroes/hero_sargatanas/firecleave" ,LUA_MODIFIER_MOTION_NONE )

if ability_firecleave == nil then
    ability_firecleave = class({})
end

--------------------------------------------------------------------------------

function ability_firecleave:GetIntrinsicModifierName()
    return "modifier_ability_firecleave"
end

--------------------------------------------------------------------------------


modifier_ability_firecleave = class({
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

function modifier_ability_firecleave:OnRefresh()
    self:OnCreated()
end 

function modifier_ability_firecleave:OnCreated()
    self.cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
    self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
    self.cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
    self.great_cleave_damage = self:GetAbility():GetSpecialValueFor("great_cleave_damage")
end

function modifier_ability_firecleave:OnAttackLanded(k)
    local caster = self:GetParent()
    local target = k.target
    local attacker = k.attacker
    if caster == attacker and not caster:PassivesDisabled() then
        local fx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit_b.vpcf"
        DoCleaveAttack(caster, target, self:GetAbility(), self.great_cleave_damage, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, fx)
    end
end