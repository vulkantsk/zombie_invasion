 
function StartTouchEdg( trigger )
    local ent = trigger.activator

    local unit = CreateUnitByName("npc_EdgardBs", ent:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)


     GameRules:SendCustomMessage("<font color='#c10020'>ERROR npc_Edgard</font>", 0, 0)
end

 

-----------------------------------------------------------------------------------------

 