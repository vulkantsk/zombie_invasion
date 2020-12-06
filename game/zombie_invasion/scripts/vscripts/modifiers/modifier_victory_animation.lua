modifier_victory_animation = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}end,
})

function modifier_victory_animation:GetPriority()
	return MODIFIER_PRIORITY_LOW
end

function modifier_victory_animation:GetOverrideAnimation()
	return ACT_DOTA_VICTORY
end
