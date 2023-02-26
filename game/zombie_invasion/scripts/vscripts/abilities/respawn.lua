UNIT_RESPAWN_TIME = 10

function RespawnUnit(keys)
    
    local caster = keys.caster  
    local name = caster:GetUnitName()
    local team = caster:GetTeam()
	local respawn_time = UNIT_RESPAWN_TIME
    local chance_spawn = RandomFloat( 0, 5)
    local name1,name2,name_for_point
    local find_big = name:find("_big_")

    if find_big then 
         name1,name2 = name:match("(.+)_big_(.+)")
         name_for_point = name1.. "_" ..name2
    else
    	 name1,name2 = name:match("(npc_classic)_(.+)")
         name_for_point = name

    end

 
    local points = Entities:FindAllByName(name_for_point.. "_point")
    local position = points[RandomInt(1,#points)]:GetAbsOrigin() + RandomVector( RandomFloat( 30, 200))
 

    Timers:CreateTimer(respawn_time,function()
        if chance_spawn < 1 and not name == "npc_classic_warlock" then 
        	name_for_point = name1.. "_big_" .. name2 
            local unit = CreateUnitByName(name_for_point,position, true,nil,nil, team)
        else 
            local unit = CreateUnitByName(name_for_point,position, true,nil,nil, team)
        end
    end)
end