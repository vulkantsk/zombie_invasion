LinkLuaModifier( "modifier_invul", "abilities/ability_invul", LUA_MODIFIER_MOTION_NONE )
ability_invul = class({})


function ability_invul:GetIntrinsicModifierName()
    return "modifier_invul"
end


modifier_invul = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
 
})


function modifier_invul:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end
function modifier_invul:GetMinHealth()
    return 666
end