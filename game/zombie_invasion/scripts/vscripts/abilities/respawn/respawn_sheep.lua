UNIT_RESPAWN_TIME = 10

function Respoint (keys )
	Timers:CreateTimer(0.01,function()	          

		local caster = keys.caster 	--пробиваем IP усопшего
		caster.respoint = caster:GetAbsOrigin() -- определяем точку спавна
		caster.fw = caster:GetForwardVector()
	end)
end

 

function RespawnSheep(keys)	

	local caster= keys.caster
	local position = caster.respoint + RandomVector( RandomFloat( 0, 50))
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local respawn_time = UNIT_RESPAWN_TIME
    local chance_spawn = RandomFloat( 0, 5)
    print(chance_spawn)
     if name == "npc_classic_sheep" then
         if chance_spawn < 1 then
			 Timers:CreateTimer(respawn_time,function()	
		         local unit = CreateUnitByName("npc_classic_big_sheep", position , true, nil, nil, team)
		         unit:SetForwardVector(caster.fw)
	         end)
         elseif chance_spawn > 1 then 
	         Timers:CreateTimer(respawn_time,function()	
	             local unit = CreateUnitByName(name, position , true, nil, nil, team)
		         unit:SetForwardVector(caster.fw)
             end)	
         end
     elseif name == "npc_classic_big_sheep" then 
     	 	 Timers:CreateTimer(respawn_time,function()	
		         local unit = CreateUnitByName("npc_classic_sheep", position , true, nil, nil, team)
		         unit:SetForwardVector(caster.fw)
	         end)
	 end
end

