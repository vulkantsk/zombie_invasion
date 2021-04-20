if ZSpawn == nil then
	_G.ZSpawn = class({})
	
	ZSpawn.spawners = {}
	
	ZSpawn.RESPAWN_DELAY = 10
	ZSpawn.SPAWNER_NAME = "zspawn_point"
	ZSpawn.UNIT_TEAM = DOTA_TEAM_NEUTRALS
	
	ZSpawn.units_list = {
		"npc_dota_neutral_kobold",
		"npc_dota_neutral_kobold_tunneler"
	}
end

function ZSpawn:init()
	ZSpawn:FillSpawners()
end

function ZSpawn:FillSpawners()
	local spawners = Entities:FindAllByName(ZSpawn.SPAWNER_NAME)
	for _,spawner in pairs(spawners) do
		if spawner then
			ZSpawn.spawners[#ZSpawn.spawners+1] = spawner:GetAbsOrigin()
		end
	end
	
	print("ZSPAWN: spawner count = "..#ZSpawn.spawners)
end

function ZSpawn:Cycle()
	if #ZSpawn.spawners > 0 then
		print("ZSPAWN: cycle started")
		Timers:CreateTimer(ZSpawn.RESPAWN_DELAY, function()
			local rNunit = RandomInt(1, #ZSpawn.units_list)
			local unitname = ZSpawn.units_list[rNunit]
			
			local rNspawner = RandomInt(1, #ZSpawn.spawners)
			local pos = ZSpawn.spawners[rNspawner]
			
			local unit = CreateUnitByName(unitname, pos, true, nil, nil, ZSpawn.UNIT_TEAM)
			
			print("ZSPAWN: spawned "..unitname.." at spawner "..rNspawner)
			
			return ZSpawn.RESPAWN_DELAY
		end)
	end
end