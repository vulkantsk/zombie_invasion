 

if modifier_lifesteal == nil then modifier_lifesteal = class({}) end
function modifier_lifesteal:IsDebuff() return false end
function modifier_lifesteal:IsPurgable() return false end
function modifier_lifesteal:IsHidden() return true end
function modifier_lifesteal:RemoveOnDeath() return false end
 function modifier_lifesteal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_lifesteal:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
   
 
end

-- Possible projectile change
function modifier_lifesteal:OnDestroy()
 
end
 

-- Lifesteal
function modifier_lifesteal:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("lifesteal_pct") end

-- Bonuses (does not stack with Vladmir's Blood)
function modifier_lifesteal:DeclareFunctions()
	return {
 
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

 
 
 

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_lifesteal:OnTakeDamage( keys )
	if  keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
 
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
		 
			keys.attacker:Heal(keys.damage * self:GetAbility():GetSpecialValueFor("lifesteal_pct") * 0.01, keys.attacker)
		end
	end
end


