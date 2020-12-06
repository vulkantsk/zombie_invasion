LinkLuaModifier("modifier_pudge_death", "abilities/endgame/pudge_death", 0)

pudge_death = class({})

function pudge_death:OnSpellStart()
	local caster = self:GetCaster()
	
--	caster:StartGestureWithPlaybackRate(ACT_DOTA_DIE, 1)
	caster:AddNewModifier(caster, self, "modifier_pudge_death", nil)
end



modifier_pudge_death = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}end,
})

function modifier_pudge_death:OnCreated(data)

	self:StartIntervalThink(1.5)
end

function modifier_pudge_death:OnIntervalThink()
	self:StartIntervalThink(-1)

	self.freeze = true
end

function modifier_pudge_death:GetActivityTranslationModifiers()
	return "harpoon"
end

function modifier_pudge_death:GetOverrideAnimation()
	return ACT_DOTA_DIE
end

function modifier_pudge_death:CheckState()
	local state = {}
	if self.freeze then
		state[MODIFIER_STATE_FROZEN] = true
	end
	
	return state
end