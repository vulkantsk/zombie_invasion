item_magpier_baseclass = {
	GetIntrinsicModifierName = function() return "modifier_item_magicpier" end,
}

LinkLuaModifier("modifier_item_magicpier", "items/magic/item_magicpier", LUA_MODIFIER_MOTION_NONE)
item_talisman = class(item_magpier_baseclass)

item_magic_staff = class(item_magpier_baseclass)

item_magic_stone = class(item_magpier_baseclass)
 
 

modifier_item_magicpier = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS

	}end,
})
 
function modifier_item_magicpier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

 function modifier_item_magicpier:OnCreated()
     self.bonus_magic_damage =   self:GetAbility():GetSpecialValueFor("bonus_magic_damage")
     self.reduce_mana_cost =   self:GetAbility():GetSpecialValueFor("reduce_mana_cost")
     self.bonus_int =   self:GetAbility():GetSpecialValueFor("bonus_int")
end 
 
 function modifier_item_magicpier:OnRefresh()
     self.bonus_magic_damage =   self:GetAbility():GetSpecialValueFor("bonus_magic_damage")
     self.reduce_mana_cost =   self:GetAbility():GetSpecialValueFor("reduce_mana_cost")
     self.bonus_int =   self:GetAbility():GetSpecialValueFor("bonus_int")
end 

function modifier_item_magicpier:GetModifierSpellAmplify_Percentage()
	return   self.bonus_magic_damage
end

function modifier_item_magicpier:GetModifierPercentageManacostStacking()
	return   self.reduce_mana_cost
end

function modifier_item_magicpier:GetModifierBonusStats_Intellect()
	return   self.bonus_int
end

