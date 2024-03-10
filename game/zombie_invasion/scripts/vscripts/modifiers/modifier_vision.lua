
LinkLuaModifier("modifier_vision", "modifiers/modifier_vision.lua", LUA_MODIFIER_MOTION_NONE )
modifier_vision = class({
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

    GetEffectName           = function(self) return "particles/units/heroes/hero_spectre/spectre_desolate_debuff.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})


--------------------------------------------------------------------------------

function modifier_vision:OnCreated()
end

function modifier_vision:GetBonusVisionPercentage() return 1200 * -1 end