modifier_invasion_portal_necr_leader_aura = {}

function modifier_invasion_portal_necr_leader_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_invasion_portal_necr_leader_aura:GetModifierAttackSpeedBonus_Constant()
	return 20
end

function modifier_invasion_portal_necr_leader_aura:GetModifierPhysicalArmorBonus()
	return 4
end

function modifier_invasion_portal_necr_leader_aura:GetModifierPreAttack_BonusDamage()
	return 30
end