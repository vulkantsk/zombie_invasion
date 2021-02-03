LinkLuaModifier("modifier_item_crit", "items/new_items/item_crit", LUA_MODIFIER_MOTION_NONE)

item_crit = class({})

function item_crit:GetIntrinsicModifierName()
	return "modifier_item_crit"
end

modifier_item_crit = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}end,
})

 
function modifier_item_crit:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("dmg")
end

function modifier_item_crit:GetModifierPreAttack_CriticalStrike()
	if RollPercentage(50) then
			return self:GetAbility():GetSpecialValueFor("crit")
	else 
			return 1
	end	
end