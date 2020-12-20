LinkLuaModifier("modifier_item_dickrapier", "items/new_items/item_dickrapier", LUA_MODIFIER_MOTION_NONE)

item_dickrapier = class({})

function item_dickrapier:GetIntrinsicModifierName()
	return "modifier_item_dickrapier"
end

modifier_item_dickrapier = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}end,
})

function modifier_item_dickrapier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_dickrapier:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end