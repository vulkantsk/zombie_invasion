tb_swap = class ({})

function tb_swap:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf",
	}, {
	}, context)
end


function tb_swap:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )

	if target:GetUnitName() == "npc_dota_hero_terrorblade" then
		caster:SetAbsOrigin(target_pos)
		target:SetAbsOrigin(caster_pos)
		caster:Stop()
		target:Stop()
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetCaster(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0),
			true
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0),
			true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

    end
end

function tb_swap:CastFilterResultTarget(target)
		if target:GetUnitName() ~= "npc_dota_hero_terrorblade" then
			return UF_FAIL_CUSTOM
		end
	return UF_SUCCESS	
end

function tb_swap:GetCustomCastErrorTarget(target)
		if target:GetUnitName() ~= "npc_dota_hero_terrorblade" then
			return "#dota_hud_error_bad_target"
		end
	return UF_SUCCESS	
end
