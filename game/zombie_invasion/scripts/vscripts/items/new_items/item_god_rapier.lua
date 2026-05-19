LinkLuaModifier("modifier_item_god_rapier", "items/new_items/item_god_rapier", LUA_MODIFIER_MOTION_NONE)
item_god_rapier = class({})


function item_god_rapier:GetIntrinsicModifierName()
	return "modifier_item_god_rapier"
end

modifier_item_god_rapier = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}end,
})

function modifier_item_god_rapier:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_god_rapier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_god_rapier:CheckState()
	return {[MODIFIER_STATE_CANNOT_MISS] = true}
end