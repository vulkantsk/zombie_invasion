sara_fragment_of_armor = class({})
LinkLuaModifier("modifier_sara_fragment_of_armor", "heroes/hero_sara/fragment_of_armor.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	function sara_fragment_of_armor:OnToggle()
		local caster = self:GetCaster()
		if self:GetToggleState() then
			caster:AddNewModifier(caster, self, "modifier_sara_fragment_of_armor", nil)
		else
			caster:RemoveModifierByName("modifier_sara_fragment_of_armor")
		end
	end
end


modifier_sara_fragment_of_armor = class({
	IsHidden = function() return true end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	GetEffectName = function() return "particles/arena/units/heroes/hero_sara/fragment_of_armor.vpcf" end,
})

function modifier_sara_fragment_of_armor:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

if IsServer() then
	function modifier_sara_fragment_of_armor:OnTakeDamage(keys)
		local unit = self:GetParent()
		local ability = self:GetAbility()
		if unit == keys.unit and
			IsValidEntity(ability) and
			unit:IsAlive() and
			not unit:IsIllusion() and
			unit:HasScepter() and
			not unit:PassivesDisabled() and
			unit.GetEnergy and
			ability:GetToggleState() and
			unit:GetEnergy() >= (keys.damage * ability:GetAbilitySpecial("blocked_damage_pct") * 0.01) / ability:GetAbilitySpecial("damage_per_energy") then
			SimpleDamageReflect(unit, keys.attacker, keys.damage * ability:GetSpecialValueFor("reflected_damage_pct_scepter") * 0.01, keys.damage_flags, self, keys.damage_type)
			print("12312suck321")
		end
	end
end

modifier_sara_fragment_of_armor = {
		multiplier = function(attacker, victim, inflictor, damage)
			local sara_fragment_of_armor = victim:FindAbilityByName("sara_fragment_of_armor")
			
				local blocked_damage_pct = sara_fragment_of_armor:GetAbilitySpecial("blocked_damage_pct") * 0.01
				local mana_needed = (damage * blocked_damage_pct) / sara_fragment_of_armor:GetAbilitySpecial("damage_per_energy")
				if victim:GetEnergy() >= mana_needed then
					victim:EmitSound("Hero_Medusa.ManaShield.Proc")
					victim:ModifyEnergy(-mana_needed)
					local particleName = "particles/arena/units/heroes/hero_sara/fragment_of_armor_impact.vpcf"
					local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, victim)
					ParticleManager:SetParticleControl(particle, 0, victim:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
					return 1 - blocked_damage_pct
				end

		end
	}	