LinkLuaModifier("modifier_item_brevno", "items/item_brevno", LUA_MODIFIER_MOTION_NONE)

item_brevno = class({})

function item_brevno:GetIntrinsicModifierName()
    return "modifier_item_brevno"
end

modifier_item_brevno = class({
    IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        
    }end,
})

function modifier_item_brevno:OnCreated()
    self.slow_brevno = self:GetAbility():GetSpecialValueFor("slow_brevno")
    
end

function modifier_item_brevno:OnRefresh()
    self:OnCreated()
end

function modifier_item_brevno:RemoveOnDeath()
    return false
end

function modifier_item_brevno:GetModifierMoveSpeedBonus_Percentage()
    return self.slow_brevno
end
 


