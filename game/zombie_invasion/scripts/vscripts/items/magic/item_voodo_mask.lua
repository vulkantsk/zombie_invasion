item_voodo_mask = item_voodo_mask or class({})
item_voodo_mask_2 = item_voodo_mask_2 or class({})
item_voodo_mask_3 = item_voodo_mask_3 or class({})
 
LinkLuaModifier("modifier_voodo_mask_passive", "items/magic/item_voodo_mask", LUA_MODIFIER_MOTION_NONE)
 
 

 

function item_voodo_mask:GetIntrinsicModifierName()
	return "modifier_voodo_mask_passive"
end

function item_voodo_mask_2:GetIntrinsicModifierName()
	return "modifier_voodo_mask_passive"
end
function item_voodo_mask_3:GetIntrinsicModifierName()
	return "modifier_voodo_mask_passive"
end
 
 

------------------------------
--- PASSIVE STAT/BUFF AURA ---
------------------------------
modifier_voodo_mask_passive = modifier_voodo_mask_passive or class({})

-- Modifier properties

function modifier_voodo_mask_passive:IsHidden()		return true end
function modifier_voodo_mask_passive:IsPurgable()		return false end
function modifier_voodo_mask_passive:RemoveOnDeath()	return false end
function modifier_voodo_mask_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

 

function modifier_voodo_mask_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_mana              =   ability:GetSpecialValueFor("bonus_mana")
		self.bonus_health              =   ability:GetSpecialValueFor("bonus_health")
 		self.mana_regen              =   ability:GetSpecialValueFor("mana_regen")
 
	end
end

-- Various stat bonuses
function modifier_voodo_mask_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

-- Stats
 function modifier_voodo_mask_passive:GetModifierHealthBonus()
     return self.bonus_health
 end

 function modifier_voodo_mask_passive:GetModifierManaBonus()
     return  self.bonus_mana
 end

  function modifier_voodo_mask_passive:GetModifierConstantManaRegen()
     return self.mana_regen
 end

 

 function modifier_voodo_mask_passive:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		-- Spell lifesteal handler
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			-- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
			-- This is EXTREMELY rough because I am not aware of any functions that can explicitly give you the incoming/outgoing damage of an illusion, or to give you the "displayed" damage when you're hitting illusions, which show numbers as if you were hitting a non-illusion.
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
				elseif keys.damage_type == DAMAGE_TYPE_PURE then
					keys.damage = keys.original_damage
				end
			end
			
			if keys.unit:IsCreep() then
			    local multi = self.multiputi or 1
 
				keys.attacker:Heal(math.max(keys.damage, 0) * (self:GetAbility():GetSpecialValueFor("all_lifesteal") * multi) * 0.01, keys.attacker)
			else
			    local multi = self.multiputi or 1
	 
				keys.attacker:Heal(math.max(keys.damage, 0) * (self:GetAbility():GetSpecialValueFor("all_lifesteal") * multi) * 0.01, keys.attacker)				
			end
		end
	end
end