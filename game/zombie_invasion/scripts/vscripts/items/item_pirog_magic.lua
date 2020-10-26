LinkLuaModifier("modifier_item_pirog_magic", "items/item_pirog_magic", LUA_MODIFIER_MOTION_NONE)

item_pirog_magic = class({})
 

function item_pirog_magic:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_pirog_magic", nil)
	caster:EmitSound("eating")
	caster:RemoveItem(self)
end


modifier_item_pirog_magic = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_MANA_BONUS,
			MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
			MODIFIER_PROPERTY_MANACOST_PERCENTAGE,  
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		    MODIFIER_PROPERTY_MODEL_SCALE,
		} end,
})

function modifier_item_pirog_magic:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_value1 = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_value2 = self:GetAbility():GetSpecialValueFor("bonus_manacost")
	self.bonus_value3 = self:GetAbility():GetSpecialValueFor("bonus_dps")
	self.bonus_value4 = self:GetAbility():GetSpecialValueFor("bonus_model")
end

function modifier_item_pirog_magic:GetModifierModelScale()
	return self.bonus_value4
end

function modifier_item_pirog_magic:GetModifierSpellAmplify_Percentage()
	return self.bonus_value3
end

function modifier_item_pirog_magic:GetModifierPercentageManacost()
	return self.bonus_value2
end

function modifier_item_pirog_magic:GetModifierManaBonus()
	return self.bonus_value
end

function modifier_item_pirog_magic:GetModifierTotalPercentageManaRegen()
	return self.bonus_value1
end

