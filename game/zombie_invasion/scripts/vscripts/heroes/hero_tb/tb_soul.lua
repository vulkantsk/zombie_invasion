tb_soul = class({})

function tb_soul:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf",
	}, {
	}, context)
end


function tb_soul:OnSpellStart()
    local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "illusion_duration" )
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_damage" )
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage" )
	local distance = 200
	local illusions = CreateIllusions(
		caster,
		caster,
		{
			outgoing_damage = outgoing,
			incoming_damage = incoming,
			duration = duration,
		},
		4,
		distance,
		false,
		true
		)
	    local effect = "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
    ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, caster)
	caster:ForceKill(true)
end
