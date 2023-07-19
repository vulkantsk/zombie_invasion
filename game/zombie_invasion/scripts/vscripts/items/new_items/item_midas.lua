LinkLuaModifier( "modifier_item_midas_tress", "items/new_items/item_midas", LUA_MODIFIER_MOTION_NONE )

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
	local gold_min = self:GetSpecialValueFor("gold_min")
	local gold_max = self:GetSpecialValueFor("gold_max")
		if self:GetCaster():HasModifier("modifier_change_hero") then 
				CreateUnitByName("npc_EdgardBs", point, true, nil, nil, DOTA_TEAM_BADGUYS)
				GameRules:SendCustomMessage("<font color='#c10020'>АХАХАХАХАХАХ ЕБАННЫЙ АБУЗЕР</font>", 0, 0)
				EmitGlobalSound("chto")
				return
		end

	 
				caster:EmitSound("DOTA_Item.Hand_Of_Midas")
local treasure = CreateUnitByName("npc_medas", point, true, nil, nil, DOTA_TEAM_BADGUYS)
            
            treasure:AddNewModifier(treasure,self,"modifier_item_midas_tress", {})
            treasure:SetMinimumGoldBounty(gold_min)
            treasure:SetMaximumGoldBounty(gold_max)
			local effect = "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, treasure)
			ParticleManager:SetParticleControl(particle_fx, 0, treasure:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 1, treasure:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)

end

modifier_item_midas_tress = {}


function modifier_item_midas_tress:IsHidden()
	return true
end

function modifier_item_midas_tress:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_item_midas_tress:CheckState()
    local state = {
    [MODIFIER_STATE_NO_HEALTH_BAR]=true,     --MODIFIER_STATE_PROVIDES_VISION
            [MODIFIER_STATE_NO_UNIT_COLLISION]=true,     --MODIFIER_STATE_PROVIDES_VISION

}      
    return state
end

function modifier_item_midas_tress:GetModifierProvidesFOWVision()
	return 1
end

