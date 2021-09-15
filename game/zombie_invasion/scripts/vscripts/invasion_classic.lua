
require( 'modifiers_links' )
require( 'timers' )

if InvasionMode == nil then
	InvasionMode = class({})
end

 HeroMaxLevel = 36
HeroExpTable = {0}
exp={150,200,275,375,450,  500,550,615,780,715,
  735,785,825,875,925,975,1300,  1250,1350,
  1450,1550,1650,2000,1800,1900,2200,2250,2300,2350,
  2500,2500,2500,2500,2500,2500
  
  }

Pig_bo_kill = 0
xp=0
for i=2,HeroMaxLevel-1 do
  HeroExpTable[i]=HeroExpTable[i-1]+exp[i-1]
end

 Christmas_night = 0
 Christmas_penguin = 0

HERO_RESPAWN_TIME_BEFORE_10 = 10
MONSTERS_RESPAWN_TIME = 10
WAVE_RESPAWN_TIME = 2
MEAT_DROP_PERC = 35
MILK_DROP_PERC = 35
SKIN_DROP_PERC = 1
EGG_DROP_PERC = 20
EGG_STRONG_DROP_PERC = 30
BONE_DROP_PERC = 20
BONE_STRONG_DROP_PERC = 40
BOSS_DROP_PERC = 100
function InvasionMode:InvasionMap()
     
  
	
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )

	GameRules:SetSameHeroSelectionEnabled(false)
	
 
 
 
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )	
 
 
 	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( true )
	PlayerResource:SetCustomBuybackCost(0,1000)

    GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true ) -- установка кастомной системы урвоней
  	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(HeroExpTable)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(HeroMaxLevel)
 
 
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	--GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )




  		GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR,0.050)


  		
 	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(InvasionMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(InvasionMode, 'InvasionMapGameRulesStateChange'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(InvasionMode, 'InvasionEntityKilled'), self)		
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(InvasionMode, 'InvasionOnNPCSpawn'), self)	
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(InvasionMode, 'OnItemPickedUp'), self)

	LinkLuaModifier("modifier_health", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)  
	LinkLuaModifier("modifier_health_regen", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_mana_regen", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)  
	LinkLuaModifier("modifier_mana", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_damage", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_spell", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)	
	LinkLuaModifier("modifier_health1", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)  
	LinkLuaModifier("modifier_health_regen1", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_mana_regen1", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)  
	LinkLuaModifier("modifier_mana1", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_damage1", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_spell1", "modifiers/modifier_new_year", LUA_MODIFIER_MOTION_NONE)	
	LinkLuaModifier("modifier_portal_unit_vision", "modifiers/modifier_portal_unit_vision", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_portal_despawn_unit", "modifiers/modifier_portal_despawn_unit", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_invasion_difficulty", "modifiers/modifier_invasion_difficulty", LUA_MODIFIER_MOTION_NONE)	
 
	local shop = Entities:FindByName( nil, "dota_shop")

	if shop then
		AddFOWViewer(DOTA_TEAM_BADGUYS, shop:GetAbsOrigin(), 1000, -1, false)
	end

	Difficulty:Init()
end


 function InvasionMode:InvasionMapGameRulesStateChange(data)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		InvasionMode:InvasionGameStart()
	elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
		local presentTime = GameRules:GetDOTATime(false,false)
		if presentTime < 1479 then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for id = 0, 24 do
			local player = PlayerResource:GetPlayer( id )

			if player and not PlayerResource:HasSelectedHero( id ) then
				player:MakeRandomHeroSelection()
			end
		end
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Difficulty:OnHeroSelectionState()
	end 
end

function InvasionMode:OnItemPickedUp(keys)
	print ( '[BAREBONES] OnItemPurchased' )
	DeepPrintTable(keys)

--	local heroEntity = EntIndexToHScript()
	local unit_index = keys.HeroEntityIndex or keys.UnitEntityIndex
	local hero = EntIndexToHScript(unit_index):GetPlayerOwner()
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = keys.PlayerID
	local itemname = keys.itemname
	local owner = EntIndexToHScript( keys.HeroEntityIndex or -1 )
	
	--r = RandomInt(200, 400)	

	if itemname == "item_bonus_health" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_health", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_health_regen" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_health_regen", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana_regen" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_mana_regen", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_mana", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_damage" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_damage", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_spell" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_spell", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory		
    elseif itemname == "item_bonus_health_regen1" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_health_regen1", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana_regen1" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_mana_regen1", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana1" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_mana1", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_damage1" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_damage1", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_spell1" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_spell1", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory	
    elseif itemname == "item_bonus_health1" then
     EmitSoundOn("present", owner) 
               owner:AddNewModifier(owner, nil, "modifier_health1", {  })
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory				
	end
end

  
  function InvasionMode:Christmas_plus()
 Christmas_night = Christmas_night + 1
 
end

  function InvasionMode:Bo_plus()
 Pig_bo_kill = Pig_bo_kill + 1
 
end

  function InvasionMode:Christmas_penguiun_plus()
 Christmas_penguin = Christmas_penguin + 1
 
end

function InvasionMode:OnPlayerLevelUp(keys)
	print ('[BAREBONES] OnPlayerLevelUp')
	DeepPrintTable(keys)

--	local player = EntIndexToHScript(keys.player)
--	local hero = EntIndexToHScript(keys.hero_entindex)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.player_id)
	local level = keys.level
	if hero and level then
		local ability_point = hero:GetAbilityPoints()
		local no_points_levels = {
		[17] = 1,
		[19] = 1,
		[21] = 1,
		[22] = 1,
		[23] = 1,
		[24] = 1,
		}
		if no_points_levels[level] or level >= 34 then
			hero:SetAbilityPoints(ability_point + 1)
		end
	end
end
 
 
function InvasionMode:InvasionOnNPCSpawn(data)
 
	local npc = EntIndexToHScript(data.entindex)
	local name = npc:GetUnitName()

	Difficulty:NPC( npc )
 
 --[[
     if npc:IsRealHero() and npc.FirstSpawned == nil then
        --
        npc.FirstSpawned = true

   
                 npc:AddNewModifier(npc, nil, "modifier_elka_bonus", {  })
                 	npc:SetModifierStackCount("modifier_elka_bonus", nil, (1))
  
 

end
 
 ]]
  
end

function InvasionMode:spawn_last_boss()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "last_boss"):GetAbsOrigin()
	unit = CreateUnitByName("npc_last_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_christmas_boss()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "last_boss"):GetAbsOrigin()
	unit = CreateUnitByName("npc_christmas_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end
 
function InvasionMode:spawn_greevil()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "npc_portal"):GetAbsOrigin()
	unit = CreateUnitByName("npc_greevil", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

--
DEFAULT_DAYTIME = 300
DEFAULT_NIGHTTIME = 300 -- лучше не менять, в этом костыльном говне это значение прописано ещё раз 1000
currentNight = 0

function InvasionMode:NextNight()
	local time = DEFAULT_DAYTIME --+ (math.abs(PlayerResource:GetPlayerCount() - 4) * 60)	
	InvasionMode:NightTimer(time)
end

function InvasionMode:NightTimer(time)
	local timeLeft = time
	Timers:CreateTimer(1.0, function()
		timeLeft = timeLeft - 1		
		CustomGameEventManager:Send_ServerToAllClients( "zpr_time", {time = timeLeft} )
		
		GameRules:SetTimeOfDay(0.3)
		
		if timeLeft <= 0 then
			EmitGlobalSound("Invasion.Night")
			GameRules:SetTimeOfDay(0.8)
			currentNight = currentNight + 1

			if currentNight == 1 then
				InvasionMode:ZombieNight1()
			elseif currentNight == 2 then
				local putin = Entities:FindByName(nil, 'NPC_base')
				UpgradeUnitStats(putin, 1.15)
				InvasionMode:ZombieNight2()  
			elseif currentNight == 3 then
				local putin = Entities:FindByName(nil, 'NPC_base')
				UpgradeUnitStats(putin, 1.15)
				InvasionMode:ZombieNight3()  
			elseif currentNight == 4 then
				local putin = Entities:FindByName(nil, 'NPC_base')
				UpgradeUnitStats(putin, 1.15)
				InvasionMode:ZombieNight4()  
				
				Timers:CreateTimer(DEFAULT_NIGHTTIME, function()
					InvasionMode:UsuallyEnd() 
				end)
				return nil;
			end
			
			Timers:CreateTimer(DEFAULT_NIGHTTIME, function()
				InvasionMode:NextNight()
			end)
			
			return nil;
		end
		
		return 1.0
	end)
end
--

function InvasionMode:InvasionGameStart()

	InvasionMode:InvasionSpawnMoobs()
 	InvasionMode:ThemeMusic()
 
	InvasionMode:NextNight()
      InvasionMode:PortalBoss()  	
 
 
 

end

function InvasionMode:UsuallyEnd()  
 -- Обычнй конец
 	Timers:CreateTimer(0,function()
	         
	    xuitat3 = RandomInt(1,3)
        print(xuitat3)
		if xuitat3 == 1 then
	 	    EmitGlobalSound("Invasion.Castaways")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>The Castaways – Liar Liar</font>", 0, 0) 
		elseif xuitat3 == 2 then
	 	    EmitGlobalSound("Daved Guetta - Would I Lie To You")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>Would I Lie To You - David Guetta, Cedric Gervais, Chris Willis</font>", 0, 0) 		
		else
	 	    EmitGlobalSound("Sergey")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>Серега пират - АМ ФП</font>", 0, 0) 
        end	
              
         
 --       	 	    EmitGlobalSound("Bobby Helms - Jingle bell")
	--	    GameRules:SendCustomMessage("<font color='#58ACFA'>Bobby Helms - Jingle bell</font>", 0, 0) 
		     
	end)  
	
	Timers:CreateTimer(48,function()
		GameRules:SendCustomMessage("#laughter", 0, 0)
	end)

	Timers:CreateTimer(49,function()
		GameRules:SendCustomMessage("#laughter", 0, 0) 
		GameRules:SendCustomMessage("#laughter_2", 0, 0) 
														    		 
	end)
	
	Timers:CreateTimer(50,function()
		GameRules:SendCustomMessage("#laughter_3", 0, 0) 
		GameRules:SendCustomMessage("#laughter_4", 0, 0) 
		GameRules:SendCustomMessage("#laughter_5", 0, 0) 
	end)
	
	Timers:CreateTimer(51,function()
	    GameRules:SendCustomMessage("#laughter_3", 0, 0) 
		GameRules:SendCustomMessage("#laughter_6", 0, 0) 
		GameRules:SendCustomMessage("#laughter_5", 0, 0) 
	end)
	
	Timers:CreateTimer(52,function()
		GameRules:SendCustomMessage("#laughter_3", 0, 0) 
		GameRules:SendCustomMessage("#laughter_4", 0, 0) 
		GameRules:SendCustomMessage("#laughter_5", 0, 0) 
	end)
	
	Timers:CreateTimer(53,function()
		GameRules:SendCustomMessage("#laughter_3", 0, 0) 
		GameRules:SendCustomMessage("#laughter_7", 0, 0) 
		GameRules:SendCustomMessage("#laughter_8", 0, 0) 
	end)
	
	Timers:CreateTimer(60,function()
		    EmitGlobalSound("Asgore_Intro_classic")
	end)
	
 
	
	Timers:CreateTimer(62, function() GameRules:SendCustomMessage("#begining_1",0,0) end)
	
	Timers:CreateTimer(70, function() GameRules:SendCustomMessage("#begining_2",0,0) end)
	
	Timers:CreateTimer(78, function() GameRules:SendCustomMessage("#begining_3",0,0) end)
	
	Timers:CreateTimer(80,function()
       InvasionMode:spawn_last_boss()
	end)
	
	Timers:CreateTimer(50,function()
 
				if xuitat3 == 1 then
	 	    StopGlobalSound("Invasion.Castaways")    
 
		elseif xuitat3 == 2 then
	 	    StopGlobalSound("Daved Guetta - Would I Lie To You")
 	
		else
	 	    StopGlobalSound("Sergey")
 
        end	
	 
	--  StopGlobalSound("Bobby Helms - Jingle bell")
	end)
end
 
 function InvasionMode:ChristmassEror()  
 
	Timers:CreateTimer(0,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)

	Timers:CreateTimer(1,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	
	Timers:CreateTimer(2,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(3,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(4,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(5,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(6,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(7,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(8,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(9,function()
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
		GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX CHRISTMAS WAS NOT FOUND</font>", 0, 0)
	end)
	Timers:CreateTimer(15,function()
		GameRules:SendCustomMessage('<font color="#58ACFA">PROTOCOL "The end of the world" WAS STARTED</font>', 0, 0)
	end)
 
end


 function InvasionMode:ChristmasEnd()  
 -- Новогодний конец
InvasionMode:ChristmasMusic()
   		EmitGlobalSound("ho_ho_ho")
	Timers:CreateTimer(0, function() GameRules:SendCustomMessage("#christmas_night_1",0,0) end)
	Timers:CreateTimer(90, function() GameRules:SendCustomMessage("#christmas_night_3",0,0) end)
	Timers:CreateTimer(210, function() GameRules:SendCustomMessage("#christmas_night_2",0,0) end)

 
	Timers:CreateTimer(225, function()  
 InvasionMode:spawn_greevil()
end)
	Timers:CreateTimer(300,function()
  		 InvasionMode:ChristmasNight()       
	end)  

	Timers:CreateTimer(602,function()
	EmitGlobalSound("christmas_ne_Bydet")
	InvasionMode:ChristmassEror()
	end)

 
	Timers:CreateTimer(634,function()
	EmitGlobalSound("christmas_boss_begin")
	end)
 	Timers:CreateTimer(646,function()
   InvasionMode:spawn_christmas_boss()
	end)
 
 end
  
	    local zombie_count = 0 
	    local zombie_update = 0 

function InvasionMode:ZombieNight1()  
 -- 1 НОЧЬ
 
	local wave = 0	
	
 	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_wave_zombie",18)
	end)
	
	Timers:CreateTimer(0, function()
	     while wave < 29 do
		     wave = wave + 1
 
		     return 10
		 end			 
	end)
 
	Timers:CreateTimer(60, function()
	     while wave <  28 do 
		     self:SpawnZombie("npc_zombie_toxic",1)
		 return 60
		 end
	end)

	Timers:CreateTimer(90, function()
	     while wave <  29 do 
		     self:SpawnZombie("npc_seerdying",1)
		 return 90
		 end
	end)		
 
 	Timers:CreateTimer(155,function()
 		   print(zombie_count)
 		   if zombie_count < 40 then 
             zombie_update = zombie_update + 1 
            end
		 self:SpawnZombie("npc_undying",1)
	end)

	Timers:CreateTimer(225,function()
		local zombie_boss_1 =  RandomInt(1,2)
		if zombie_boss_1 == 1 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_half_zombie",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_half_zombie", 1)
		elseif zombie_boss_1 == 2 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_big_zombie",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_big_zombie", 1)
	     end
	end) 

 
  
 
end
 
 	    local zombie_count_2 = 0 
        local ghost_count_2 = 0

	    local zombie_update_2 = 0 

 function InvasionMode:ZombieNight2()  
 -- 2 НОЧЬ

    local wave_2 = 0

 	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_wave_big_zombie",16)
		 self:SpawnGhost("npc_classic_wave_ghost",8)
	end)
	
 	Timers:CreateTimer(0, function()
	     while wave_2 < 29 do
		     wave_2 = wave_2 + 1
 
		     return 10
		 end			 
	end)
 

 

	Timers:CreateTimer(50, function()
	     while wave_2 <  28 do 
		     self:SpawnZombie("npc_zombie_toxic_2",1)
		 return 50
		 end
	end)

	Timers:CreateTimer(90, function()
	     while wave_2 <  29 do 
		     self:SpawnZombie("npc_seerdying_2",1)
		 return 100
		 end
	end)	
	
 

 	Timers:CreateTimer(140,function()
 			 		   print(zombie_count_2)
 		   if zombie_count_2 < 105 then 
             zombie_update_2 = zombie_update_2 + 1 
            end
	end)

	Timers:CreateTimer(90,function()
		 self:SpawnZombie("npc_undying_2",1)
	end)
 
	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_2",1)
	end)
	 
	Timers:CreateTimer(225,function()
		local zombie_boss_2 =  RandomInt(1,3)
		if zombie_boss_2 == 1 then 
		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_suicide",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_suicide", 1)
		elseif zombie_boss_2 == 2 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_necr",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_necr", 1)
		elseif zombie_boss_2 == 3 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_meatgolem",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_meat_golem", 1)		  
	     end
	end) 	
 

end
 	 
 	    local zombie_count_3 = 0 
        local ghost_count_3 = 0

	    local zombie_update_3 = 0 

function InvasionMode:ZombieNight3()  	
  -- 3 НОЧЬ 
 
    local wave_3 = 0
	
  	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_wave_ghoul",16)
		 self:SpawnGhost("npc_classic_wave_ghost_2",8)
	end)
	
	Timers:CreateTimer(0, function()
	     while wave_3 < 30 do
			 wave_3 = wave_3 + 1
			 
 
		     return 10
		 end			 
	end)

 
 

	Timers:CreateTimer(40, function()
	     while wave_3 <  28 do 
		     self:SpawnZombie("npc_zombie_toxic_3",1)
		 return 40
		 end
	end)
 
 	Timers:CreateTimer(90, function()
	     while wave_3 <  29 do 
		     self:SpawnZombie("npc_seerdying_3",1)
		 return 90
		 end
	end)	
	

 	Timers:CreateTimer(140,function()
 			 		   print(zombie_count_3)
 		   if zombie_count_3 < 105 then 
             zombie_update_3 = zombie_update_3 + 1 
            end
	end)


	Timers:CreateTimer(90,function()
		 self:SpawnZombie("npc_undying_3",1)
	end)

	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_3",1)
	end)
	
 
 	Timers:CreateTimer(225,function()
		local zombie_boss_3 =  RandomInt(1,3)
		if zombie_boss_3 == 1 then 
		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_ghost",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_ghost", 1)
		elseif zombie_boss_3 == 2 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_pudge",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_pudge", 1)
		elseif zombie_boss_3 == 3 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_undying",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_undying", 1)		  
	     end
	end) 	
 
 
	

 
 
 end
 
  	    local zombie_count_4 = 0 
        local ghost_count_4 = 0

	    local zombie_update_4 = 0 

 function InvasionMode:ZombieNight4()  
   -- 4 НОЧЬ 
  
    local wave_4 = 0
	
  	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_wave_pudge",16)
		 self:SpawnGhost("npc_classic_wave_ghost_3",8)
	end)
	
	Timers:CreateTimer(0, function()
	     while wave_4 < 30 do
			 wave_4 = wave_4 + 1
			 
 
		     return 10
		 end			 
	end)

	
 

	Timers:CreateTimer(0, function()
	    while wave_4 < 26 do 
		     local unit_count = 3 * (1 + wave_4%2)
			 
 
			 self:SpawnGhost("npc_classic_wave_ghost_boss",1)
		     return 30
		end
	end)


	Timers:CreateTimer(260, function()
	    while wave_4 < 29 do 
		     local unit_count = 1 * (1 + wave_4%2)
			 
 
			 self:SpawnGhost("npc_classic_wave_ghost_boss",1)
		     return 30
		end
	end)

	Timers:CreateTimer(35, function()
	     while wave_4 <  28 do 
		     self:SpawnZombie("npc_zombie_toxic_4",1)
		 return 35
		 end
	end)
 
  	Timers:CreateTimer(90, function()
	     while wave_4 <  29 do 
		     self:SpawnZombie("npc_seerdying_4",1)
		 return 90
		 end
	end)	
	
 	Timers:CreateTimer(140,function()
 			 		   print(zombie_count_4)
 		   if zombie_count_4 < 105 then 
             zombie_update_4 = zombie_update_4 + 1 
            end
	end)
  
	
	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_4",1)
	end)
 
	
 
	
  	Timers:CreateTimer(260,function()
 		 self:SpawnFlash("npc_flash_golem_3")
	end)
 
 
end

function InvasionMode:ChristmasNight()  
   -- 4 НОЧЬ 
  
    local wave_4 = 0
	
  	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_new_years",8)
		 self:SpawnGhost("npc_classic_new_years_lich",1)
	end)
	
	Timers:CreateTimer(0, function()
	     while wave_4 < 29 do
			 wave_4 = wave_4 + 1
			 
			 local unit_count = 4
		     self:SpawnZombie("npc_classic_new_years", unit_count)
		     return 10
		 end			 
	end)

		Timers:CreateTimer(0, function()
	    while wave_4 < 29 do 
 
 
			  self:SpawnGhost("npc_classic_new_years_lich",1)
		     return 25
		end
	end)

 			 
		    

	Timers:CreateTimer(0, function()
	    while wave_4 < 29 do 
 
 
			 self:SpawnGhost("npc_classic_new_years_winterwyvern",1)
		     return 30
		end
	end)


 

 
  	Timers:CreateTimer(90, function()
	     while wave_4 <  29 do 
		     self:SpawnZombie("npc_classic_new_years_seer",1)
		 return 90
		 end
	end)	
	
 
    	Timers:CreateTimer(90, function()
	     while wave_4 <  29 do 
		     self:SpawnZombie("npc_classic_new_years_ancient",1)
		 return 50
		 end
	end) 
 
end


 function InvasionMode:PortalBoss()  
 -- Новогодний конец
 
 
	
  local boss_list = {
		"npc_invasion_portal_wd",
		"npc_invasion_portal_warlock",
		"npc_invasion_portal_necr",
		"npc_invasion_portal_veno"
	}
   	Timers:CreateTimer(1202, function()
          local unit_Name = boss_list[RandomInt(1, #boss_list)] 
      	local spawners = Entities:FindAllByName("zspawn_point")
 		local spawner = spawners[RandomInt(1, #spawners)]     	
         	local unit = CreateUnitByName( unit_Name, spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
         	unit:AddNewModifier( unit, nil, "modifier_portal_unit_vision", nil )
           	unit:AddNewModifier( unit, nil, "modifier_portal_despawn_unit", nil )       	
            GameRules:SendCustomMessage("#Game_notification_portal_boss",0,0)
      end) 
    	Timers:CreateTimer(1502, function()
          local unit_Name = boss_list[RandomInt(1, #boss_list)] 
      	local spawners = Entities:FindAllByName("zspawn_point")
 		local spawner = spawners[RandomInt(1, #spawners)]     	
         	local unit = CreateUnitByName( unit_Name, spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
         		UpgradeUnitStats(unit, 1.5)
         	unit:AddNewModifier( unit, nil, "modifier_portal_unit_vision", nil )
           	unit:AddNewModifier( unit, nil, "modifier_portal_despawn_unit", nil )       	
            GameRules:SendCustomMessage("#Game_notification_portal_boss",0,0)
      end) 
     	Timers:CreateTimer(1802, function()
          local unit_Name = boss_list[RandomInt(1, #boss_list)] 
      	local spawners = Entities:FindAllByName("zspawn_point")
 		local spawner = spawners[RandomInt(1, #spawners)]     	
         	local unit = CreateUnitByName( unit_Name, spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
         		UpgradeUnitStats(unit, 2.0)
         	unit:AddNewModifier( unit, nil, "modifier_portal_unit_vision", nil )
           	unit:AddNewModifier( unit, nil, "modifier_portal_despawn_unit", nil )       	
            GameRules:SendCustomMessage("#Game_notification_portal_boss",0,0)
      end) 
    	Timers:CreateTimer(2102, function()
          local unit_Name = boss_list[RandomInt(1, #boss_list)] 
      	local spawners = Entities:FindAllByName("zspawn_point")
 		local spawner = spawners[RandomInt(1, #spawners)]     	
         	local unit = CreateUnitByName( unit_Name, spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
         		UpgradeUnitStats(unit, 2.5)
         	unit:AddNewModifier( unit, nil, "modifier_portal_unit_vision", nil )
           	unit:AddNewModifier( unit, nil, "modifier_portal_despawn_unit", nil )       	
            GameRules:SendCustomMessage("#Game_notification_portal_boss",0,0)
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

 
function InvasionMode:SpawnFlash(unit_name)
	local point = nil
	local unit = nil
 
	point = Entities:FindByName( nil, "last_boss"):GetAbsOrigin()
	unit = CreateUnitByName(unit_name, point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:SpawnGhost(unit_name, unit_count)
	local points = Entities:FindAllByName("ghost_spawner")

	for i=1, unit_count do
		local point = points[RandomInt(1, #points)]
		local unit = CreateUnitByName(unit_name, point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		unit:SetInitialGoalEntity(point)
	end
end

function InvasionMode:SpawnBoss(unit_name, unit_count)
 

	for i=1, unit_count do
		local point =  Entities:FindByName( nil, "golem_spawner"):GetAbsOrigin()
		local unit = CreateUnitByName(unit_name, point, true, nil, nil, DOTA_TEAM_BADGUYS)
 	unit:SetForwardVector(RandomVector(1))
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


 function InvasionMode:spawngulya() -- Вызывание свина 
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться


	--bosses
	point = Entities:FindByName( nil, "boss_spawner_3"):GetAbsOrigin()
	unit = CreateUnitByName("npc_boss_dead_pig", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

 

function GiveGoldPlayers( gold )
	for index=0 ,5 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			hero:ModifyGold(gold, false, 0)
			SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, hero, gold, nil )
		end
	end
end
 
      local pig_count = 0
 
 function InvasionMode:CreateDrop (itemName, pos)
   local newItem = CreateItem(itemName, nil, nil)
   newItem:SetPurchaseTime(0)
   CreateItemOnPositionSync(pos, newItem)
   newItem:LaunchLoot(false, 300, 0.75, pos + RandomVector(RandomFloat(50, 350)))
end

function InvasionMode:InvasionEntityKilled (data)
    local time = GameRules:GetDOTATime(false, false)
	local killedEntity = EntIndexToHScript(data.entindex_killed)
 
 	if killedEntity:IsRealHero() and killedEntity:IsReincarnating() == false then
 		if killedEntity:GetLevel() <= 10 then 
		killedEntity:SetTimeUntilRespawn( HERO_RESPAWN_TIME_BEFORE_10 )
	else 
		killedEntity:SetTimeUntilRespawn( killedEntity:GetLevel() )		
	end
	end

	if killedEntity:GetUnitName() == "NPC_base" then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		EmitGlobalSound("Invasion.HommerWin")
	end	

   if Pig_bo_kill == 0 then 
	if killedEntity:GetUnitName() == "npc_boss_pig" then		 
              self:CreateDrop("item_bag_of_gold_pig", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )
              self:CreateDrop("item_big_meat", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )
 
	end	
end 
--*************************************** NIGHT SPAWN ***************************************
 
 

 

 

     if killedEntity:GetUnitName() == "npc_classic_wave_zombie" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
 
    
 
	         for i=1, 1 do
		         zombie_count = zombie_count + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 	         

                     if zombie_update == 1 then 
        	             if zombie_count < 105 then 
        	                 	 SetExpUsually(unit, 26)
        	                	 SetGoldUsually(unit, 5)
       	                  	     GiveGoldPlayers(5)
       	                     elseif zombie_count < 238 then 
          	                     SetGoldUsually(unit, -1)
           	                  	 GiveGoldPlayers(2)
           	                  	 SetExpUsually(unit, -8)
      	                     elseif zombie_count > 238 then 
          	                     SetGoldUsually(unit, -2)
           	                  	 GiveGoldPlayers(1)
           	                  	 SetExpUsually(unit, -20)
      	                 end
       	             else
               
        	             if zombie_count < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
             	            	 GiveGoldPlayers(2)
           	             elseif  zombie_count < 238 then 
          	                     SetGoldUsually(unit, -1)
           	                  	 GiveGoldPlayers(2)
           	                  	 SetExpUsually(unit, -8)
            	             elseif  zombie_count > 238 then 
          	                     SetGoldUsually(unit, -2)
           	                  	 GiveGoldPlayers(1)
           	                  	 SetExpUsually(unit, -20)
             	         end
	       	         end      
           	 end	                        
	   	 end             
     end
 
      if killedEntity:GetUnitName() == "npc_classic_wave_big_zombie" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
 
    
 
	         for i=1, 1 do
		         zombie_count_2 = zombie_count_2 + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_big_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 	           

      	             if zombie_update_2 == 1 then 
        	             if zombie_count_2 < 105 then 
        	                 	 SetExpUsually(unit, 25)
        	                	 SetGoldUsually(unit, 7)
       	                  	     GiveGoldPlayers(15)
       	                     elseif zombie_count_2 < 245 then 
          	                     SetGoldUsually(unit, -2)
           	                  	 GiveGoldPlayers(5)
           	                  	 SetExpUsually(unit, -7)
      	                     elseif zombie_count_2 > 245 then 
          	                     SetGoldUsually(unit, -3)
           	                  	 GiveGoldPlayers(2)
           	                  	 SetExpUsually(unit, -30)
      	                 end
       	             else
               
        	             if zombie_count_2 < 155 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
             	            	 GiveGoldPlayers(7)
           	             elseif  zombie_count_2 < 245 then 
          	                     SetGoldUsually(unit, -2)
           	                  	 GiveGoldPlayers(5)
           	                  	 SetExpUsually(unit, -7)
            	             elseif  zombie_count_2 > 245 then 
          	                     SetGoldUsually(unit, -3)
           	                  	 GiveGoldPlayers(2)
           	                  	 SetExpUsually(unit, -30)
             	         end
	       	         end    
           	 end	                        
	   	 end             
     end

      if killedEntity:GetUnitName() == "npc_classic_wave_ghost" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("ghost_spawner")
 
    
 
	         for i=1, 1 do
		         ghost_count_2 = ghost_count_2 + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_ghost", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 
        	             if ghost_count_2 < 40 then 
         	                     SetGoldUsually(unit, 0)
           	                  	 GiveGoldPlayers(4)
           	                  	 SetExpUsually(unit, 0)
           	             elseif  ghost_count_2 < 80 then 
         	                     SetGoldUsually(unit, -20)
             	            	 GiveGoldPlayers(3)
           	                  	 SetExpUsually(unit, -20)
           	             elseif  ghost_count_2 > 80 then 
         	                     SetGoldUsually(unit, -32)
             	            	 GiveGoldPlayers(2)
           	                  	 SetExpUsually(unit, -30)
             	         end
	       	            
           	 end	                        
	   	 end             
     end
 
      if killedEntity:GetUnitName() == "npc_classic_wave_ghoul" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
 
    
 
	         for i=1, 1 do
		         zombie_count_3 = zombie_count_3 + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_ghoul", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 	           

      	             if zombie_update_3 == 1 then 
        	             if zombie_count_3 < 105 then 
        	                 	 SetExpUsually(unit, 80)
        	                	 SetGoldUsually(unit, 20)
       	                  	     GiveGoldPlayers(35)
       	                     elseif zombie_count_3 < 245 then 
          	                     SetGoldUsually(unit, -4)
           	                  	 GiveGoldPlayers(15)
           	                  	 SetExpUsually(unit, -35)
      	                     elseif zombie_count_3 > 245 then 
          	                     SetGoldUsually(unit, -12)
           	                  	 GiveGoldPlayers(5)
           	                  	 SetExpUsually(unit, -60)
      	                 end
       	             else
               
        	             if zombie_count_3 < 155 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
             	            	 GiveGoldPlayers(15)
           	             elseif  zombie_count_3 < 245 then 
          	                     SetGoldUsually(unit, -4)
           	                  	 GiveGoldPlayers(15)
           	                  	 SetExpUsually(unit, -40)
            	             elseif  zombie_count_3 > 245 then 
          	                     SetGoldUsually(unit, -12)
           	                  	 GiveGoldPlayers(5)
           	                  	 SetExpUsually(unit, -100)
             	         end
	       	         end    
           	 end	                        
	   	 end             
     end

      if killedEntity:GetUnitName() == "npc_classic_wave_ghost_2" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("ghost_spawner")
 
    
 
	         for i=1, 1 do
		         ghost_count_3 = ghost_count_3 + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_ghost_2", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 
        	             if ghost_count_3 < 40 then 
         	                     SetGoldUsually(unit, 0)
           	                  	 GiveGoldPlayers(7)
           	                  	 SetExpUsually(unit, 0)
           	             elseif  ghost_count_3 < 80 then 
         	                     SetGoldUsually(unit, -45)
             	            	 GiveGoldPlayers(6)
           	                  	 SetExpUsually(unit, -40)
           	             elseif  ghost_count_3 > 80 then 
         	                     SetGoldUsually(unit, -32)
             	            	 GiveGoldPlayers(4)
           	                  	 SetExpUsually(unit, -85)
             	         end
	       	            
           	 end	                        
	   	 end             
     end

      if killedEntity:GetUnitName() == "npc_classic_wave_pudge" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
 
    
 
	         for i=1, 1 do
		         zombie_count_4 = zombie_count_4+ 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_pudge", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 	           

      	             if zombie_update_4 == 1 then 
        	             if zombie_count_4 < 105 then 
        	                 	 SetExpUsually(unit, 160)
        	                	 SetGoldUsually(unit, 30)
       	                  	     GiveGoldPlayers(50)
       	                     elseif zombie_count_4 < 216 then 
          	                     SetGoldUsually(unit, -6)
           	                  	 GiveGoldPlayers(13)
           	                  	 SetExpUsually(unit, -60)
      	                     elseif zombie_count_4 > 216 then 
          	                     SetGoldUsually(unit, -10)
           	                  	 GiveGoldPlayers(9)
           	                  	 SetExpUsually(unit, -90)
      	                 end
       	             else
               
        	             if zombie_count_4 < 155 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
             	            	 GiveGoldPlayers(17)
           	             elseif  zombie_count_4 < 245 then 
          	                     SetGoldUsually(unit, -6)
           	                  	 GiveGoldPlayers(13)
           	                  	 SetExpUsually(unit, -60)
            	             elseif  zombie_count_4 > 245 then 
          	                     SetGoldUsually(unit, -10)
           	                  	 GiveGoldPlayers(9)
           	                  	 SetExpUsually(unit, -90)
             	         end
	       	         end    
           	 end	                        
	   	 end             
     end

      if killedEntity:GetUnitName() == "npc_classic_wave_ghost_3" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("ghost_spawner")
 
    
 
	         for i=1, 1 do
		         ghost_count_4 = ghost_count_4 + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_ghost_3", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 
        	             if ghost_count_4 < 40 then 
         	                     SetGoldUsually(unit, 0)
           	                  	 GiveGoldPlayers(17)
           	                  	 SetExpUsually(unit, 0)
           	             elseif  ghost_count_4 < 80 then 
         	                     SetGoldUsually(unit, -40)
             	            	 GiveGoldPlayers(12)
           	                  	 SetExpUsually(unit, -40)
           	             elseif  ghost_count_4 > 80 then 
         	                     SetGoldUsually(unit, -60)
             	            	 GiveGoldPlayers(7)
           	                  	 SetExpUsually(unit, -90)
             	         end
	       	            
           	 end	                        
	   	 end             
     end
--*************************************** END SPAWN ***************************************

if killedEntity:GetUnitName() == "npc_last_boss" then
     EndGame:GoodEnd()
     	   GameRules:SetTimeOfDay(0.25)
end

if killedEntity:GetUnitName() == "npc_christmas_boss" then
    EndGame:ChristmasEnd()
     	   GameRules:SetTimeOfDay(0.25)
end

if killedEntity:GetUnitName() == "npc_boss_dead_pig" then
      EmitGlobalSound("vurdalak_1")
end

 

 
if killedEntity:GetUnitName() == "npc_classic_pig" then
 
pig_count = pig_count+1
 
 
    if pig_count == 650 then		 
	        InvasionMode:spawngulya()		      
	        EmitGlobalSound("vurdalak")		
		 
    end
end

 
	if 	killedEntity:GetUnitName() == "npc_undying"		then 	GiveGoldPlayers(350)
	   elseif killedEntity:GetUnitName() == "npc_seerdying"		then 	GiveGoldPlayers(250)
	   elseif killedEntity:GetUnitName() == "npc_undying_2"		then 	GiveGoldPlayers(450)
	   elseif killedEntity:GetUnitName() == "npc_seerdying_2"		then 	GiveGoldPlayers(350)
       elseif killedEntity:GetUnitName() == "npc_flash_golem"		then 	GiveGoldPlayers(1250)
       elseif killedEntity:GetUnitName() == "npc_undying_3"		then 	GiveGoldPlayers(600)
       elseif killedEntity:GetUnitName() == "npc_seerdying_3"		then 	GiveGoldPlayers(400)
       elseif killedEntity:GetUnitName() == "npc_flash_golem_2"		then 	GiveGoldPlayers(1550)
        elseif killedEntity:GetUnitName() == "npc_undying_4"		then 	GiveGoldPlayers(825)      
        elseif killedEntity:GetUnitName() == "npc_seerdying_4"		then 	GiveGoldPlayers(550) 
	   elseif killedEntity:GetUnitName() == "npc_flash_golem_3"		then 	GiveGoldPlayers(2230)
	     elseif killedEntity:GetUnitName() == "npc_classic_new_years"		then 	GiveGoldPlayers(25)
       elseif killedEntity:GetUnitName() == "npc_classic_new_years_ancient"		then 	GiveGoldPlayers(3100)
	end
 
 
 

end
 

function InvasionMode:ThemeMusic()
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
		"RSAC - NBA",
		"Daved Guetta - Would I Lie To You",
		 "Sia - Chandelier",
		"Does It Matter - Janieck",	  			
    	},
        }	 
     	--[[  	         	 
   [1] = {
 "Merry - Christmas Jingle Bells",  
  "Jingle Вells" ,
  "Lofi Origin - Jingle Bells Lo Fi Chill",
  },
  
  	       
    	[2] = {
  		    "Aurélie - Jingle Bells", 
  		    "Ансамбль Детские Песни - Три белых коня",
  		    "Дискотека Авария - Новогодняя",
 
    	},

     	[3] = {
  		    "Дима Билан - Новый Год с новой строчки",
  		    "ABBA - Happy New Year",
  		    "O Liebert - Jinggle Bells",  
  		    "WELCOME TO THE CUM ZONE - ONLY CUM INSIDE ANIME GIRLS",
    	},
    
 
     	   	     
     	[4] = {
		"Jinggle bells - Remix",
		"Wham! - Last Christmas",
 		
    	},
     
   ]] 
 	night_music =
 	{
 
 		[1] = {
			"Undertale - Respite",
		},

 		[2] = {
	 		"C418-Key",
 		},
 		[3] = {
			"Argh Ost – Halloween",
 		},
 		[4] = {
	 		"C418-Key",
			"Undertale - Respite",
			"Argh Ost – Halloween",  
 		},
 --[[
 
 		[1] = {
			"Кошмар перед рождеством - End Title",
		},

 		[2] = {
	 		"Dinah Washington - Silent Night",
 		},
 		[3] = {
			"Кошмар перед рождеством - Oogie Boogie39s Song",
 		},
 		[4] = {
	 		"Кошмар перед рождеством - Making Christmas",
 
 		},
  ]]
 	}
 	local last_music = nil

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
 
	     --[[ 	
      local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
     
        local building = allBuildings[i]
        building:AddNewModifier(building, nil, "modifier_invulnerable", {}) 
 
end
 ]]
	    else
	    	music = day_music[current_day]
	    	time_until_end = 300 - day_time
	    	print("day time")
 --[[ 
     local allBuildings = Entities:FindAllByClassname('npc_dota_building')

    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        building:RemoveModifierByName('modifier_invulnerable')
 
end
 ]]
	    end

 
		print("time until night = "..time_until_end)
		if last_music then
			Sounds:RemoveGlobalLoopingSound( last_music )
		end

	    local current_music = nil
	    local longest_music = music[1]
	    local longest_music_len = Sounds:GetSoundDuration(music[1])
	    local shortest_music = music[1]
	    local shortest_music_len = Sounds:GetSoundDuration(music[1])
	    local midle_music = music[1]
	    local midle_music_len = Sounds:GetSoundDuration(music[1])
	    local available_music = {}
 
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

	    if time_until_end >= shortest_music_len then
	    	for _, sound in pairs(music) do
	    		local music_len = Sounds:GetSoundDuration(sound)
	    		if music_len <= time_until_end then
	    			table.insert(available_music, sound)
	    			print(string.format("sound name = %s",sound))
	    		end
	    	end
	    	current_music = available_music[RandomInt(1, #available_music)]

	    else
	    	return time_until_end+1
	    end

 
 
	    Sounds:CreateGlobalLoopingSound( current_music )
 
 
	    GameRules:SendCustomMessage("<font color='#58ACFA'>"..current_music.."</font>", 0, 0)
 
	    print(string.format("sound  = %s ; sound duration = %d",current_music,Sounds:GetSoundDuration(current_music)))
	    last_music = current_music 

	    return Sounds:GetSoundDuration(current_music)		    
	end)
 end
 function InvasionMode:ChristmasMusic()
 	
	day_music =
    { 	
 
     	[5] = {
		"Bobby Helms - Jingle bell",
		"Wham! - Last Christmas",
		"Aurélie - Jingle Bells",
 		"Дима Билан - Новый Год с новой строчки",
    	},
    }
 
 	night_music =
 	{
 
 		[5] = {
	 		"Кошмар перед рождеством - Making Christmas",
 
 		},

 	}
 
 
 

end

 