LinkLuaModifier("modifier_item_her2", "items/new_items/item_her2", LUA_MODIFIER_MOTION_NONE)

item_her2 = class({})

function item_her2:GetIntrinsicModifierName()
	return "modifier_item_her2"
end

modifier_item_her2 = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}end,
})

 
function modifier_item_her2:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("str")
end

function modifier_item_her2:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_item_her2:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("rg")
end