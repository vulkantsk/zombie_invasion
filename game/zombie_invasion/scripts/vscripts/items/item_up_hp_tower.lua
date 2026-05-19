LinkLuaModifier("modifier_item_hp_tower", "items/item_up_hp_tower", LUA_MODIFIER_MOTION_NONE)
if item_up_hp_tower == nil then
	item_up_hp_tower = class({})
 
end


 


function item_up_hp_tower:CastFilterResultTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:HasAbility("hommer_cry") then
			return UF_FAIL_CUSTOM
		end

 
 

		return UF_SUCCESS
	end
end


function item_up_hp_tower:GetCustomCastErrorTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:HasAbility("hommer_cry") then
			return "#dota_hud_error_cheese_bad_target"
		end

 
 

		return UF_SUCCESS
	end
end
 

function item_up_hp_tower:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil

if hTarget:GetUnitName() == "NPC_base" then 
 	hTarget:AddNewModifier(hCaster, self, "modifier_item_hp_tower", nil)
		hCaster:EmitSound("DOTA_Item.Cheese.Activate")
		UTIL_Remove(hItem)
 else 
 	return nil
 end
 
end


modifier_item_hp_tower = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	

			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,  
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT

		} end,
})

function modifier_item_hp_tower:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("health")
 
end

 

function modifier_item_hp_tower:GetModifierExtraHealthBonus()
	return self.bonus_value
end

 
