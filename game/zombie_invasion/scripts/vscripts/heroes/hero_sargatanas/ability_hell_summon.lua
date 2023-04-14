ability_hell_summon = {}

function ability_hell_summon:OnSpellStart() 
	local point = self:GetCaster():GetAbsOrigin() 
	local portal = CreateUnitByName("npc_portal", point, true, nil, nil, DOTA_TEAM_GOODGUYS)  
	local point_for_unit = portal:GetAbsOrigin()
  
   Timers:CreateTimer(2, function()
		local unit = CreateUnitByName("npc_mechanical_turret", point_for_unit, true, nil, nil, DOTA_TEAM_GOODGUYS)  

   end)

end