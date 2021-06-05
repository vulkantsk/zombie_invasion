modifier_portal_wd_zombie_invul = {}

function modifier_portal_wd_zombie_invul:IsHidden()
	return true
end

function modifier_portal_wd_zombie_invul:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_portal_wd_zombie_invul:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_portal_wd_zombie_invul:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_portal_wd_zombie_invul:OnHealReceived()
	local parent = self:GetParent()

	if parent:GetHealth() == parent:GetMaxHealth() then
		local point = Entities:FindByName( nil, "final_point" ):GetAbsOrigin()
		parent:MoveToPositionAggressive( point )
		self:Destroy()
	end
end

function modifier_portal_wd_zombie_invul:OnDeath( data )
	if data.unit == self:GetCaster() then
		self:GetParent():Kill( nil, data.attacker )
	end
end