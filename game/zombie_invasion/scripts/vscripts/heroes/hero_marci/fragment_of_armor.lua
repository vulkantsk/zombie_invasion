marci_fragment_of_armor = class({})
LinkLuaModifier("modifier_marci_fragment_of_armor", "heroes/hero_marci/fragment_of_armor.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	function marci_fragment_of_armor:OnToggle()
		local caster = self:GetCaster()
		if self:GetToggleState() then
			caster:AddNewModifier(caster, self, "modifier_marci_fragment_of_armor", nil)
		else
			caster:RemoveModifierByName("modifier_marci_fragment_of_armor")
		end
	end
end


modifier_marci_fragment_of_armor = class({
	IsHidden = function() return true end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	GetEffectName = function() return "maps/backgrounds/models/dragon_knight_persona/particles/dk_persona/slyrak_foreground_fire_base.vpcf" end,
})

function modifier_marci_fragment_of_armor:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

if IsServer() then
	function marci_sara_fragment_of_armor:OnTakeDamage(keys)
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
		end
	end
end
