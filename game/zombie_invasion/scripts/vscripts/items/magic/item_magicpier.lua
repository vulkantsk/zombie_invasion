LinkLuaModifier("modifier_item_magicpier", "items/magic/item_magicpier", LUA_MODIFIER_MOTION_NONE)
item_magicpier = class({})



function item_magicpier:GetIntrinsicModifierName()
	return "modifier_item_magicpier"
end

modifier_item_magicpier = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}end,
})
 
function modifier_item_magicpier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

 	 
 

function modifier_item_magicpier:GetModifierSpellAmplify_Percentage()
	return   self:GetAbility():GetSpecialValueFor("bonus_magic_damage")
end

 