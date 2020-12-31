LinkLuaModifier("modifier_intro_rotate_christmas", "abilities/endgame/intro_rotate_christmas", 0)
LinkLuaModifier("modifier_intro_rotate_christmas_passive", "abilities/endgame/intro_rotate_christmas", 0)

intro_rotate_christmas = class({})

 

function intro_rotate_christmas:OnSpellStart()
	local caster = self:GetCaster()
	local rotate_duration = self:GetSpecialValueFor("rotate_duration")
	local point = self:GetCursorPosition()

--	caster:AddNewModifier(caster, self, "modifier_intro_rotate", {duration = rotate_duration, point = point})
end

modifier_intro_rotate_christmas_passive = class({
	IsHidden = function() return true end,
	CheckState = function() return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}end,
})

modifier_intro_rotate_christmas = class({
	IsHidden = function() return true end,
})

function modifier_intro_rotate_christmas:OnCreated(data)
	local caster = self:GetCaster()
	local caster_point = caster:GetAbsOrigin()
	local point = data.point
	
	print(point)
	print(caster_point)
	local fw = caster:GetForwardVector()
	local end_vector = (point - caster_point)
	local rotate_duration = self:GetDuration()

	self.delta_vector = (end_vector-fw)*FrameTime()/rotate_duration

	self:StartIntervalThink(FrameTime())
end

function modifier_intro_rotate_christmas:OnIntervalThink()
	local caster = self:GetCaster()

	caster:SetForwardVector(caster:GetForwardVector()+self.delta_vector)
end