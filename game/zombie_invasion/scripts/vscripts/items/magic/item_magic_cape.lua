item_magic_cape = item_magic_cape or class({})
item_magic_cape_2 = item_magic_cape_2 or class({})
item_magic_cape_3 = item_magic_cape_3 or class({})
LinkLuaModifier("modifier_magic_cape_passive", "items/magic/item_magic_cape", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_cape_debuff_aura_modifier", "items/magic/item_magic_cape", LUA_MODIFIER_MOTION_NONE)
  
LinkLuaModifier("modifier_magic_cape_passive_2", "items/magic/item_magic_cape", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_cape_debuff_aura_modifier_2", "items/magic/item_magic_cape", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_magic_cape_passive_3", "items/magic/item_magic_cape", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_cape_debuff_aura_modifier_3", "items/magic/item_magic_cape", LUA_MODIFIER_MOTION_NONE)
 

 

function item_magic_cape:GetAOERadius()
	return self:GetSpecialValueFor("debuff_radius")
end

function item_magic_cape:GetIntrinsicModifierName()
	return "modifier_magic_cape_passive"
end

function item_magic_cape_2:GetAOERadius()
	return self:GetSpecialValueFor("debuff_radius")
end

function item_magic_cape_2:GetIntrinsicModifierName()
	return "modifier_magic_cape_passive_2"
end

function item_magic_cape_3:GetAOERadius()
	return self:GetSpecialValueFor("debuff_radius")
end

function item_magic_cape_3:GetIntrinsicModifierName()
	return "modifier_magic_cape_passive_3"
end

--- ACTIVE DEBUFF MODIFIER
 

------------------------------
--- PASSIVE STAT/BUFF AURA ---
------------------------------
modifier_magic_cape_passive = modifier_magic_cape_passive or class({})

-- Modifier properties

function modifier_magic_cape_passive:IsHidden()		return true end
function modifier_magic_cape_passive:IsPurgable()		return false end
function modifier_magic_cape_passive:RemoveOnDeath()	return false end
function modifier_magic_cape_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_magic_cape_passive:IsAura() return true end

function modifier_magic_cape_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_int              =   ability:GetSpecialValueFor("bonus_int")
		self.bonus_str              =   ability:GetSpecialValueFor("bonus_str")
		self.bonus_agil              =   ability:GetSpecialValueFor("bonus_agil")
 		self.magic_resist              =   ability:GetSpecialValueFor("magic_resist")  
 		self.mana_regen              =   ability:GetSpecialValueFor("mana_regen")
 
	end
end

-- Various stat bonuses
function modifier_magic_cape_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

-- Stats
function modifier_magic_cape_passive:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_magic_cape_passive:GetModifierBonusStats_Agility() return self.bonus_agil end
function modifier_magic_cape_passive:GetModifierBonusStats_Strength() return self.bonus_str end

 
function modifier_magic_cape_passive:GetModifierConstantManaRegen() return self.mana_regen end  
  
--- DEBUFF AURA  
function modifier_magic_cape_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_magic_cape_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_magic_cape_passive:GetModifierAura()
	return "modifier_magic_cape_debuff_aura_modifier"
end

function modifier_magic_cape_passive:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("debuff_radius")
end

 

--- AURA DEBUFF MODIFIER
modifier_magic_cape_debuff_aura_modifier = modifier_magic_cape_debuff_aura_modifier or class({})

-- Modifier properties
function modifier_magic_cape_debuff_aura_modifier:IsDebuff() return true end
function modifier_magic_cape_debuff_aura_modifier:IsHidden() return false end
function modifier_magic_cape_debuff_aura_modifier:IsPurgable() return false end

function modifier_magic_cape_debuff_aura_modifier:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.aura_resist    =   self:GetAbility():GetSpecialValueFor("aura_resist")
end
function modifier_magic_cape_debuff_aura_modifier:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_magic_cape_debuff_aura_modifier:GetModifierMagicalResistanceBonus()
	return self.aura_resist
end

function modifier_magic_cape_debuff_aura_modifier:GetTexture()
	return  "item_dis_magic"
end




modifier_magic_cape_passive_2 = modifier_magic_cape_passive_2 or class({})

-- Modifier properties

function modifier_magic_cape_passive_2:IsHidden()		return true end
function modifier_magic_cape_passive_2:IsPurgable()		return false end
function modifier_magic_cape_passive_2:RemoveOnDeath()	return false end
function modifier_magic_cape_passive_2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_magic_cape_passive_2:IsAura() return true end

function modifier_magic_cape_passive_2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_int              =   ability:GetSpecialValueFor("bonus_int")
		self.bonus_str              =   ability:GetSpecialValueFor("bonus_str")
		self.bonus_agil              =   ability:GetSpecialValueFor("bonus_agil")
 		self.magic_resist              =   ability:GetSpecialValueFor("magic_resist")  
 		self.mana_regen              =   ability:GetSpecialValueFor("mana_regen")
 
	end
end

-- Various stat bonuses
function modifier_magic_cape_passive_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

-- Stats
function modifier_magic_cape_passive_2:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_magic_cape_passive_2:GetModifierBonusStats_Agility() return self.bonus_agil end
function modifier_magic_cape_passive_2:GetModifierBonusStats_Strength() return self.bonus_str end

 
function modifier_magic_cape_passive_2:GetModifierConstantManaRegen() return self.mana_regen end  
  
--- DEBUFF AURA  
function modifier_magic_cape_passive_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_magic_cape_passive_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_magic_cape_passive_2:GetModifierAura()
	return "modifier_magic_cape_debuff_aura_modifier_2"
end

function modifier_magic_cape_passive_2:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("debuff_radius")
end

 

--- AURA DEBUFF MODIFIER
modifier_magic_cape_debuff_aura_modifier_2 = modifier_magic_cape_debuff_aura_modifier_2 or class({})

-- Modifier properties
function modifier_magic_cape_debuff_aura_modifier_2:IsDebuff() return true end
function modifier_magic_cape_debuff_aura_modifier_2:IsHidden() return false end
function modifier_magic_cape_debuff_aura_modifier_2:IsPurgable() return false end

function modifier_magic_cape_debuff_aura_modifier_2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.aura_resist    =   self:GetAbility():GetSpecialValueFor("aura_resist")
end
function modifier_magic_cape_debuff_aura_modifier_2:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_magic_cape_debuff_aura_modifier_2:GetModifierMagicalResistanceBonus()
	return self.aura_resist
end

function modifier_magic_cape_debuff_aura_modifier_2:GetTexture()
	return  "item_dis_magic"
end



 



modifier_magic_cape_passive_3 = modifier_magic_cape_passive_3 or class({})

-- Modifier properties

function modifier_magic_cape_passive_3:IsHidden()		return true end
function modifier_magic_cape_passive_3:IsPurgable()		return false end
function modifier_magic_cape_passive_3:RemoveOnDeath()	return false end
function modifier_magic_cape_passive_3:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_magic_cape_passive_3:IsAura() return true end

function modifier_magic_cape_passive_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_int              =   ability:GetSpecialValueFor("bonus_int")
		self.bonus_str              =   ability:GetSpecialValueFor("bonus_str")
		self.bonus_agil              =   ability:GetSpecialValueFor("bonus_agil")
 		self.magic_resist              =   ability:GetSpecialValueFor("magic_resist")  
 		self.mana_regen              =   ability:GetSpecialValueFor("mana_regen")
 
	end
end

-- Various stat bonuses
function modifier_magic_cape_passive_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

-- Stats
function modifier_magic_cape_passive_3:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_magic_cape_passive_3:GetModifierBonusStats_Agility() return self.bonus_agil end
function modifier_magic_cape_passive_3:GetModifierBonusStats_Strength() return self.bonus_str end

 
function modifier_magic_cape_passive_3:GetModifierConstantManaRegen() return self.mana_regen end  
  
--- DEBUFF AURA  
function modifier_magic_cape_passive_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_magic_cape_passive_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_magic_cape_passive_3:GetModifierAura()
	return "modifier_magic_cape_debuff_aura_modifier_3"
end

function modifier_magic_cape_passive_3:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("debuff_radius")
end

 

--- AURA DEBUFF MODIFIER
modifier_magic_cape_debuff_aura_modifier_3 = modifier_magic_cape_debuff_aura_modifier_3 or class({})

-- Modifier properties
function modifier_magic_cape_debuff_aura_modifier_3:IsDebuff() return true end
function modifier_magic_cape_debuff_aura_modifier_3:IsHidden() return false end
function modifier_magic_cape_debuff_aura_modifier_3:IsPurgable() return false end

function modifier_magic_cape_debuff_aura_modifier_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.aura_resist    =   self:GetAbility():GetSpecialValueFor("aura_resist")
end
function modifier_magic_cape_debuff_aura_modifier_3:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_magic_cape_debuff_aura_modifier_3:GetModifierMagicalResistanceBonus()
	return self.aura_resist
end

function modifier_magic_cape_debuff_aura_modifier_3:GetTexture()
	return  "item_dis_magic"
end



 


 


 

 