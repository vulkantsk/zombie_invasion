item_midas = class({})

function item_midas:OnAbilityPhaseStart()
		if IsServer() then
	    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1)  
	end
 	return true
end


function item_midas:OnAbilityPhaseInterrupted()
		if IsServer() then
	    self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
	end
 	return true
end

function item_midas:OnSpellStart()
	   self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin() + RandomVector( RandomFloat( 150, 150))
				caster:EmitSound("DOTA_Item.Hand_Of_Midas")
local treasure = CreateUnitByName("npc_medas", point, true, nil, nil, DOTA_TEAM_BADGUYS)
			local effect = "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, treasure)
			ParticleManager:SetParticleControl(particle_fx, 0, treasure:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 1, treasure:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)

end
