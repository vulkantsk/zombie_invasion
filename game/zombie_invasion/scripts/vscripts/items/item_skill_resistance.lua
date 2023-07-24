LinkLuaModifier("modifier_item_resist", "items/item_skill_resistance", LUA_MODIFIER_MOTION_NONE)

item_resist = class({
    GetIntrinsicModifierName = function() return "modifier_item_resist" end
})


modifier_item_resist = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    } end
})



function modifier_item_resist:OnCreated()
	self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resist")
end

function modifier_item_resist:OnRefresh()
    self:OnCreated()

end

function modifier_item_resist:GetTexture()
	return "mask_of_resistance"
end


function modifier_item_resist:GetModifierMagicalResistanceBonus()
	return self.magic_resist 
end
