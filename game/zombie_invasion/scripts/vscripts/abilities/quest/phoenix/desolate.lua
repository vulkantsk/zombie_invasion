LinkLuaModifier( "modifier_ability_desolate_lua", "abilities/quest/phoenix/desolate" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_desolate_debuff_lua", "abilities/quest/phoenix/desolate" ,LUA_MODIFIER_MOTION_NONE )

if ability_desolate == nil then
    ability_desolate = class({})
end

--------------------------------------------------------------------------------

function ability_desolate:GetIntrinsicModifierName()
    return "modifier_ability_desolate_lua"
end

--------------------------------------------------------------------------------


modifier_ability_desolate_lua = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_EVENT_ON_ATTACK,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_ability_desolate_lua:OnAttack(k)
    local attacker = k.attacker
    local target = k.target
    local caster = self:GetParent()
    if attacker == caster and not caster:PassivesDisabled() then
        local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
        local radius = self:GetAbility():GetSpecialValueFor("radius")
        local blind_duration = self:GetAbility():GetSpecialValueFor("blind_duration")
 
            target:AddNewModifier(caster, self:GetAbility(), "modifier_ability_desolate_debuff_lua", {Duration=blind_duration})

            ApplyDamage({
                victim = target,
                attacker = caster,
                damage = bonus_damage,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility()
            })
         
    end
end

--------------------------------------------------------------------------------


modifier_ability_desolate_debuff_lua = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
        }
    end,

    GetEffectName           = function(self) return "" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})


--------------------------------------------------------------------------------

function modifier_ability_desolate_debuff_lua:OnCreated()
    self.blind_pct = self:GetAbility():GetSpecialValueFor("blind_pct")
end

function modifier_ability_desolate_debuff_lua:GetBonusVisionPercentage() return self.blind_pct * -1 end