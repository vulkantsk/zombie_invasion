LinkLuaModifier( "modifier_press_the_berserk", "heroes/hero_legion/abilities/press_the_berserk" ,LUA_MODIFIER_MOTION_NONE )

if press_the_berserk == nil then
    press_the_berserk = class({})
end

--------------------------------------------------------------------------------

function press_the_berserk:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if target:TriggerSpellAbsorb(self) then return end

    local duration = self:GetSpecialValueFor("duration")

    target:AddNewModifier(caster, self, "modifier_press_the_berserk", {duration=duration})
    
    self:GetCaster():EmitSound("Hero_LegionCommander.PressTheAttack")
    
end

--------------------------------------------------------------------------------


modifier_press_the_berserk = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
            MODIFIER_EVENT_ON_DEATH,
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        }
    end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    StatusEffectPriority    = function(self) return 8 end,
})


--------------------------------------------------------------------------------

function modifier_press_the_berserk:OnRefresh()
    self:OnCreated()
end 

function modifier_press_the_berserk:OnCreated()
    self.damage_increase_outgoing_pct = self:GetAbility():GetSpecialValueFor("damage_increase_outgoing_pct")
    self.damage_increase_incoming_pct = self:GetAbility():GetSpecialValueFor("damage_increase_incoming_pct")
    self.health_bonus_pct = self:GetAbility():GetSpecialValueFor("health_bonus_pct")
    self.health_bonus_creep_pct = self:GetAbility():GetSpecialValueFor("health_bonus_creep_pct")
    self.health_bonus_aoe = self:GetAbility():GetSpecialValueFor("health_bonus_aoe")
    self.health_bonus_share_percent = self:GetAbility():GetSpecialValueFor("health_bonus_share_percent")
    self.health_regeneration_bonus = self:GetAbility():GetSpecialValueFor("health_regeneration_bonus")
    self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
end

function modifier_press_the_berserk:GetEffectName()
return "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
end

function modifier_press_the_berserk:GetStatusEffectName()
    return "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner_alt.vpcf"
end


function modifier_press_the_berserk:OnDeath(k)
    local parent = self:GetParent()
    local unit = k.unit
    local attacker = k.attacker

    local pct = self.health_bonus_pct
    if not unit:IsHero() then
        pct = self.health_bonus_creep_pct
    end

    local UnitMaxHealth = unit:GetMaxHealth()
    local Heal = UnitMaxHealth / 100 * pct

    local distance = (unit:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D()
end


function modifier_press_the_berserk:GetModifierTotalDamageOutgoing_Percentage() return self.damage_increase_outgoing_pct end
function modifier_press_the_berserk:GetModifierIncomingDamage_Percentage() return self.damage_increase_incoming_pct end
function modifier_press_the_berserk:GetModifierHealthRegenPercentage() return self.health_regeneration_bonus end
function modifier_press_the_berserk:GetModifierAttackSpeedBonus_Constant() return self.attack_speed_bonus end

function modifier_press_the_berserk:IsDebuff()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return false
    end
    return true
end