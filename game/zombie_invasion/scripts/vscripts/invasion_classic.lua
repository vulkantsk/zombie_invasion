 
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

 

function InvasionMode:spawn_undying_1()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "undying_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_undying", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_undying_2()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "undying_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_undying_2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_undying_3()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "undying_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_undying_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_undying_4()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "undying_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_undying_4", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_toxic_1()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "toxic_zombie"):GetAbsOrigin()
	unit = CreateUnitByName("npc_zombie_toxic", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	
 
 function InvasionMode:spawn_toxic_2()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "toxic_zombie"):GetAbsOrigin()
	unit = CreateUnitByName("npc_zombie_toxic_2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_toxic_3()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "toxic_zombie"):GetAbsOrigin()
	unit = CreateUnitByName("npc_zombie_toxic_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_toxic_4()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "toxic_zombie"):GetAbsOrigin()
	unit = CreateUnitByName("npc_zombie_toxic_4", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_flash_1()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "golem_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_flash_golem", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	

function InvasionMode:spawn_flash_2()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "golem_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_flash_golem_2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	


function InvasionMode:spawn_flash_3()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "golem_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_flash_golem_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end	


function InvasionMode:spawn_zombie_1()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_2()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_3()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_4()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_4"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end



function InvasionMode:spawn_zombie_11()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_big_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_22()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_big_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_33()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_big_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_44()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_4"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_big_zombie", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_ghost_1()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_5"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghost", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_111()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghoul", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_222()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghoul", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_333()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghoul", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_444()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_4"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghoul", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_ghost_11()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_5"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghost_2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_1111()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_1"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_pudge", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_2222()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_2"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_pudge", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_3333()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_pudge", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_zombie_4444()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_4"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_pudge", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_ghost_111()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_5"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghost_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_ghost_boss()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "wave_spawner_6"):GetAbsOrigin()
	unit = CreateUnitByName("npc_classic_wave_ghost_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
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
    	},
    	[2] = {
  		    "Серега пират - АМ ФП", 
  		    "Life - Larson",
  		    "Musica - Fly Project",
  		    "Wake Me Up - Avicii",
  		    "Galantis - No Money",
  	        "Jackie Chan - Tiësto, Dzeko feat. Preme, Post Malone",  
  		    "Boulevard of Broken Dreams - Green Day", 		
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
    	},
     	[4] = {
      		"Invasion.Castaways",
      		"August - Intelligency",
      		"Galantis - No Money",    		
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

	--    local time_until_end = 600 - GameRules:GetTimeOfDay()
	    for _,sound in pairs(music) do
	    	local music_len = Sounds:GetSoundDuration(sound)
	    	if music_len > longest_music_len then
	    		longest_music_len = music_len
	    		longest_music = sound
	    	elseif music_len < shortest_music_len then
	    		shortest_music_len = music_len
	    		shortest_music = sound
	    	end
	    end

	    if 	time_until_end > longest_music_len then
	    	current_music = music[RandomInt(1, #music)]
	    elseif 	time_until_end > longest_music_len then
	    	current_music = shortest_music
	    elseif time_until_end < shortest_music_len then
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
 
 	Timers:CreateTimer(300,function()
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_1()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_2()
	  end
	  for i = 1 , 6 do
         InvasionMode:spawn_zombie_3()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_4()
	  end
	end)
	
	Timers:CreateTimer(310,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(320,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(330,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(340,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(350,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_2()
	  end
	end)
	
	Timers:CreateTimer(360,function()
		InvasionMode:spawn_toxic_1()
      for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(370,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(380,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)

	Timers:CreateTimer(400,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
      for i = 1 , 5 do
		InvasionMode:spawn_zombie_2()
	  end
	end)
	
	Timers:CreateTimer(420,function()
		InvasionMode:spawn_undying_1()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(430,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(440,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(450,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_2()
	  end
	end)
	
	Timers:CreateTimer(460,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(470,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1()
	  end
	end)

	Timers:CreateTimer(480,function()
		InvasionMode:spawn_toxic_1()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(500,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
      for i = 1 , 5 do
		InvasionMode:spawn_zombie_2()
	  end
	end)
	
	Timers:CreateTimer(520,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(530,function()
		InvasionMode:spawn_toxic_1()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1()
	  end	
	end)
	
	Timers:CreateTimer(540,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(550,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_2()
	  end
	end)
	
	Timers:CreateTimer(560,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(580,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)
	
	Timers:CreateTimer(590,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1()
	  end
	end)


 
 
 	Timers:CreateTimer(900,function()
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_22()
	  end
	  for i = 1 , 6 do
         InvasionMode:spawn_zombie_33()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_44()
	  end
	  for i = 1 , 8 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(910,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(920,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 1 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(930,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(940,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 5 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(950,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 1 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(960,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(970,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 1 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(980,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 3 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(990,function()
		InvasionMode:spawn_undying_2()
	  for i = 1 , 4 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1000,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1010,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1020,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	end)
	
	Timers:CreateTimer(1030,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1040,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1050,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1060,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)

	Timers:CreateTimer(1070,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1080,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1090,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1100,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1110,function()
		InvasionMode:spawn_undying_2()
	  for i = 1 , 4 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1120,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 2 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1130,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1140,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 5 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1148,function()
		InvasionMode:spawn_flash_1()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 10 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	
	Timers:CreateTimer(1160,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_1()
	  end
	end)
	
	Timers:CreateTimer(1170,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	end)

	Timers:CreateTimer(1180,function()
		InvasionMode:spawn_toxic_2()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_11()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_22()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_33()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_1()
	  end
	end)



	Timers:CreateTimer(1500,function()
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_222()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_333()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_444()
	  end
	  for i = 1 , 8 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1510,function()
		InvasionMode:spawn_toxic_3()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1520,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1530,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1540,function()
		InvasionMode:spawn_toxic_3()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1550,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1560,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1570,function()
		InvasionMode:spawn_toxic_3()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1580,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1590,function()
		InvasionMode:spawn_undying_3()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1600,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1610,function()
		InvasionMode:spawn_toxic_3()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1620,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1630,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)

	Timers:CreateTimer(1635,function()
		InvasionMode:spawn_toxic_3()
	end)
	
	Timers:CreateTimer(1640,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1650,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1655,function()
		InvasionMode:spawn_toxic_3()
	end)
	
	Timers:CreateTimer(1660,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1670,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1680,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1685,function()
		InvasionMode:spawn_toxic_3()
	end)

	Timers:CreateTimer(1690,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1700,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1710,function()
		InvasionMode:spawn_undying_3()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1720,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1730,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)

	Timers:CreateTimer(1740,function()
		InvasionMode:spawn_toxic_3()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1748,function()
		InvasionMode:spawn_flash_2()
	end)
	
	Timers:CreateTimer(1750,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1760,function()
		InvasionMode:spawn_toxic_3()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_11()
	  end
	end)
	
	Timers:CreateTimer(1770,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_111()
	  end
	end)
	
	Timers:CreateTimer(1775,function()
		InvasionMode:spawn_toxic_3()
	end)
	
	Timers:CreateTimer(1780,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_222()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_333()
	  end
	  for i = 1 , 8 do
		InvasionMode:spawn_ghost_11()
	  end
	end)



	Timers:CreateTimer(2100,function()
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_2222()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_3333()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_zombie_4444()
	  end
	  for i = 1 , 8 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2120,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
 
	
	Timers:CreateTimer(2130,function()
		InvasionMode:spawn_toxic_4()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2140,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2150,function()
		InvasionMode:spawn_toxic_4()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2155,function()
		InvasionMode:spawn_toxic_4()
		InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2160,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2170,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2175,function()
		InvasionMode:spawn_toxic_4()
	end)
	
	Timers:CreateTimer(2180,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2190,function()
		InvasionMode:spawn_undying_4()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2200,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2210,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2215,function()
		InvasionMode:spawn_toxic_4()
	end)
	
	Timers:CreateTimer(2220,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2230,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2240,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2245,function()
		InvasionMode:spawn_toxic_4()
	end)
	
	Timers:CreateTimer(2250,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2260,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 5 do
		InvasionMode:spawn_ghost_111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2270,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2280,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 3 do
		InvasionMode:spawn_ghost_111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2290,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2295,function()
		InvasionMode:spawn_toxic_4()
	end)

	Timers:CreateTimer(2300,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 5 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2310,function()
		InvasionMode:spawn_undying_4()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2320,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 6 do
		InvasionMode:spawn_ghost_111()
	  end
	end)
	
	Timers:CreateTimer(2325,function()
		InvasionMode:spawn_toxic_4()
		InvasionMode:spawn_ghost_boss()
	end)

	Timers:CreateTimer(2330,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)

	Timers:CreateTimer(2340,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end
	  InvasionMode:spawn_ghost_boss()
	end)
	
	Timers:CreateTimer(2350,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2360,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	  for i = 1 , 4 do
		InvasionMode:spawn_ghost_111()
	  end  
	InvasionMode:spawn_flash_3()
	 
	end)
	
	Timers:CreateTimer(2370,function()
	  for i = 1 , 5 do
		InvasionMode:spawn_zombie_1111()
	  end
	end)
	
	Timers:CreateTimer(2380,function()
	  for i = 1 , 10 do
		InvasionMode:spawn_zombie_1111()
	  end
	   for i = 1 , 10 do
		InvasionMode:spawn_zombie_2222()
	  end
	end)
	
 
	

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
