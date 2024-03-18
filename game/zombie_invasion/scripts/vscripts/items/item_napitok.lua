LinkLuaModifier("modifier_item_napitok", "items/item_napitok", LUA_MODIFIER_MOTION_NONE)

item_napitok = class({})
 

function item_napitok:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_napitok", nil)
	EmitSoundOn("drinking", caster)
	UTIL_Remove(self)
end


modifier_item_napitok = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,  
		} end,
})

function modifier_item_napitok:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("bonus_dps")
end

 

function modifier_item_napitok:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_value
end

 

