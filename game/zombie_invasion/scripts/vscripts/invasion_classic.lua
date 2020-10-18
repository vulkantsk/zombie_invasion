 
require( 'modifiers_links' )
require( 'timers' )

if InvasionMode == nil then
	InvasionMode = class({})
end

MONSTERS_RESPAWN_TIME = 10
WAVE_RESPAWN_TIME = 2
MEAT_DROP_PERC = 35
MILK_DROP_PERC = 35
SKIN_DROP_PERC = 1
EGG_DROP_PERC = 20
EGG_STRONG_DROP_PERC = 30
BONE_DROP_PERC = 20
BONE_STRONG_DROP_PERC = 40
function InvasionMode:InvasionMap()
     
  
	
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )

	GameRules:SetSameHeroSelectionEnabled(false)
	
 
 
 
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )	
 
 
 

	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	--GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(InvasionMode, 'InvasionMapGameRulesStateChange'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(InvasionMode, 'InvasionEntityKilled'), self)		
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(InvasionMode, 'InvasionOnNPCSpawn'), self)	

	AddFOWViewer(DOTA_TEAM_BADGUYS, Entities:FindByName( nil, "dota_shop"):GetAbsOrigin(), 1000, -1, false)

end


 function InvasionMode:InvasionMapGameRulesStateChange(data)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		InvasionMode:InvasionGameStart()
	end
	if newState == DOTA_GAMERULES_STATE_POST_GAME then
		local presentTime = GameRules:GetDOTATime(false,false)
		if presentTime < 1479 then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	end

end


function InvasionMode:InvasionOnNPCSpawn(data)

	local npc = EntIndexToHScript(data.entindex)
end

function InvasionMode:spawn_last_boss()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_last_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end


function InvasionMode:InvasionGameStart()

	InvasionMode:InvasionSpawnMoobs()
--день 
    day_music =
    { 	
    	[1] = {
  		    "Akira Yamaoka – Never Forgive Me",
  		    "Ula - Cannabis",
  		    "Toby Fox – Once Upon a Time",  
  		    "C418 - Sweden",
  		    "Mase - Psycho",
            "Rig",			
    	},
    	[2] = {
  		    "Серега пират - АМ ФП", 
  		    "Life - Larson",
  		    "Musica - Fly Project",
  		    "Wake Me Up - Avicii",
  		    "Galantis - No Money",
  	        "Jackie Chan - Tiësto, Dzeko feat. Preme, Post Malone",  
  		    "Boulevard of Broken Dreams - Green Day", 	
            "balah_babar",			
    	},
    	[3] = {
		
  		    "Lana Del Rey - Summertime Sadness (smoke remix)",
  		    "I Follow Rivers - Lykke Li",
  		    "August - Intelligency",  
  		    "Shotgun - Yellow Claw feat. Rochelle",
  		    "Runaway - Parachute Youth feat. Jay Martin",
  		    "Sia - Cheap Thrills",
  		    "L Starz - My Life Be LikeGrits",
  		    "Kiesza - Hideaway",
  		    "John  Newman - Fire In Me",
  		    "iSpy - KYLE feat. Lil Yachty",	
			"shaman"
    	},
     	[4] = {
      		"Sia - Chandelier",
      		"RSAC - NBA",
      		"Would I Lie To You",
      		"Does It Matter - Janieck",    		
    	},
    }
 
 	night_music =
 	{
 		[1] = {
			"Undertale - Respite",
		},
 		[2] = {
	 		"C418-Key",
 		},
 		[3] = {
			"Invasion.HalloweenJC",
 		},
 		[4] = {
	 		"C418-Key",
			"Undertale - Respite",
			"Invasion.HalloweenJC",
 		},
 	}

	Timers:CreateTimer(0,function()
	    local time = GameRules:GetDOTATime(false, false)
	    local day_time = GameRules:GetDOTATime(false, false)%600
	    local current_day =  math.floor(time/600)+1
	    local music 
	    local time_until_end

	    if day_time > 300 then
	    	music = night_music[current_day]
	    	time_until_end = 600 - day_time
	    	print("night time")
	    else
	    	music = day_music[current_day]
	    	time_until_end = 300 - day_time
	    	print("day time")
	    end

		print("time until night = "..time_until_end)

	    local current_music = nil
	    local longest_music = music[1]
	    local longest_music_len = Sounds:GetSoundDuration(music[1])
	    local shortest_music = music[1]
	    local shortest_music_len = Sounds:GetSoundDuration(music[1])
	    local midle_music = music[1]
	    local midle_music_len = Sounds:GetSoundDuration(music[1])

	--    local time_until_end = 600 - GameRules:GetTimeOfDay()
	    for _,sound in pairs(music) do
	    	local music_len = Sounds:GetSoundDuration(sound)
	    	if music_len > longest_music_len then
	    		longest_music_len = music_len
	    		longest_music = sound
	    	elseif music_len < shortest_music_len then
	    		shortest_music_len = music_len
	    		shortest_music = sound
			elseif music_len < longest_music_len and music_len > shortest_music_len then
			     midle_music_len = music_len
				 midle_music = sound
	    	end
	    end
	    print("longest_music = "..longest_music)
	    print("longest_music len= "..longest_music_len)
	    print("shortest_music = "..shortest_music)
	    print("shortest_music len= "..shortest_music_len)

         
		 
	    if 	time_until_end > longest_music_len then
	    	current_music = music[RandomInt(1, #music)]
	    elseif 	time_until_end >= shortest_music_len then
	    	current_music = shortest_music
	    elseif time_until_end < shortest_music_len  then
	    	return time_until_end+1
	    end 

	    Sounds:CreateGlobalSound( current_music )
	    GameRules:SendCustomMessage("<font color='#58ACFA'>"..current_music.."</font>", 0, 0)
	    print("sound  = "..current_music) 
	    print("sound duration = "..Sounds:GetSoundDuration(current_music)) 
	    return Sounds:GetSoundDuration(current_music)		    
	end)
	

--5 минута, 1я ночь
	Timers:CreateTimer(300,function()
		EmitGlobalSound("Invasion.Night")
--		EmitGlobalSound("C418-Key")
--      GameRules:SendCustomMessage("<font color='#58ACFA'>C418 - Key</font>", 0, 0)
	return nil
	end)


--15 минута, 2я ночь
	Timers:CreateTimer(900,function()
		EmitGlobalSound("invasion.Night")
--		EmitGlobalSound("Invasion.HalloweenJC")
--		GameRules:SendCustomMessage("<font color='#58ACFA'>Halloween - John Carpenter</font>", 0, 0)
		return nil
	end)

--25 минута, 3я ночь
	Timers:CreateTimer(1500,function()
		EmitGlobalSound("invasion.Night")
--		EmitGlobalSound("Invasion.HalloweenJC")
--		GameRules:SendCustomMessage("<font color='#58ACFA'>Halloween - John Carpenter</font>", 0, 0)
		return nil
	end)
	
	Timers:CreateTimer(2100,function()
		EmitGlobalSound("invasion.Night")
--		EmitGlobalSound("Undertale - Respite")
--		GameRules:SendCustomMessage("<font color='#58ACFA'>Undertale - Respite</font>", 0, 0)
		return nil
	end)

 --40 минута, конец 4ей ночи, день
	Timers:CreateTimer(2400,function()
	    xuitat3 = RandomInt(1,3)
        print(xuitat3)
		if xuitat3 == 1 then
	 	    EmitGlobalSound("Invasion.Castaways")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>The Castaways – Liar Liar</font>", 0, 0) 
		elseif xuitat3 == 2 then
	 	    EmitGlobalSound("Would I Lie To You")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>Would I Lie To You - David Guetta, Cedric Gervais, Chris Willis</font>", 0, 0) 		
		else
	 	    EmitGlobalSound("Sergey")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>Серега пират - АМ ФП</font>", 0, 0) 
        end			
	end)  
	
	Timers:CreateTimer(2448,function()
		    		    GameRules:SendCustomMessage("#laughter", 0, 0) 
								    
														     
	end)

	Timers:CreateTimer(2449,function()
		    		    GameRules:SendCustomMessage("#laughter", 0, 0) 
								    		    GameRules:SendCustomMessage("#laughter_2", 0, 0) 
														    		 
	end)
	
	Timers:CreateTimer(2450,function()
		    		    GameRules:SendCustomMessage("#laughter_3", 0, 0) 
								    		    GameRules:SendCustomMessage("#laughter_4", 0, 0) 
														    		    GameRules:SendCustomMessage("#laughter_5", 0, 0) 
	end)
	
	Timers:CreateTimer(2451,function()
		    		    GameRules:SendCustomMessage("#laughter_3", 0, 0) 
								    		    GameRules:SendCustomMessage("#laughter_6", 0, 0) 
														    		    GameRules:SendCustomMessage("#laughter_5", 0, 0) 
	end)
	
	Timers:CreateTimer(2452,function()
		    		    GameRules:SendCustomMessage("#laughter_3", 0, 0) 
								    		    GameRules:SendCustomMessage("#laughter_4", 0, 0) 
														    		    GameRules:SendCustomMessage("#laughter_5", 0, 0) 
	end)
	
	Timers:CreateTimer(2453,function()
		    		    GameRules:SendCustomMessage("#laughter_3", 0, 0) 
								    		    GameRules:SendCustomMessage("#laughter_7", 0, 0) 
														    		    GameRules:SendCustomMessage("#laughter_8", 0, 0) 
	end)
	
	Timers:CreateTimer(2460,function()
		    EmitGlobalSound("Asgore_Intro_classic")
	end)
	
 
	
	Timers:CreateTimer(2462, function() GameRules:SendCustomMessage("#begining_1",0,0) end)
	
	Timers:CreateTimer(2470, function() GameRules:SendCustomMessage("#begining_2",0,0) end)
	
	Timers:CreateTimer(2478, function() GameRules:SendCustomMessage("#begining_3",0,0) end)
	
	Timers:CreateTimer(2478,function()
       InvasionMode:spawn_last_boss()
	end)
	
	Timers:CreateTimer(2450,function()
		    SendToConsole("stopsound")
	end)
 
 
 
 -- 1 НОЧЬ
 
	local wave = 0	
	
 	Timers:CreateTimer(300,function()
		 self:SpawnZombie("npc_classic_wave_zombie",18)
	end)
	
	Timers:CreateTimer(300, function()
	     while wave < 29 do
		     wave = wave + 1
			 
			 local unit_count = 5 * (1 + wave%2)
		     self:SpawnZombie("npc_classic_wave_zombie", unit_count)
		     return 10
		 end			 
	end)

	Timers:CreateTimer(360, function()
	     while wave <  28 do 
		     self:SpawnZombie("npc_zombie_toxic",1)
		 return 60
		 end
	end)	
 
 	Timers:CreateTimer(455,function()
		 self:SpawnZombie("npc_undying",1)
	end)
	
 	Timers:CreateTimer(580,function()
		 self:SpawnZombie("npc_classic_wave_zombie",15)
	end)
 
 
 
 -- 2 НОЧЬ

    local wave_2 = 0

 	Timers:CreateTimer(900,function()
		 self:SpawnZombie("npc_classic_wave_big_zombie",16)
		 self:SpawnGhost("npc_classic_wave_ghost",8)
	end)
	
	Timers:CreateTimer(900, function()
	     while wave_2 < 29 do
			 wave_2 = wave_2 + 1
			 
			 local unit_count = 5 * (1 + wave_2%2)
		     self:SpawnZombie("npc_classic_wave_big_zombie", unit_count)
		     return 10
		 end			 
	end)
	
	Timers:CreateTimer(900, function()
	    while wave_2 < 29 do 
		     local unit_count = 3 * (1 + wave_2%2)
			 
		     self:SpawnGhost("npc_classic_wave_ghost",unit_count)
		     return 30
		end
	end)
	
	Timers:CreateTimer(950, function()
	     while wave_2 <  28 do 
		     self:SpawnZombie("npc_zombie_toxic_2",1)
		 return 50
		 end
	end)
	
	Timers:CreateTimer(990,function()
		 self:SpawnZombie("npc_undying_2",1)
	end)
 
	Timers:CreateTimer(1110,function()
		 self:SpawnZombie("npc_undying_2",1)
	end)
	
	Timers:CreateTimer(1148,function()
		 self:SpawnZombie("npc_flash_golem",1)
	end)
	
 	Timers:CreateTimer(1180,function()
		 self:SpawnZombie("npc_classic_wave_big_zombie",14)
		 self:SpawnGhost("npc_classic_wave_ghost",6)
	end)

 	
	
  -- 3 НОЧЬ 
 
    local wave_3 = 0
	
  	Timers:CreateTimer(1500,function()
		 self:SpawnZombie("npc_classic_wave_ghoul",16)
		 self:SpawnGhost("npc_classic_wave_ghost_2",8)
	end)
	
	Timers:CreateTimer(1500, function()
	     while wave_3 < 29 do
			 wave_3 = wave_3 + 1
			 
			 local unit_count = 5 * (1 + wave_3%2)
		     self:SpawnZombie("npc_classic_wave_ghoul", unit_count)
		     return 10
		 end			 
	end)
	
	Timers:CreateTimer(1500, function()
	    while wave_3 < 29 do 
		     local unit_count = 3 * (1 + wave_3%2)
			 
		     self:SpawnGhost("npc_classic_wave_ghost_2",unit_count)
		     return 30
		end
	end)
	
	Timers:CreateTimer(1540, function()
	     while wave_3 <  28 do 
		     self:SpawnZombie("npc_zombie_toxic_3",1)
		 return 40
		 end
	end)
 

	Timers:CreateTimer(1590,function()
		 self:SpawnZombie("npc_undying_3",1)
	end)

	Timers:CreateTimer(1710,function()
		 self:SpawnZombie("npc_undying_3",1)
	end)
	
 
	Timers:CreateTimer(1748,function()
		 self:SpawnZombie("npc_flash_golem_2",1)
	end)
 
   	Timers:CreateTimer(1780,function()
		 self:SpawnZombie("npc_classic_wave_ghoul",14)
		 self:SpawnGhost("npc_classic_wave_ghost_2",7)
	end)
 
 
   -- 4 НОЧЬ 
  
    local wave_4 = 0
	
  	Timers:CreateTimer(2100,function()
		 self:SpawnZombie("npc_classic_wave_pudge",16)
		 self:SpawnGhost("npc_classic_wave_ghost_3",8)
	end)
	
	Timers:CreateTimer(2100, function()
	     while wave_4 < 29 do
			 wave_4 = wave_4 + 1
			 
			 local unit_count = 5 * (1 + wave_4%2)
		     self:SpawnZombie("npc_classic_wave_pudge", unit_count)
		     return 10
		 end			 
	end)
	
	Timers:CreateTimer(2100, function()
	    while wave_4 < 29 do 
		     local unit_count = 3 * (1 + wave_4%2)
			 
		     self:SpawnGhost("npc_classic_wave_ghost_3",unit_count)
			 self:SpawnGhost("npc_classic_wave_ghost_boss",1)
		     return 30
		end
	end)
	
	Timers:CreateTimer(2135, function()
	     while wave_4 <  28 do 
		     self:SpawnZombie("npc_zombie_toxic_4",1)
		 return 35
		 end
	end)
 
  
	
	Timers:CreateTimer(2310,function()
		 self:SpawnZombie("npc_undying_4",1)
	end)
 
	
	Timers:CreateTimer(2360,function()
		 self:SpawnZombie("npc_flash_golem_3",1)
	end)
	
	Timers:CreateTimer(2380,function()
		 self:SpawnZombie("npc_classic_wave_pudge",24)	
	end)
end

function InvasionMode:SpawnZombie(unit_name, unit_count)
	local points = Entities:FindAllByName("zombie_spawner")

	for i=1, unit_count do
		local point = points[RandomInt(1, #points)]
		local unit = CreateUnitByName(unit_name, point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		unit:SetInitialGoalEntity(point)
	end
end

function InvasionMode:SpawnGhost(unit_name, unit_count)
	local points = Entities:FindAllByName("ghost_spawner")

	for i=1, unit_count do
		local point = points[RandomInt(1, #points)]
		local unit = CreateUnitByName(unit_name, point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		unit:SetInitialGoalEntity(point)
	end
end

--спавны
function InvasionMode:InvasionSpawnMoobs()
	local point = nil
	local unit = nil
	--boss_spawner_2
	--wave_spawner_1

	
	---city zombie
	local zombieName = { 
        "npc_classic_zombie","npc_classic_zombie",
        "npc_classic_big_zombie","npc_classic_big_zombie","npc_classic_big_zombie",
        "npc_classic_ghoul","npc_classic_ghoul"
        } 
--[[
	for i = 1, 7 do
		point = Entities:FindByName( nil, "city_spawner_" .. i):GetAbsOrigin()
		for j = 1, 5 do
			unit = CreateUnitByName(zombieName[i], point + RandomVector(200), true, nil, nil, DOTA_TEAM_BADGUYS )
			unit.respawn = true		
			unit.vSpawnLoc = unit:GetOrigin()
			unit.team = DOTA_TEAM_BADGUYS			
			--unit.vSpawnVector = Vector(-1,-1,0)
			unit:SetForwardVector(RandomVector(1))
		end
	end 
]]

	--bosses
	point = Entities:FindByName( nil, "boss_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_witch", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))

	point = Entities:FindByName( nil, "boss_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_boss_mutant", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))


end

 
 function InvasionMode:spawn_tombs_flash()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone_flash_1", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

 function InvasionMode:spawn_tombs_flash_2()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone_flash_2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

 function InvasionMode:spawn_tombs_flash_3()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone_flash_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

 function InvasionMode:spawn_tombs_flash_4()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone_flash_4", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_tombs()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone1", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

 
function InvasionMode:spawn_tombs_2()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_tombs_3()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_tombs_4()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_tombstone4", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

 function InvasionMode:spawnsvini() -- Вызывание свина 
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться


	--bosses
	point = Entities:FindByName( nil, "boss_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_boss_pig", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))



end


local pig_count = 0

function GiveGoldPlayers( gold )
	for index=0 ,4 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			hero:ModifyGold(gold, false, 0)
			SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, hero, gold, nil )
		end
	end
end
 
    
function InvasionMode:InvasionEntityKilled (data)
	local killedEntity = EntIndexToHScript(data.entindex_killed)

	if killedEntity:GetUnitName() == "NPC_base" then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		EmitGlobalSound("Invasion.HommerWin")
	end	
	
 

if killedEntity:GetUnitName() == "npc_last_boss" then
     InvasionMode:PrintEndgameMessage1()
end
 
if killedEntity:GetUnitName() == "npc_classic_pig" then
pig_count = pig_count+1
    if pig_count == 15 then
	    GameRules:SendCustomMessage("#big_bo_1",0,0)
	end
    if pig_count == 35 then
	    GameRules:SendCustomMessage("#big_bo_2",0,0)
	end
    if pig_count == 50 then
	    GameRules:SendCustomMessage("#big_bo_3",0,0)
	end
    if pig_count == 70 then
	    GameRules:SendCustomMessage("#big_bo_4",0,0)
	end
    if pig_count == 75 then
	    InvasionMode:spawnsvini()
	    EmitGlobalSound("Invasion.HommerWin")
    end
end

 
	if 	killedEntity:GetUnitName() == "npc_undying"		then 	GiveGoldPlayers(550)
	   elseif killedEntity:GetUnitName() == "npc_undying_2"		then 	GiveGoldPlayers(650)
       elseif killedEntity:GetUnitName() == "npc_flash_golem"		then 	GiveGoldPlayers(1250)
       elseif killedEntity:GetUnitName() == "npc_undying_3"		then 	GiveGoldPlayers(800)
       elseif killedEntity:GetUnitName() == "npc_flash_golem_2"		then 	GiveGoldPlayers(1550)
        elseif killedEntity:GetUnitName() == "npc_undying_4"		then 	GiveGoldPlayers(1125)      
	   elseif killedEntity:GetUnitName() == "npc_flash_golem_3"		then 	GiveGoldPlayers(2230)
	end
 
 



	if killedEntity:IsCreature() then
		if killedEntity.respawn  then
			if killedEntity.nightZombie then
				self:RespawnCreature(killedEntity,WAVE_RESPAWN_TIME)
			else
				self:RespawnCreature(killedEntity,MONSTERS_RESPAWN_TIME)
			end
		end

		if killedEntity:GetUnitName() == "npc_classic_pig" then
            if RollPercentage(MEAT_DROP_PERC) then
                self:CreateDrop("item_meat", killedEntity:GetAbsOrigin())
            end
		end	

		if killedEntity:GetUnitName() == "npc_classic_sheep" then
            if RollPercentage(MILK_DROP_PERC) then
                self:CreateDrop("item_milk", killedEntity:GetAbsOrigin())
            end
		end
		
		if killedEntity:GetUnitName() == "npc_classic_half_zombie" then
            if RollPercentage(SKIN_DROP_PERC) then
                self:CreateDrop("item_zombie_skin", killedEntity:GetAbsOrigin())
            end
		end

		if killedEntity:GetUnitName() == "npc_classic_chicken" then
            if RollPercentage(EGG_DROP_PERC) then
                self:CreateDrop("item_eggs", killedEntity:GetAbsOrigin())
            end
		end
		
		if killedEntity:GetUnitName() == "npc_stronger_chicken" then
            if RollPercentage(EGG_STRONG_DROP_PERC) then
                self:CreateDrop("item_eggs", killedEntity:GetAbsOrigin())
            end
		end
		
		if killedEntity:GetUnitName() == "npc_classic_skelet" then
            if RollPercentage(BONE_DROP_PERC) then
                self:CreateDrop("item_bone", killedEntity:GetAbsOrigin())
            end
		end
		
		if killedEntity:GetUnitName() == "npc_classic_skeleton_king" then
            if RollPercentage(BONE_STRONG_DROP_PERC) then
                self:CreateDrop("item_bone", killedEntity:GetAbsOrigin())
            end
		end
		
		

		if killedEntity:GetUnitName() == "npc_classic_witch" then
			for i = 1, 2 do
            	self:CreateDrop("item_bag_of_gold", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 300)) )
        	end
		end
		
		if killedEntity:GetUnitName() == "npc_classic_witch" then
			for i = 1, 1 do
            	self:CreateDrop("item_corica", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 300)) ) 
        	end
		end
		if killedEntity:GetUnitName() == "npc_boss_pig" then
			for i = 1, 4 do
            	self:CreateDrop("item_bag_of_gold_pig", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 300)) ) 
        	end
		end
		if killedEntity:GetUnitName() == "npc_boss_pig" then
			for i = 1, 1 do
            	self:CreateDrop("item_big_meat", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 300)) ) 
        	end
		end

		if killedEntity:GetUnitName() == "npc_dota_bochok_saxara" then
			for i = 1, 1 do
            	self:CreateDrop("item_saxar_svekla", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 150)) ) 
        	end
			for i = 1, 1 do
            	self:CreateDrop("item_magic_heart", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 150)) ) 
        	end
		end
		
		if killedEntity:GetUnitName() == "npc_boss_mutant" then
			for i = 1, 3 do
            	self:CreateDrop("item_bag_of_gold", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 300)) )
        	end
		end
		
		if killedEntity:GetUnitName() == "npc_boss_mutant" then
			for i = 1, 1 do
            	self:CreateDrop("item_undying_heart", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 300)) )
        	end
		end

	end


end
 
function InvasionMode:CreateDrop (itemName, pos)
   local newItem = CreateItem(itemName, nil, nil)
   newItem:SetPurchaseTime(0)
   CreateItemOnPositionSync(pos, newItem)
   newItem:LaunchLoot(false, 300, 0.75, pos + RandomVector(RandomFloat(50, 350)))
end

function InvasionMode:PrintEndgameMessage1()
	 
		Timers:CreateTimer(1, function() GameRules:SendCustomMessage("#ending_1",0,0) end)
	
	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("#ending_2",0,0) end)
 
	Timers:CreateTimer(8, function() GameRules:SendCustomMessage("#ending_3",0,0) end)
 
	Timers:CreateTimer(15, function() GameRules:SendCustomMessage("#Game_notification_win",0,0) end)
	
	Timers:CreateTimer(30, function() GameRules:SendCustomMessage("#ending_4",0,0) end)
	
	Timers:CreateTimer(40, function() GameRules:SendCustomMessage("#ending_5",0,0) end)
	
	Timers:CreateTimer(45, function() GameRules:SendCustomMessage("#ending_6",0,0) end)
	
	Timers:CreateTimer(100, function() GameRules:SendCustomMessage("#ending_7",0,0) end)
	
	Timers:CreateTimer(115, function() GameRules:SendCustomMessage("#ending_8",0,0) end)
	
	Timers:CreateTimer(135, function() GameRules:SendCustomMessage("#ending_9",0,0) end)
	
Timers:CreateTimer(5, function()  EmitGlobalSound("Undertale - Last Goodbye Dual Mix") end)
 
	Timers:CreateTimer(136, function() GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) end)
end
