LinkLuaModifier("modifier_item_her", "items/new_items/item_her", LUA_MODIFIER_MOTION_NONE)

item_her = class({})

function item_her:GetIntrinsicModifierName()
	return "modifier_item_her"
end

modifier_item_her = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}end,
})

function modifier_item_her:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_her:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("str")
end

function modifier_item_her:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_item_her:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("rg")
end