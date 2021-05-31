require( "ai/ai_utils" )

modifier_invasion_portal_veno_infest = {}

function modifier_invasion_portal_veno_infest:GetEffectName()
	return "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf"
end

function modifier_invasion_portal_veno_infest:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_invasion_portal_veno_infest:IsPurgable()
	return false
end

if IsClient() then
	return
end

function modifier_invasion_portal_veno_infest:OnCreated()
	self:StartIntervalThink( 0.9 )
end

function modifier_invasion_portal_veno_infest:OnIntervalThink()
	local parent = self:GetParent()
	self:GetCaster():SetAbsOrigin( parent:GetAbsOrigin() )
	generic_ai( parent )
end

function modifier_invasion_portal_veno_infest:OnDestroy()
	self:GetCaster():RemoveModifierByName( "modifier_invasion_portal_veno_infest_caster" )
end