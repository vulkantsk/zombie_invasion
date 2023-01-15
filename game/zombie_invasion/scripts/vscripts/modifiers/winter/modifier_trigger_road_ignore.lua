modifier_trigger_road_ignore = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_trigger_road_ignore:GetTexture() 
    return "antimage_blink" 
end


 