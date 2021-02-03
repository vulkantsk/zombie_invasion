LinkLuaModifier("modifier_item_resistance1", "items/new_items/item_resistance1", LUA_MODIFIER_MOTION_NONE)

item_resistance1 = class({})

function item_resistance1:GetIntrinsicModifierName()
	return "modifier_item_resistance1"
end

modifier_item_resistance1 = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}end,
})

 
function modifier_item_resistance1:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("res")
end

function modifier_item_resistance1:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("arm")
end