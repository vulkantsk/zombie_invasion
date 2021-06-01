LinkLuaModifier("modifier_tide_health", "heroes/hero_tide/tide_health", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------
------------------------------------------------------------

tide_health = class({})

function tide_health:GetIntrinsicModifierName()
	return "modifier_tide_health"
end

------------------------------------------------------------
------------------------------------------------------------
modifier_tide_health = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS} end,
})

function modifier_tide_health:GetModifierHealthBonus()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("str_per_stack")
end

if IsClient() then
	return
end

function modifier_tide_health:OnCreated()
	self:GetParent():SetRenderColor(51, 102 , 0 )
end

function modifier_tide_health:OnTakeDamage( params )
	local hUnit = params.unit
	local hAttacker = params.attacker
	local parent = self:GetParent()
	if hAttacker == nil or hAttacker:IsBuilding() then
		return 0
	end
	
	if not parent.damage_cap then
		parent.damage_cap = 0
	end
	
	if hUnit == parent then
		local damage = params.damage
		local ability = self:GetAbility()
		local dmg_proc = ability:GetSpecialValueFor("dmg_proc")
		local parent_maxhealth = parent:GetMaxHealth()
		if damage >= parent_maxhealth then
			damage = parent_maxhealth
		end

		parent.damage_cap = parent.damage_cap + damage
		local stacks = math.floor(parent.damage_cap/dmg_proc)
		if stacks > 0 then 
			parent.damage_cap = parent.damage_cap - stacks*dmg_proc
			local modifier = "modifier_tide_health"
			local currentStacks = parent:GetModifierStackCount(modifier, ability)
			
			parent:SetModifierStackCount(modifier, ability, (currentStacks + stacks))
			parent:AddNewModifier(parent,ability, "modifier_phased", {duration = 0.01})
--			self:SetStackCount(self:GetStackCount()+stacks)
		end
			
	end
end