LinkLuaModifier("modifier_item_pirog_tank", "items/item_pirog_tank", LUA_MODIFIER_MOTION_NONE)

item_pirog_tank = class({})
 
function item_pirog_tank:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if   target:HasModifier("modifier_item_pirog_dps") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("modifier_item_pirog_universal") or target:HasModifier("modifier_item_pirog_support") then
			return UF_FAIL_CUSTOM
		end

 

		return UF_SUCCESS
	end
end


function item_pirog_tank:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
 
		if   target:HasModifier("modifier_item_pirog_dps") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("modifier_item_pirog_universal") or target:HasModifier("modifier_item_pirog_support") then
			return "#dota_hud_error_pirog"
		end
 

		return UF_SUCCESS
	end
end

function item_pirog_tank:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(target, self, "modifier_item_pirog_tank", nil)
	target:EmitSound("eating")
	caster:RemoveItem(self)
end


modifier_item_pirog_tank = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,  
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		    MODIFIER_PROPERTY_MODEL_SCALE,
		} end,
})

function modifier_item_pirog_tank:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_value1 = self:GetAbility():GetSpecialValueFor("bonus_regen")
	self.bonus_value2 = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_value3 = self:GetAbility():GetSpecialValueFor("bonus_derjat")
	self.bonus_value4 = self:GetAbility():GetSpecialValueFor("bonus_model")
end

function modifier_item_pirog_tank:GetModifierModelScale()
	return self.bonus_value4
end

function modifier_item_pirog_tank:GetModifierMagicalResistanceBonus()
	return self.bonus_value3
end

function modifier_item_pirog_tank:GetModifierPhysicalArmorBonus()
	return self.bonus_value2
end

function modifier_item_pirog_tank:GetModifierHealthBonus()
	return self.bonus_value
end

function modifier_item_pirog_tank:GetModifierHealthRegenPercentage()
	return self.bonus_value1
end

function modifier_item_pirog_tank:GetTexture()
	return "item_pie_tank"
end
 