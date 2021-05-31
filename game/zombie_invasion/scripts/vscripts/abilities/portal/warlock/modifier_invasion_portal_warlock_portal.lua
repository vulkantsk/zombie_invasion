modifier_invasion_portal_warlock_portal = {}

if IsClient() then
	return
end

function modifier_invasion_portal_warlock_portal:OnCreated()
	self.team = self:GetCaster():GetTeam()
	local parent = self:GetParent()
	local particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_warlock/warlock_upheaval.vpcf",
		PATTACH_WORLDORIGIN,
		parent
	)
	ParticleManager:SetParticleControl( particle, 0, parent:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector( 100, 1, 1 ) )
	self:AddParticle( particle, false, false, -1, false, false )
	self:OnIntervalThink()
	self:StartIntervalThink( 5 )
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
	if self.particle then
		ParticleManager:DestroyParticle( self.particle, false )
		self:StartIntervalThink( 4.6 )
		self.particle = nil
		return
	end

	local pos = self:GetParent():GetAbsOrigin()
	local golem = CreateUnitByName(
		"npc_invasion_portal_warlock_golem",
		pos,
		true,
		nil,
		nil,
		self.team
	)

	Timers:CreateTimer( 0.1, function()
		if golem:IsNull() or not golem:IsAlive() then
			return
		end

		local point = Entities:FindByName( nil, "final_point" ):GetAbsOrigin()
		golem:MoveToPositionAggressive( point )
	end )

	self.particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_warlock/warlock_upheaval_debuff.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		golem
	)
	ParticleManager:SetParticleControl( self.particle, 0, pos )
	ParticleManager:SetParticleControl( self.particle, 1, pos )

	self:StartIntervalThink( 0.4 )
end