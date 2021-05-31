modifier_invasion_portal_warlock_portal = {}

function modifier_invasion_portal_warlock_portal:OnCreated()
	self:OnIntervalThink()
	self:StartIntervalThink( 5 )
	print( "ggg" )
end

function modifier_invasion_portal_warlock_portal:DeclareFunctions()
	return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_invasion_portal_warlock_portal:OnDeath( data )
	if data.unit == self:GetCaster() then
		self:GetParent():Destroy()
		return
	end
end

function modifier_invasion_portal_warlock_portal:OnIntervalThink()
	local pos = self:GetParent():GetAbsOrigin()

	local golem = CreateUnitByName(
		"npc_invasion_portal_warlock_golem",
		pos,
		true,
		nil,
		nil,
		self:GetCaster():GetTeam()
	)
end