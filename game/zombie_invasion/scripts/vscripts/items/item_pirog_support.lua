LinkLuaModifier("modifier_item_pirog_support", "items/item_pirog_support", LUA_MODIFIER_MOTION_NONE)

item_pirog_support = class({})
 
function item_pirog_support:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if   target:HasModifier("modifier_item_pirog_dps") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("modifier_item_pirog_tank") or target:HasModifier("item_pirog_universal") then
			return UF_FAIL_CUSTOM
		end

 

		return UF_SUCCESS
	end
end


function item_pirog_support:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
 
		if   target:HasModifier("modifier_item_pirog_dps") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("modifier_item_pirog_tank") or target:HasModifier("item_pirog_universal") then
			return "#dota_hud_error_pirog"
		end
 

		return UF_SUCCESS
	end
end

function item_pirog_support:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(target, self, "modifier_item_pirog_support", nil)
	target:EmitSound("eating")
	caster:RemoveItem(self)
end


modifier_item_pirog_support = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		    MODIFIER_PROPERTY_MODEL_SCALE,
		} end,
})

function modifier_item_pirog_support:OnCreated()
	self.model_scale = self:GetAbility():GetSpecialValueFor("model_scale")
	self.strenght_bonus = self:GetAbility():GetSpecialValueFor("strenght_bonus")
	self.bonus_amp = self:GetAbility():GetSpecialValueFor("bonus_amp")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_item_pirog_support:GetModifierModelScale()
	return self.model_scale
end

function modifier_item_pirog_support:GetModifierConstantManaRegen()
	return self.mana_regen
end

function modifier_item_pirog_support:GetModifierSpellAmplify_Percentage()
	return self.bonus_amp
end

function modifier_item_pirog_support:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_pirog_support:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed
end

function modifier_item_pirog_support:GetTexture()
	return "pirog_support"
end
 