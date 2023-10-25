LinkLuaModifier("modifier_item_pirog_dps", "items/item_pirog_dps", LUA_MODIFIER_MOTION_NONE)

item_pirog_dps = class({})
 


function item_pirog_dps:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if   target:HasModifier("modifier_item_pirog_tank") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("item_pirog_universal") or target:HasModifier("modifier_item_pirog_support") then
			return UF_FAIL_CUSTOM
		end

 

		return UF_SUCCESS
	end
end


function item_pirog_dps:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
 
		if   target:HasModifier("modifier_item_pirog_tank") or target:HasModifier("modifier_item_pirog_magic") or target:HasModifier("item_pirog_universal") or target:HasModifier("modifier_item_pirog_support") then
			return "#dota_hud_error_pirog"
		end
 

		return UF_SUCCESS
	end
end

function item_pirog_dps:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
			local player = caster:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local point = target:GetAbsOrigin() 
			local team = caster:GetTeam()
	target:AddNewModifier(target, self, "modifier_item_pirog_dps", nil)
	target:EmitSound("eating")
	caster:RemoveItem(self)
	if target:GetUnitName() == "npc_boss_pig" then 
		InvasionMode:Bo_plus()
		print(Pig_bo_kill)
			 target:ForceKill(true)
			target:AddNoDraw()
			local unit = CreateUnitByName( "npc_boss_pig_pet", point, true, nil, nil, team )
				unit:AddNewModifier(unit, self, "modifier_item_pirog_dps", nil)		 
			unit:SetOwner(hero)
			unit:SetControllableByPlayer(player, true)

 
	end
end


modifier_item_pirog_dps = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,  
		    MODIFIER_PROPERTY_MODEL_SCALE,
		} end,
})

function modifier_item_pirog_dps:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("damage")
	self.bonus_value1 = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_value2 = self:GetAbility():GetSpecialValueFor("bonus_dps")
	self.bonus_value3 = self:GetAbility():GetSpecialValueFor("bonus_model")
end

 

function modifier_item_pirog_dps:GetModifierModelScale()
	return self.bonus_value3
end

function modifier_item_pirog_dps:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_value2
end

function modifier_item_pirog_dps:GetModifierPreAttack_BonusDamage()
	return self.bonus_value
end

function modifier_item_pirog_dps:GetModifierBonusStats_Agility()
	return self.bonus_value1
end


function modifier_item_pirog_dps:GetTexture()
	return "item_pie_dps"
end
