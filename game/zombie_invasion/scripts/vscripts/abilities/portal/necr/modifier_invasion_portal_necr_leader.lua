modifier_invasion_portal_necr_leader = {}

function modifier_invasion_portal_necr_leader:IsHidden()
	return true
end

function modifier_invasion_portal_necr_leader:IsAura()
	return true
end

function modifier_invasion_portal_necr_leader:GetAuraRadius()
	return self:GetAbility():GetCastRange( Vector(), nil )
end

function modifier_invasion_portal_necr_leader:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_invasion_portal_necr_leader:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_invasion_portal_necr_leader:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_invasion_portal_necr_leader:GetModifierAura()
	return "modifier_invasion_portal_necr_leader_aura"	
end