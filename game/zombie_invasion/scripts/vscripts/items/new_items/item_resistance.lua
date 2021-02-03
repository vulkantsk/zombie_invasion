LinkLuaModifier("modifier_item_resistance", "items/new_items/item_resistance", LUA_MODIFIER_MOTION_NONE)

item_resistance = class({})

function item_resistance:GetIntrinsicModifierName()
	return "modifier_item_resistance"
end

modifier_item_resistance = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}end,
})

 
function modifier_item_resistance:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("res")
end

function modifier_item_resistance:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("arm")
end