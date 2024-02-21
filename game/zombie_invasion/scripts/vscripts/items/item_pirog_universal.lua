LinkLuaModifier("modifier_item_pirog_universal", "items/item_pirog_universal", LUA_MODIFIER_MOTION_NONE)

item_pirog_universal = class({})
 
function item_pirog_universal:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if   target:HasModifier("modifier_item_pirog_dps") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("modifier_item_pirog_tank") then
			return UF_FAIL_CUSTOM
		end

 

		return UF_SUCCESS
	end
end


function item_pirog_universal:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
 
		if   target:HasModifier("modifier_item_pirog_dps") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("modifier_item_pirog_tank") then
			return "#dota_hud_error_pirog"
		end
 

		return UF_SUCCESS
	end
end

function item_pirog_universal:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(target, self, "modifier_item_pirog_universal", nil)
	target:EmitSound("eating")
	caster:RemoveItem(self)
end


modifier_item_pirog_universal = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		    MODIFIER_PROPERTY_MODEL_SCALE,
		} end,
})

function modifier_item_pirog_universal:OnCreated()
	self.model_scale = self:GetAbility():GetSpecialValueFor("model_scale")
	self.strenght_bonus = self:GetAbility():GetSpecialValueFor("strenght_bonus")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_item_pirog_universal:GetModifierModelScale()
	return self.model_scale
end

function modifier_item_pirog_universal:GetModifierBonusStats_Strength()
	return self.strenght_bonus
end

function modifier_item_pirog_universal:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_pirog_universal:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_pirog_universal:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed
end

function modifier_item_pirog_universal:GetTexture()
	return "pie_universal"
end
 