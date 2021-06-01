modifier_invasion_portal_veno_infest_caster = {}

function modifier_invasion_portal_veno_infest_caster:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true
	}
end

if IsClient() then
	return
end

function modifier_invasion_portal_veno_infest_caster:OnCreated()
	self:GetParent():AddNoDraw()
end

function modifier_invasion_portal_veno_infest_caster:OnDestroy()
	self:GetParent():RemoveNoDraw()
end