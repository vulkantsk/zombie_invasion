LinkLuaModifier("modifier_item_big_meat", "items/item_big_meat", LUA_MODIFIER_MOTION_NONE)

item_big_meat = class({})
 

function item_big_meat:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_big_meat", nil)
	caster:EmitSound("eating")
	caster:RemoveItem(self)
end


modifier_item_big_meat = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		} end,
})

function modifier_item_big_meat:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_value1 = self:GetAbility():GetSpecialValueFor("bonus_regen")
end

function modifier_item_big_meat:GetModifierHealthBonus()
	return self.bonus_value
end

function modifier_item_big_meat:GetModifierConstantHealthRegen()
	return self.bonus_value1
end

