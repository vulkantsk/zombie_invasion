-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_dragon_knight_dragon_blood_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dragon_knight_dragon_blood_lua:IsHidden()
	return true
end

function modifier_dragon_knight_dragon_blood_lua:IsDebuff()
	return false
end

function modifier_dragon_knight_dragon_blood_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dragon_knight_dragon_blood_lua:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "bonus_speed_atack" )	
	self.resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" )	
end

function modifier_dragon_knight_dragon_blood_lua:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "bonus_speed_atack" )	
	self.resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" )	
end
 
function modifier_dragon_knight_dragon_blood_lua:OnRemoved()
end

function modifier_dragon_knight_dragon_blood_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dragon_knight_dragon_blood_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

function modifier_dragon_knight_dragon_blood_lua:GetModifierStatusResistance()
	if not self:GetParent():PassivesDisabled() then
		return self.resist
	end
end

function modifier_dragon_knight_dragon_blood_lua:GetModifierBaseAttackTimeConstant()
	if not self:GetParent():PassivesDisabled() then
		return self.speed_atack
	end
end

function modifier_dragon_knight_dragon_blood_lua:GetModifierBonusStats_Strength()
	if not self:GetParent():PassivesDisabled() then
		return self.strength
	end
end

function modifier_dragon_knight_dragon_blood_lua:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.armor
	end
end