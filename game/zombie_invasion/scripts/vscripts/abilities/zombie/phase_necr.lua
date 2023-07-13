LinkLuaModifier("modifier_phase_necr_buff", "abilities/zombie/phase_necr", LUA_MODIFIER_MOTION_NONE)

phase_necr = class({})

function phase_necr:GetIntrinsicModifierName()
	return "modifier_phase_necr_buff"
end

modifier_phase_necr_buff = class({})

function modifier_phase_necr_buff:IsHidden()
	return false
end

function modifier_phase_necr_buff:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end
