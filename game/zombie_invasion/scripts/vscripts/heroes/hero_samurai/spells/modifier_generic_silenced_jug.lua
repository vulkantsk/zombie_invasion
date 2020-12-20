modifier_generic_silenced_jug = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_silenced_jug:IsHidden()
	return true
end

function modifier_generic_silenced_jug:IsDebuff()
	return false
end

function modifier_generic_silenced_jug:IsStunDebuff()
	return false
end

function modifier_generic_silenced_jug:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_generic_silenced_jug:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics and animations
 