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
dragon_knight_dragon_blood_lua = class({})
 
LinkLuaModifier("modifier_triple_blow_passive", "heroes/hero_skeleton_king/stronger/dragon_knight_dragon_blood_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_triple_blow_haste", "heroes/hero_skeleton_king/stronger/dragon_knight_dragon_blood_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
 
 
-------------------------------------------

 

-------------------------------------------
function dragon_knight_dragon_blood_lua:GetIntrinsicModifierName()
    return "modifier_triple_blow_passive"
end

-------------------------------------------
modifier_triple_blow_passive = class({})
function modifier_triple_blow_passive:IsDebuff() return false end
function modifier_triple_blow_passive:IsHidden() return true end
function modifier_triple_blow_passive:IsPermanent() return true end
function modifier_triple_blow_passive:IsPurgable() return false end
function modifier_triple_blow_passive:IsPurgeException() return false end
function modifier_triple_blow_passive:IsStunDebuff() return false end
function modifier_triple_blow_passive:RemoveOnDeath() return false end







function modifier_triple_blow_passive:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "bonus_speed_atack" )	
	self.resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" )	
end

function modifier_triple_blow_passive:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "bonus_speed_atack" )	
	self.resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" )	
end
 
function modifier_triple_blow_passive:OnRemoved()
end

function modifier_triple_blow_passive:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
 

 




function modifier_triple_blow_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}
    return decFuns
end

function modifier_triple_blow_passive:GetModifierStatusResistance()
	if not self:GetParent():PassivesDisabled() then
		return self.resist
	end
end

function modifier_triple_blow_passive:GetModifierBaseAttackTimeConstant()
	if not self:GetParent():PassivesDisabled() then
		return self.speed_atack
	end
end

function modifier_triple_blow_passive:GetModifierBonusStats_Strength()
	if not self:GetParent():PassivesDisabled() then
		return self.strength
	end
end

function modifier_triple_blow_passive:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.armor
	end
end



function modifier_triple_blow_passive:OnAttackStart(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
	if item then
		if (keys.attacker == parent) and (parent:IsRealHero() or parent:IsClone()) then
			if item:IsCooldownReady() then
				parent:AddNewModifier(parent, item, "modifier_triple_blow_haste", {})
				item:StartCooldown(item:GetCooldown(item:GetLevel()))		
			end
		end
	end
end





-------------------------------------------
modifier_triple_blow_haste = class({})
function modifier_triple_blow_haste:IsDebuff() return false end
function modifier_triple_blow_haste:IsHidden() return true end
function modifier_triple_blow_haste:IsPurgable() return false end
function modifier_triple_blow_haste:IsPurgeException() return false end
function modifier_triple_blow_haste:IsStunDebuff() return false end
function modifier_triple_blow_haste:RemoveOnDeath() return true end
-------------------------------------------
function modifier_triple_blow_haste:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if item then
		local current_speed = self.parent:GetIncreasedAttackSpeed()
		current_speed = current_speed * 2

		local max_hits = item:GetSpecialValueFor("max_hits")
		self:SetStackCount(max_hits)
		self.attack_speed_buff = math.max(item:GetSpecialValueFor("attack_speed_buff"), current_speed)
	end
end

function modifier_triple_blow_haste:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
    return decFuns
end

function modifier_triple_blow_haste:OnAttack(keys)
	if self.parent == keys.attacker then
		
		-- If the target is a deflector, do nothing
	
		if self:GetStackCount() == 1 then
			self:Destroy()
			return nil
		end

		self:DecrementStackCount()
	end
end

function modifier_triple_blow_haste:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_buff
end
-------------------------------------------
