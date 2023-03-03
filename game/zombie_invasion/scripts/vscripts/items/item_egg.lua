LinkLuaModifier("modifier_veteran_grow_water_2", "items/item_egg.lua", LUA_MODIFIER_MOTION_NONE)


function WaterSetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_veteran_grow_water_2"
	local grow_ability = target:FindAbilityByName("veteran_grow_water") 

		local currentStacks = target:GetModifierStackCount(StackModifier, nil)

		if currentStacks == 0 then
			target:AddNewModifier(caster, ability, StackModifier, {})
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		else 
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		end
	if grow_ability ~= nil then
		local stack_limit = grow_ability:GetSpecialValueFor( "stack_limit" )

		if currentStacks+stacks>=stack_limit then
			local point = target:GetAbsOrigin()
			local team = target:GetTeam()
			local player = target:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local name	= ""
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_ursa_veteran" 	then name = "npc_dota_ursa_myth" 
			elseif 		target:GetUnitName() == "npc_dota_satyr_veteran" 	then name = "npc_dota_satyr_myth"
			end
			target:ForceKill(true)
			target:AddNoDraw()
			local unit = CreateUnitByName( name, point, true, nil, nil, team )
			unit:SetOwner(hero)
			unit:SetControllableByPlayer(player, true)
			unit:SetForwardVector(child_fw)
			
		end
	end	
	

	
end

-------------------------------------------
modifier_veteran_grow_water_2 = modifier_veteran_grow_water_2 or class({})
function modifier_veteran_grow_water_2:IsDebuff() return false end
function modifier_veteran_grow_water_2:IsBuff() return true end
function modifier_veteran_grow_water_2:IsHidden() return false end
function modifier_veteran_grow_water_2:IsPurgable() return false end
function modifier_veteran_grow_water_2:IsStunDebuff() return false end
function modifier_veteran_grow_water_2:RemoveOnDeath() return false end
-------------------------------------------
function modifier_veteran_grow_water_2:GetTexture() 
return "item_eggs" 
end


function modifier_veteran_grow_water_2:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		}
	return decFuns
end

function modifier_veteran_grow_water_2:OnCreated()
	self.value_bonus = self:GetAbility():GetSpecialValueFor("bonus_value")
end

function modifier_veteran_grow_water_2:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()*1
end
