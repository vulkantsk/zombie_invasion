modifier_portal_unit_vision = {}

function modifier_portal_unit_vision:IsHidden()
	return true
end

function modifier_portal_unit_vision:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_portal_unit_vision:GetModifierProvidesFOWVision()
	return 1
end