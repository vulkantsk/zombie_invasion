modifier_dry = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return false end,
 })


 
 
 

function modifier_dry:GetTexture() 
    return "pudge_rot" 
end

 

 

function modifier_dry:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT  }
end


 

function modifier_dry:GetModifierMoveSpeedBonus_Constant()
        return -200
end

 