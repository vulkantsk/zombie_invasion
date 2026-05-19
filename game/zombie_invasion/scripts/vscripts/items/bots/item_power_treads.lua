-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--

--[[	Author: zimberzimber
		Date:	5.2.2017	]]

LinkLuaModifier( "modifier_imba_power_treads_2", "items/bots/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )					-- Mega Treads passive item effect
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_00", "items/bots/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )	-- Mega Treads strength stat multiplier
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_01", "items/bots/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )	-- Mega Treads agility stat multiplier
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_02", "items/bots/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )	-- Mega Treads intelligence stat multiplier
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_03", "items/bots/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------

if item_power_treads_2 == nil then item_power_treads_2 = class({}) end
function item_power_treads_2:GetBehavior() return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET end

function item_power_treads_2:GetIntrinsicModifierName()
	return "modifier_imba_power_treads_2"
end

function item_power_treads_2:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		if not caster:IsHero() or caster:IsClone() then return end

		-- Switch tread attribute
		local modifiers = caster:FindAllModifiersByName("modifier_imba_power_treads_2")
		for _,modifier in pairs(modifiers) do
			if modifier:GetAbility() == self then
				local state = modifier:GetStackCount()
				modifier:SetStackCount((state - 1 + DOTA_ATTRIBUTE_MAX) % DOTA_ATTRIBUTE_MAX)
				self.state = state
				break
			end
		end

		-- Remove stat multiplier modifiers (they get reapplied in the item modifier if relevant)
		for i = 0,3 do
			local mod = caster:FindModifierByName("modifier_imba_mega_treads_stat_multiplier_0"..i)
			if mod then caster:RemoveModifierByName("modifier_imba_mega_treads_stat_multiplier_0"..i) end
		end
 
	end
end

function item_power_treads_2:GetAbilityTextureName()
	if IsClient() then
		local caster = self:GetCaster()
		if not caster:IsHero() or not self.state then return "item_imba_power_treads" end

		return "item_imba_mega_treads_"..self.state
	end
end

-----------------------------------------------------------------------------------------------------------
--	Item Modifier - Movement speed and stat bonus (stacks responsible for texture and stat bonus choice)
-----------------------------------------------------------------------------------------------------------
if modifier_imba_power_treads_2 == nil then modifier_imba_power_treads_2 = class({}) end
function modifier_imba_power_treads_2:IsHidden() return true end
function modifier_imba_power_treads_2:IsDebuff() return false end
function modifier_imba_power_treads_2:IsPurgable() return false end
function modifier_imba_power_treads_2:RemoveOnDeath() return false end
function modifier_imba_power_treads_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_power_treads_2:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_imba_power_treads_2:OnCreated()
	if IsServer() then
		if self:GetParent():IsClone() then return end
		if self:GetParent():IsHero() then
			local ability = self:GetAbility()
			local parent = self:GetParent()

			if parent:IsRealHero() then
				self:StartIntervalThink(0.2)
			else
				Timers:CreateTimer(FrameTime(), function()	-- Timer because Valve decided that modifiers should be applied before items are added
					local ownerFinder = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH , DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER , false)
					for _,hero in pairs(ownerFinder) do
						if hero:GetName() == parent:GetName() then
							for i = 0,5 do
								local hero_item = hero:GetItemInSlot(i)
								if hero_item and hero_item:GetName() == "item_power_treads_2" then
									local illusion_item = parent:GetItemInSlot(i)
									if illusion_item == self:GetAbility() then
										local state = (hero_item.state - 1 + DOTA_ATTRIBUTE_MAX) % DOTA_ATTRIBUTE_MAX
										illusion_item.state = state
										self:SetStackCount(state)
										ability.state = state
										local healthPcnt = hero:GetHealthPercent()/100
										local manaPcnt = hero:GetManaPercent()/100

										local maxHealth = parent:GetMaxHealth()
										local maxMana = parent:GetMaxMana()

										parent:SetHealth(maxHealth*healthPcnt)
										parent:SetMana(maxMana*manaPcnt)
										break
									end
								end
							end
							break
						end
					end
					self:StartIntervalThink(0.2)
				end)
			end
		end
	end
	if IsClient() then
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_imba_power_treads_2:OnIntervalThink()
	if IsClient() then
		local state = self:GetStackCount()
		local ability = self:GetAbility()
		if not ability then
			return nil
		end

		ability.state = state

	elseif IsServer() then
		local state = self:GetStackCount()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if not parent:IsRealHero() then return end

		if not parent:HasModifier("modifier_imba_mega_treads_stat_multiplier_0"..state) then
			parent:AddNewModifier(parent, ability, "modifier_imba_mega_treads_stat_multiplier_0"..state, {})
		end
	end
end

function modifier_imba_power_treads_2:OnDestroy()
	if IsServer() then
		for i = 0,3 do
			local parent = self:GetParent()
			parent:RemoveModifierByName("modifier_imba_mega_treads_stat_multiplier_0"..i)
		end
	end
end

function modifier_imba_power_treads_2:GetModifierMoveSpeedBonus_Special_Boots()
	local ability = self:GetAbility()
	local speed_bonus = ability:GetSpecialValueFor("bonus_movement_speed")
	return speed_bonus
end

function modifier_imba_power_treads_2:GetModifierBonusStats_Strength()
	if self:GetStackCount() ~= DOTA_ATTRIBUTE_STRENGTH then return end

	local parent = self:GetParent()
	if not parent:IsHero() or parent:IsClone() then return end

	local ability = self:GetAbility()
	local stat_bonus = ability:GetSpecialValueFor("bonus_stat")
	return stat_bonus
end

function modifier_imba_power_treads_2:GetModifierBonusStats_Agility()
	if self:GetStackCount() ~= DOTA_ATTRIBUTE_AGILITY then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() or parent:IsClone() then return end

	local stat_bonus = ability:GetSpecialValueFor("bonus_stat")
	return stat_bonus
end

function modifier_imba_power_treads_2:GetModifierBonusStats_Intellect()
	if self:GetStackCount() ~= DOTA_ATTRIBUTE_INTELLECT then return end

	local parent = self:GetParent()
	if not parent:IsHero() or parent:IsClone() then return end

	local ability = self:GetAbility()
	local stat_bonus = ability:GetSpecialValueFor("bonus_stat")
	return stat_bonus
end

function modifier_imba_power_treads_2:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	local bonus_attackspeed = ability:GetSpecialValueFor("bonus_attackspeed")
	return bonus_attackspeed
end


-----------------------------------------------------------------------------------------------------------
--	Strength tenacity bonus modifier
-----------------------------------------------------------------------------------------------------------
if modifier_imba_mega_treads_stat_multiplier_00 == nil then modifier_imba_mega_treads_stat_multiplier_00 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_00:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_00:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_00:IsPurgable() return false end
function modifier_imba_mega_treads_stat_multiplier_00:RemoveOnDeath() return false end

function modifier_imba_mega_treads_stat_multiplier_00:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
	return funcs
end


function modifier_imba_mega_treads_stat_multiplier_00:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("str_mode_resist")
end


-----------------------------------------------------------------------------------------------------------
--	Agility evasion bonus modifier
-----------------------------------------------------------------------------------------------------------
if modifier_imba_mega_treads_stat_multiplier_01 == nil then modifier_imba_mega_treads_stat_multiplier_01 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_01:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_01:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_01:IsPurgable() return false end
function modifier_imba_mega_treads_stat_multiplier_01:RemoveOnDeath() return false end

function modifier_imba_mega_treads_stat_multiplier_01:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end
 


-----------------------------------------------------------------------------------------------------------
--	Intelliegence cast range bonus modifier
-----------------------------------------------------------------------------------------------------------
if modifier_imba_mega_treads_stat_multiplier_02 == nil then modifier_imba_mega_treads_stat_multiplier_02 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_02:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_02:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_02:IsPurgable() return false end
function modifier_imba_mega_treads_stat_multiplier_02:RemoveOnDeath() return false end

function modifier_imba_mega_treads_stat_multiplier_02:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
	return funcs
end

function modifier_imba_mega_treads_stat_multiplier_02:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("int_mode_amp")
end

if modifier_imba_mega_treads_stat_multiplier_03 == nil then modifier_imba_mega_treads_stat_multiplier_03 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_03:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_03:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_03:IsPurgable() return false end
function modifier_imba_mega_treads_stat_multiplier_03:RemoveOnDeath() return false end

function modifier_imba_mega_treads_stat_multiplier_03:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
	return funcs
end

function modifier_imba_mega_treads_stat_multiplier_03:GetModifierIncomingPhysicalDamageConstant()
	return self:GetAbility():GetSpecialValueFor("all_mode_inc")
end

function modifier_imba_mega_treads_stat_multiplier_03:GetModifierBonusStats_Strength()
	

	local parent = self:GetParent()
	

	local ability = self:GetAbility()
	local stats_bonus = ability:GetSpecialValueFor("bonus_stat_all")
	return stats_bonus
end

function modifier_imba_mega_treads_stat_multiplier_03:GetModifierBonusStats_Agility()
	

	local ability = self:GetAbility()
	local parent = self:GetParent()
	

	local stats_bonus = ability:GetSpecialValueFor("bonus_stat_all")
	return stats_bonus
end

function modifier_imba_mega_treads_stat_multiplier_03:GetModifierBonusStats_Intellect()
	

	local parent = self:GetParent()
	

	local ability = self:GetAbility()
	local stats_bonus = ability:GetSpecialValueFor("bonus_stat_all")
	return stats_bonus
end
