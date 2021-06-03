modifier_portal_unit_vision = {}

function modifier_portal_unit_vision:IsHidden()
	return true
end

function modifier_portal_unit_vision:CheckState()
	return { [MODIFIER_STATE_PROVIDES_VISION] = true }
end