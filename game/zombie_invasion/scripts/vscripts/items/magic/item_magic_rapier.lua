LinkLuaModifier("modifier_item_magic_rapier", "items/magic/item_magic_rapier", LUA_MODIFIER_MOTION_NONE)
item_magic_rapier = class({})



function item_magic_rapier:GetIntrinsicModifierName()
	return "modifier_item_magic_rapier"
end

modifier_item_magic_rapier = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}end,
})
 
function modifier_item_magic_rapier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

 	 
 

function modifier_item_magic_rapier:GetModifierSpellAmplify_Percentage()
	return   self:GetAbility():GetSpecialValueFor("bonus_magic_damage")
end
