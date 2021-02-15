if item_imba_vladmir == nil then item_imba_vladmir = class({}) end
if item_imba_vladmir_2 == nil then item_imba_vladmir_2 = class({}) end
if item_imba_vladmir_3 == nil then item_imba_vladmir_3 = class({}) end
LinkLuaModifier( "modifier_item_imba_vladmir", "items/support/item_vladmir", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_vladmir_aura", "items/support/item_vladmir", LUA_MODIFIER_MOTION_NONE )			-- Aura buff

LinkLuaModifier( "modifier_item_imba_vladmir_2", "items/support/item_vladmir", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_vladmir_aura_2", "items/support/item_vladmir", LUA_MODIFIER_MOTION_NONE )			-- Aura buff

LinkLuaModifier( "modifier_item_imba_vladmir_3", "items/support/item_vladmir", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_vladmir_aura_3", "items/support/item_vladmir", LUA_MODIFIER_MOTION_NONE )			-- Aura buff

 

function item_imba_vladmir:GetAOERadius()
	return self:GetSpecialValueFor("aura_radius")
end

function item_imba_vladmir:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir" end

function item_imba_vladmir_2:GetAOERadius()
	return self:GetSpecialValueFor("aura_radius")
end

function item_imba_vladmir_2:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir_2" end

function item_imba_vladmir_3:GetAOERadius()
	return self:GetSpecialValueFor("aura_radius")
end

function item_imba_vladmir_3:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir_3" end
-----------------------------------------------------------------------------------------------------------
--	Vladmir's offering owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir == nil then modifier_item_imba_vladmir = class({}) end

function modifier_item_imba_vladmir:IsHidden()		return true end
function modifier_item_imba_vladmir:IsPurgable()		return false end
function modifier_item_imba_vladmir:RemoveOnDeath()	return false end
function modifier_item_imba_vladmir:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Attribute bonuses
function modifier_item_imba_vladmir:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir:IsAura()					return true end
function modifier_item_imba_vladmir:IsAuraActiveOnDeath() 		return false end

function modifier_item_imba_vladmir:GetAuraRadius()				if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("aura_radius") end end
function modifier_item_imba_vladmir:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_imba_vladmir:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_vladmir:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_vladmir:GetModifierAura()				return "modifier_item_imba_vladmir_aura" end
 

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_aura == nil then modifier_item_imba_vladmir_aura = class({}) end
function modifier_item_imba_vladmir_aura:IsDebuff() return false end
function modifier_item_imba_vladmir_aura:IsPurgable() return false end

 

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_aura:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_aura		= self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura			= self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura		= self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura	= self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.vampiric_aura		= self:GetAbility():GetSpecialValueFor("vampiric_aura")

 
end

-- Possible projectile change
function modifier_item_imba_vladmir_aura:OnDestroy()
 
end
 

-- Lifesteal
function modifier_item_imba_vladmir_aura:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("vampiric_aura") end

-- Bonuses (does not stack with Vladmir's Blood)
function modifier_item_imba_vladmir_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,

		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_imba_vladmir_aura:GetModifierBaseDamageOutgoing_Percentage()
			return self.damage_aura
end

function modifier_item_imba_vladmir_aura:OnTooltip()
			return self.vampiric_aura
end

function modifier_item_imba_vladmir_aura:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura end

function modifier_item_imba_vladmir_aura:GetModifierConstantHealthRegen()
			return self.hp_regen_aura
end

function modifier_item_imba_vladmir_aura:GetTexture()
			return  "item_vladmir"
end

function modifier_item_imba_vladmir_aura:GetModifierConstantManaRegen()
			return self.mana_regen_aura
end

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_item_imba_vladmir_aura:OnTakeDamage( keys )
	if  not keys.attacker:HasModifier("modifier_item_imba_vladmir_aura_2")  and  not keys.attacker:HasModifier("modifier_item_imba_vladmir_aura_3") and not keys.attacker:HasModifier("modifier_item_imba_vladmir_blood_aura") and not keys.attacker:HasModifier("modifier_custom_mechanics") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
 
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			keys.attacker:Heal(keys.damage * self.vampiric_aura * 0.01, keys.attacker)
		end
	end
end


















if modifier_item_imba_vladmir_2 == nil then modifier_item_imba_vladmir_2 = class({}) end

function modifier_item_imba_vladmir_2:IsHidden()		return true end
function modifier_item_imba_vladmir_2:IsPurgable()		return false end
function modifier_item_imba_vladmir_2:RemoveOnDeath()	return false end
function modifier_item_imba_vladmir_2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Attribute bonuses
function modifier_item_imba_vladmir_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_item_imba_vladmir_2:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end


 

function modifier_item_imba_vladmir_2:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_2:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_2:IsAura()					return true end
function modifier_item_imba_vladmir_2:IsAuraActiveOnDeath() 		return false end

function modifier_item_imba_vladmir_2:GetAuraRadius()				if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("aura_radius") end end
function modifier_item_imba_vladmir_2:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_imba_vladmir_2:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_vladmir_2:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_vladmir_2:GetModifierAura()				return "modifier_item_imba_vladmir_aura_2" end
 

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_aura_2 == nil then modifier_item_imba_vladmir_aura_2 = class({}) end
function modifier_item_imba_vladmir_aura_2:IsDebuff() return false end
function modifier_item_imba_vladmir_aura_2:IsPurgable() return false end

 

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_aura_2:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_aura		= self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura			= self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura		= self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura	= self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.vampiric_aura		= self:GetAbility():GetSpecialValueFor("vampiric_aura")

 
end

-- Possible projectile change
function modifier_item_imba_vladmir_aura_2:OnDestroy()
 
end
function modifier_item_imba_vladmir_aura_2:GetTexture()
    return "item_vladmir_2"
end
-- Lifesteal
function modifier_item_imba_vladmir_aura_2:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("vampiric_aura") end

-- Bonuses (does not stack with Vladmir's Blood)
function modifier_item_imba_vladmir_aura_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,

		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_imba_vladmir_aura_2:OnTooltip()
			return self.vampiric_aura
end

function modifier_item_imba_vladmir_aura_2:GetModifierBaseDamageOutgoing_Percentage()
			return self.damage_aura
end

function modifier_item_imba_vladmir_aura_2:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura end

function modifier_item_imba_vladmir_aura_2:GetModifierConstantHealthRegen()
			return self.hp_regen_aura
end

function modifier_item_imba_vladmir_aura_2:GetModifierConstantManaRegen()
			return self.mana_regen_aura
end

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_item_imba_vladmir_aura_2:OnTakeDamage( keys )
	if not keys.attacker:HasModifier("modifier_item_imba_vladmir_aura_3") and not keys.attacker:HasModifier("modifier_item_imba_vladmir_blood_aura") and not keys.attacker:HasModifier("modifier_custom_mechanics") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
 
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			keys.attacker:Heal(keys.damage * self.vampiric_aura * 0.01, keys.attacker)
		end
	end
end












if modifier_item_imba_vladmir_3 == nil then modifier_item_imba_vladmir_3 = class({}) end

function modifier_item_imba_vladmir_3:IsHidden()		return true end
function modifier_item_imba_vladmir_3:IsPurgable()		return false end
function modifier_item_imba_vladmir_3:RemoveOnDeath()	return false end
function modifier_item_imba_vladmir_3:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Attribute bonuses
function modifier_item_imba_vladmir_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_item_imba_vladmir_3:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_3:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_3:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_3:IsAura()					return true end
function modifier_item_imba_vladmir_3:IsAuraActiveOnDeath() 		return false end

function modifier_item_imba_vladmir_3:GetAuraRadius()				if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("aura_radius") end end
function modifier_item_imba_vladmir_3:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_imba_vladmir_3:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_vladmir_3:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_vladmir_3:GetModifierAura()				return "modifier_item_imba_vladmir_aura_3" end
 

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_aura_3 == nil then modifier_item_imba_vladmir_aura_3 = class({}) end
function modifier_item_imba_vladmir_aura_3:IsDebuff() return false end
function modifier_item_imba_vladmir_aura_3:IsPurgable() return false end

 

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_aura_3:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_aura		= self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura			= self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura		= self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura	= self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.vampiric_aura		= self:GetAbility():GetSpecialValueFor("vampiric_aura")

 
end

-- Possible projectile change
function modifier_item_imba_vladmir_aura_3:OnDestroy()
 
end

-- Lifesteal
function modifier_item_imba_vladmir_aura_3:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("vampiric_aura") end

-- Bonuses (does not stack with Vladmir's Blood)
function modifier_item_imba_vladmir_aura_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,

		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end


function modifier_item_imba_vladmir_aura_3:GetTexture()
    return "item_vladmir_3"
end

function modifier_item_imba_vladmir_aura_3:OnTooltip()
			return self.vampiric_aura
end

function modifier_item_imba_vladmir_aura_3:GetModifierBaseDamageOutgoing_Percentage()
			return self.damage_aura
end

function modifier_item_imba_vladmir_aura_3:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura end

function modifier_item_imba_vladmir_aura_3:GetModifierConstantHealthRegen()
			return self.hp_regen_aura
end

function modifier_item_imba_vladmir_aura_3:GetModifierConstantManaRegen()
			return self.mana_regen_aura
end

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_item_imba_vladmir_aura_3:OnTakeDamage( keys )
	if not keys.attacker:HasModifier("modifier_item_imba_vladmir_blood_aura") and not keys.attacker:HasModifier("modifier_custom_mechanics") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
 
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			keys.attacker:Heal(keys.damage * self.vampiric_aura * 0.01, keys.attacker)
		end
	end
end
