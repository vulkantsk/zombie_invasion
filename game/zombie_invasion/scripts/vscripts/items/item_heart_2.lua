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

-- Author: Shush
-- Date: 04/08/2017

item_heart_2 = item_heart_2 or class({})

LinkLuaModifier("modifier_item_heart_2", "items/item_heart_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_heart_2_unique", "items/item_heart_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_heart_2_aura_buff", "items/item_heart_2", LUA_MODIFIER_MOTION_NONE)

function item_heart_2:GetIntrinsicModifierName()
	return "modifier_item_heart_2"
end

function item_heart_2:GetCooldown(level)
	if self:GetCaster():IsRangedAttacker() then
		return self:GetSpecialValueFor("regen_cooldown_ranged")
	else
		return self:GetSpecialValueFor("regen_cooldown_melee")
	end
end


-- Stats modifier (stackable)
modifier_item_heart_2 = modifier_item_heart_2 or class({})

function modifier_item_heart_2:IsHidden() return true end
function modifier_item_heart_2:IsPurgable() return false end
function modifier_item_heart_2:IsDebuff() return false end
function modifier_item_heart_2:RemoveOnDeath() return false end
function modifier_item_heart_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_heart_2:OnCreated()
	-- Ability properties
	self.modifier_self = "modifier_item_heart_2"
	self.modifier_unique = "modifier_item_heart_2_unique"

	-- Ability specials
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")	
	self.bonus_all = self:GetAbility():GetSpecialValueFor("bonus_all")

	if IsServer() then
		-- If this is the first heart, add the unique modifier
		if not self:GetCaster():HasModifier(self.modifier_unique) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_unique, {})
		end
	end
end

function modifier_item_heart_2:OnDestroy()
	if IsServer() then
		-- if this is the last heart, remove the unique modifier
		if not self:GetCaster():HasModifier(self.modifier_self) then
			self:GetCaster():RemoveModifierByName(self.modifier_unique)
		end
	end
end

function modifier_item_heart_2:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
	return decFuncs
end

function modifier_item_heart_2:GetModifierBonusStats_Strength()
	return self.bonus_strength + self.bonus_all
end

function modifier_item_heart_2:GetModifierBonusStats_Intellect()
	return self.bonus_all
end

function modifier_item_heart_2:GetModifierBonusStats_Agility()
	return self.bonus_all
end

function modifier_item_heart_2:GetModifierHealthBonus()
	return self.bonus_health
end
----------------------------------------
----------------------------------------
item_heart_2_2 = class(item_heart_2)

-- Strength aura modifier, regenerations
modifier_item_heart_2_unique = modifier_item_heart_2_unique or class({})

function modifier_item_heart_2_unique:IsHidden() return true end
function modifier_item_heart_2_unique:IsPurgable() return false end
function modifier_item_heart_2_unique:IsDebuff() return false end
function modifier_item_heart_2_unique:RemoveOnDeath() return false end

function modifier_item_heart_2_unique:OnCreated()
	-- Ability properties
	-- Ability specials	
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
	self.base_regen = self:GetAbility():GetSpecialValueFor("base_regen")
	self.noncombat_regen = self:GetAbility():GetSpecialValueFor("noncombat_regen")

	
end

function modifier_item_heart_2_unique:IsAura() return true end
function modifier_item_heart_2_unique:GetAuraRadius() return self.aura_radius end
function modifier_item_heart_2_unique:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_heart_2_unique:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_heart_2_unique:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_item_heart_2_unique:GetModifierAura() return "modifier_item_heart_2_aura_buff" end

function modifier_item_heart_2_unique:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		--MODIFIER_EVENT_ON_TAKEDAMAGE
		}

	return decFuncs
end

function modifier_item_heart_2_unique:GetModifierHealthRegenPercentage()


	return self.base_regen
end

function modifier_item_heart_2_unique:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker

		-- Only apply if the unit taking damage is the caster
		if unit == self:GetCaster() then
			-- If the attacker wasn't an enemy hero or Roshan, do nothing
			if attacker:IsHero() or IsRoshan(attacker) then
				if attacker == unit then
					-- don't trigger cd with self damage
					return
				end
				self:GetAbility():StartCooldown(self.cooldown)
			end
		end
	end
end

--[[
function modifier_imba_blink_dagger_handler:OnTakeDamage( keys )
	local ability = self:GetAbility()
	local blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")

	local parent = self:GetParent()					-- Modifier carrier
	local unit = keys.unit							-- Who took damage

	if parent == unit then
		-- Custom function from funcs.lua
		if IsHeroDamage(keys.attacker, keys.damage) then
			if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
				ability:StartCooldown(blink_damage_cooldown)
			end
		end
	end
end
--]]

-- Aura buff
modifier_item_heart_2_aura_buff = modifier_item_heart_2_aura_buff or class({})

function modifier_item_heart_2_aura_buff:GetEffectName()
	return "particles/items_fx/armlet_b.vpcf" 
end

function modifier_item_heart_2_aura_buff:OnCreated()
	-- Ability specials	
	self.aura_str = self:GetAbility():GetSpecialValueFor("aura_str")	
end

function modifier_item_heart_2_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFuncs
end

function modifier_item_heart_2_aura_buff:GetModifierBonusStats_Strength()
	return self.aura_str
end

