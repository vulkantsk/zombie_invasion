modifier_overheating = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_overheating:OnCreated() 
    self:StartIntervalThink( 1 )
  
end 

function modifier_overheating:OnIntervalThink() 

    if self:GetStackCount() >= 100 then 
             self:GetParent():SetRenderColor( 72,6,7 )
    elseif self:GetStackCount() >= 25 then
  
           self:GetParent():SetRenderColor(255,36,0 )
    end
end 

function modifier_overheating:GetTexture()
    return "overhell"
end