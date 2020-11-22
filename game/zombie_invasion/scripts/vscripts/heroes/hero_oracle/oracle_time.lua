LinkLuaModifier('modifier_oracle_time_active', 'heroes/hero_oracle/oracle_time', LUA_MODIFIER_MOTION_NONE)

oracle_time = class({})
function oracle_time:OnSpellStart()
     local caster = self:GetCaster()
    self:GetCursorTarget():AddNewModifier(self:GetCursorTarget(), self, 'modifier_oracle_time_active', {
        duration = self:GetSpecialValueFor('duration') + self:GetSpecialValueFor("int_duration") * caster:GetIntellect()
    })
    self:GetCursorTarget():EmitSound('Hero_Abaddon.BorrowedTime')
end
modifier_oracle_time_active = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetStatusEffectName     = function(self) return 'particles/status_fx/status_effect_abaddon_borrowed_time.vpcf' end,
    GetEffectName           = function(self) return 'particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf' end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    StatusEffectPriority    = function(self) return MODIFIER_PRIORITY_HIGH end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
        }
    end,
})

function modifier_oracle_time_active:GetModifierIncomingDamage_Percentage(data)

    self.parent:Heal(data.damage, self.parent)
    return -100
end

function modifier_oracle_time_active:OnCreated()
    if IsClient() then return end
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.caster:Purge(false, true, true, true, false)
end