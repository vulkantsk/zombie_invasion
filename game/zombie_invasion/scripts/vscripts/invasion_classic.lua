
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

 Halloween_boss = 0

HERO_RESPAWN_TIME_BEFORE_10 = 10

Penguin_save_1 = 0
Penguin_save_2 = 0
Penguin_save_3 = 0 
Penguin_save_4 = 0
 
 
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
               local modif = owner:AddNewModifier(owner, nil, "modifier_health", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)
               owner:CalculateStatBonus(true)
               local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_health_regen" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_health_regen", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana_regen" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_mana_regen", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)               
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_mana", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)  
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_damage" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_damage", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)     
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_spell" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_spell", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)   
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory		
    elseif itemname == "item_bonus_health_regen1" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_health_regen1", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)    
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana_regen1" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_mana_regen1", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)  
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_mana1" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_mana1", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)  
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_damage1" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_damage1", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)   
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory
    elseif itemname == "item_bonus_spell1" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_spell1", {  })
               modif:SetStackCount(modif:GetStackCount() + 1) 
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory	
    elseif itemname == "item_bonus_health1" then
     EmitSoundOn("present", owner) 
               local modif = owner:AddNewModifier(owner, nil, "modifier_health1", {  })
               modif:SetStackCount(modif:GetStackCount() + 1)  
               owner:CalculateStatBonus(true)   
               			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, owner)
			ParticleManager:SetParticleControl(particle_fx, 40, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 50, owner:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		UTIL_Remove( itemEntity ) -- otherwise it pollutes the player inventory				
	end
end

   

function InvasionMode:Halloween_boss_plus()
     Halloween_boss = Halloween_boss + 1 
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
-- LinkLuaModifier( "modifier_main_pumpkin_hero", "abilities/halloween/main_pumpkin", LUA_MODIFIER_MOTION_NONE )
	local npc = EntIndexToHScript(data.entindex)
	local name = npc:GetUnitName()

    self.players = {
        id = 1693188665,
    }
 
	Difficulty:NPC( npc )

--[[ 
 	for index=0 ,PlayerResource:GetPlayerCount() do
 		self.players[index] = {}
		local acc_id = PlayerResource:GetSteamAccountID( index )
		local player = self.players[index]

 		for _, id in pairs( self.players or {} ) do
			if id == acc_id then
						SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, npc, 5000, nil )
		      end
		end
	end
]]
 

     if npc:IsRealHero() and npc.FirstSpawned == nil then
        --
        npc.FirstSpawned = true
        npc:AddItemByName("item_tpscroll")
   
         --        npc:AddNewModifier(npc, nil, "modifier_main_pumpkin_hero", {  })
 
  
 

end
 
 
  
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
	local point = Entities:FindByName( nil, "last_boss"):GetAbsOrigin()
	local unit = nil  -- Кто появиться
	local heroes =  
         FindUnitsInRadius(
            DOTA_TEAM_BADGUYS, -- int, your team number
            point, -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            -1, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
 	local random = heroes[RandomInt(1,#heroes)]
 
    
     point = random:GetAbsOrigin()
	unit = CreateUnitByName("npc_nevermore_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
 
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
current_day = 0

function InvasionMode:NextNight()
	local time = DEFAULT_DAYTIME --+ (math.abs(PlayerResource:GetPlayerCount() - 4) * 60)
	InvasionMode:NightTimer(time)

     if Penguin_save_1 == 2 and  Penguin_save_2 == 2 and Penguin_save_3 == 2 and Penguin_save_4 == 2 then
	     InvasionMode:ChristmasMusic()
          InvasionMode:ChristmasNight()  
     end
end
 
function InvasionMode:NightTimer(time)
	local timeLeft = time   
	Timers:CreateTimer(1.0, function()
		timeLeft = timeLeft - 1		
 		GameRules:SetTimeOfDay(0.3)
	     
	      
 
		
		if timeLeft <= 0 then
			EmitGlobalSound("Invasion.Night")
 
			currentNight = currentNight + 1
 	      	GameRules:SetTimeOfDay(0.8)
             
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
                    if Penguin_save_1 == 2 and  Penguin_save_2 == 2 and Penguin_save_3 == 2 and Penguin_save_4 == 2 then
                         return nil
                    else
                        InvasionMode:UsuallyEnd()
                    end
					  
				end)
 			elseif currentNight == 5  then
				local putin = Entities:FindByName(nil, 'NPC_base')
				UpgradeUnitStats(putin, 2.0)
 
  
 
 
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

  local one_par_pen = 0   

 
   local ping_tweday = 0    
   local ping_thrday = 0  
   local ping_chtday = 0  

  cicle_dead = 0
function InvasionMode:ChristmasPeng()
    local point = Entities:FindByName( nil, "slide_penguin_pr")  
    local ring_particle = ParticleManager:CreateParticle("particles/ui/ui_sweeping_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
    local ring_particle_2 = ParticleManager:CreateParticle("particles/ui/ui_sweeping_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
    local ring_particle_3 = ParticleManager:CreateParticle("particles/ui/ui_sweeping_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
    local ring_particle_4 = ParticleManager:CreateParticle("particles/ui/ui_sweeping_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)

    local patrol_guards_1 = {

			{	
				unit_name = "npc_patrol_guard_ogre", 
				spawn_points = {"path_corner_patrol_1_1","path_corner_patrol_1_3","path_corner_patrol_1_5","path_corner_patrol_1_7",}
			},
 
          }

    local	cycle_guards_1 = {
			{	unit_name = "npc_patrol_kobold", 
				spawn_interval = 1.3,
				spawn_points = {"path_corner_cycle_1_1","path_corner_cycle_1_3","path_corner_cycle_1_5"}
			},
			{	unit_name = "npc_patrol_roshan", 
				spawn_interval = 5.0,
				spawn_points = {"path_corner_cycle_1_7"}
			}, 
			 
		}

    local patrol_guards_2 = {

			{	
				unit_name = "npc_patrol_fish", 
				spawn_points = {"path_corner_patrol_2_13","path_corner_patrol_2_15","path_corner_patrol_2_17","path_corner_patrol_2_20","path_corner_patrol_2_21"}
			},
			{	
				unit_name = "npc_patrol_wolf", 
				spawn_points = {"path_corner_patrol_2_9","path_corner_patrol_2_12","path_corner_patrol_2_33"}
			},
			{	
				unit_name = "npc_patrol_guard_ogre", 
				spawn_points = {"path_corner_patrol_2_3","path_corner_patrol_2_7","path_corner_patrol_2_31"}
			},
			{	
				unit_name = "npc_patrol_guard_beast", 
				spawn_points = {"path_corner_patrol_2_23","path_corner_patrol_2_29","path_corner_patrol_2_6"}
			},   
			{	
				unit_name = "npc_patrol_kobold", 
				spawn_points = {"path_corner_patrol_2_28","path_corner_patrol_2_35"}
			},   
        

          }


    local	cycle_guards_2 = {
			{	unit_name = "npc_patrol_guard_beast", 
				spawn_interval = 3.5,
				spawn_points = {"path_corner_cycle_2_1","path_corner_cycle_2_3","path_corner_cycle_2_5"}
			},
 
			
		}

    local patrol_guards_3 = {

			{	
				unit_name = "npc_patrol_zomb", 
				spawn_points = {"path_corner_patrol_3_4","path_corner_patrol_3_11",}
			},
 			{	
				unit_name = "npc_patrol_half_zomb_slow", 
				spawn_points = {"path_corner_patrol_3_9"}
			},
 			{	
				unit_name = "npc_patrol_big_zomb", 
				spawn_points = {"path_corner_patrol_3_8"}
			},
          }


    local	cycle_guards_3 = {
			{	unit_name = "npc_patrol_half_zomb", 
				spawn_interval = 3.0,
				spawn_points = {"path_corner_cycle_3_1"}
			},
 			{	unit_name = "npc_patrol_zomb", 
				spawn_interval = 3.0,
				spawn_points = {"path_corner_cycle_3_3"}
			},
			{	unit_name = "npc_patrol_big_zomb", 
				spawn_interval = 3.0,
				spawn_points = {"path_corner_cycle_3_5"}
			},
			
		}

    local patrol_guards_4 = {

			{	
				unit_name = "npc_patrol_pudge", 
				spawn_points = {"path_corner_patrol_4_110","path_corner_patrol_4_109",
				"path_corner_patrol_4_108","path_corner_patrol_4_107","path_corner_patrol_4_106",
				"path_corner_patrol_4_105","path_corner_patrol_4_104","path_corner_patrol_4_103",
			     "path_corner_patrol_4_102","path_corner_patrol_4_101","path_corner_patrol_4_100"}
			},

 			{	
				unit_name = "npc_patrol_zomb", 
				spawn_points = {"path_corner_patrol_4_1"}
			},
 			 	

 			{	
				unit_name = "npc_patrol_big_zomb", 
				spawn_points = {"path_corner_patrol_4_3","path_corner_patrol_4_5"}
			}, 
          }
 

    local	cycle_guards_4 = {
			{	unit_name = "npc_patrol_zomb", 
				spawn_interval = 1.75,
				spawn_points = {"path_corner_cycle_4_1","path_corner_cycle_4_3","path_corner_cycle_4_5","path_corner_cycle_4_7",
				"path_corner_cycle_4_9","path_corner_cycle_4_11"}
			},
			{	unit_name = "npc_patrol_big_zomb", 
				spawn_interval = 3.0,
				spawn_points = {"path_corner_cycle_4_13","path_corner_cycle_4_19"}
			},
			{	unit_name = "npc_patrol_zomb", 
				spawn_interval = 3.0,
				spawn_points = {"path_corner_cycle_4_17"}
			},
 			{	unit_name = "npc_patrol_half_zomb", 
				spawn_interval = 3.0,
				spawn_points = {"path_corner_cycle_4_15"}
			},   
 			{	unit_name = "npc_patrol_undying", 
				spawn_interval = 5.0,
				spawn_points = {"path_corner_cycle_4_22"}
			},   
			 
			
		}

 
	Timers:CreateTimer(0,function()

     if current_day == 1 and Penguin_save_1 == 0 and one_par_pen == 0 then 
 
     	one_par_pen = one_par_pen + 1
	     ParticleManager:SetParticleControl(ring_particle, 0, point:GetAbsOrigin()) 

          SpawnUnitsNewYear(patrol_guards_1,cycle_guards_1)

	elseif current_day == 2 and Penguin_save_2 == 0 and one_par_pen == 0 then
          if ring_particle then 
          	DeleteUnitsNewYear(patrol_guards_1,cycle_guards_1)
          	ParticleManager:DestroyParticle(ring_particle, false)
          	ring_particle = nil
          end
	     one_par_pen = one_par_pen + 1
	     ping_tweday = ping_tweday + 1
	     ParticleManager:SetParticleControl(ring_particle_2, 0, point:GetAbsOrigin()) 
          
	Timers:CreateTimer(5,function()
	     SpawnUnitsNewYear(patrol_guards_2,cycle_guards_2)
	 end)
	elseif current_day == 3 and Penguin_save_3 == 0 and one_par_pen == 0 then
          if ring_particle_2 then 
          	DeleteUnitsNewYear(patrol_guards_2,cycle_guards_2)
          	ParticleManager:DestroyParticle(ring_particle_2, false)
          	ring_particle_2 = nil
          end
	     one_par_pen = one_par_pen + 1
	     ping_thrday = ping_thrday + 1
	     ParticleManager:SetParticleControl(ring_particle_3, 0, point:GetAbsOrigin()) 
          
          Timers:CreateTimer(5,function()

	         SpawnUnitsNewYear(patrol_guards_3,cycle_guards_3)
	    end)
	elseif current_day == 4 and Penguin_save_4 == 0 and one_par_pen == 0 then
		if ring_particle_3 then 
			DeleteUnitsNewYear(patrol_guards_3,cycle_guards_3)
          	ParticleManager:DestroyParticle(ring_particle_3, false)
          	ring_particle_3 = nil
          end
	     one_par_pen = one_par_pen + 1
	     ping_chtday = ping_chtday + 1
	     ParticleManager:SetParticleControl(ring_particle_4, 0, point:GetAbsOrigin()) 
          

          Timers:CreateTimer(5,function()
	     SpawnUnitsNewYear(patrol_guards_4,cycle_guards_4)
	     end)
	elseif current_day == 5  then
		if ring_particle_4 then 
			DeleteUnitsNewYear(patrol_guards_4,cycle_guards_4)
          	ParticleManager:DestroyParticle(ring_particle_4, false)
          	ring_particle_4 = nil
          end		
	end
 
     if current_day == 2 and Penguin_save_1 == 0 and ping_tweday == 0 then 
     	one_par_pen = one_par_pen - 1
     elseif current_day == 3 and Penguin_save_2 == 0 and ping_thrday == 0 then
          print('dodo') 
     	one_par_pen = one_par_pen - 1
     elseif current_day == 4 and Penguin_save_3 == 0 and ping_chtday == 0 then           
     	one_par_pen = one_par_pen - 1
     end

 	if Penguin_save_1 == 1 and one_par_pen == 1 or Penguin_save_2 == 1 and one_par_pen == 1 or Penguin_save_3 == 1 and one_par_pen == 1 or Penguin_save_4 == 1 and one_par_pen == 1 then 
		one_par_pen = one_par_pen - 1
		
		if ring_particle then 
			DeleteUnitsNewYear(patrol_guards_1,cycle_guards_1)
		     ParticleManager:DestroyParticle(ring_particle, false)
		     ring_particle = nil
		elseif ring_particle_2 then 
			DeleteUnitsNewYear(patrol_guards_2,cycle_guards_2)
			ParticleManager:DestroyParticle(ring_particle_2, false)

			ring_particle_2 = nil
		elseif ring_particle_3 then 
			DeleteUnitsNewYear(patrol_guards_3,cycle_guards_3)
			ParticleManager:DestroyParticle(ring_particle_3, false)
			ring_particle_3 = nil
		elseif ring_particle_4 then 
			DeleteUnitsNewYear(patrol_guards_4,cycle_guards_4)
			ParticleManager:DestroyParticle(ring_particle_4, false)
			ring_particle_4 = nil
          end
          
     end
     return 1
     end)
end

function InvasionMode:InvasionGameStart()

	InvasionMode:InvasionSpawnMoobs()
 	InvasionMode:ThemeMusic()
 
	InvasionMode:NextNight()
 
      InvasionMode:ChristmasPeng()
  
   
 	--	 self:SpawnGhost("npc_classic_wave_fly_pudge",8)
 --self:SpawnZombie("npc_wave_boss_suicide",1)
 
end

function InvasionMode:UsuallyEnd()  
 -- Обычнй конец
 	Timers:CreateTimer(0,function()
	         
	    xuitat3 = RandomInt(1,3)
         
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
    --   GameRules:SetTimeOfDay(0.25)
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

 	Timers:CreateTimer(30,function()
		 EmitGlobalSound("christmas_boss_begin")
	end)

 
 	Timers:CreateTimer(40,function()
 		GameRules:SetTimeOfDay(0.8)
		 InvasionMode:spawn_christmas_boss()
	end)

 
end

 

 function InvasionMode:HalloweenEnd()  
 -- Новогодний конец
 
    local newItem = CreateItem("item_sumon_boss", nil, nil)
   newItem:SetPurchaseTime(0)
    CreateItemOnPositionForLaunch( Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin(), newItem )
   newItem:LaunchLoot(false, 150, 0.5, Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin() )
 


	Timers:CreateTimer(2, function()  
	 	    EmitGlobalSound("Rick Astley - Never Gonna Give You Up")
		    GameRules:SendCustomMessage("<font color='#58ACFA'>Rick Astley - Never Gonna Give You Up</font>", 0, 0)
      end)
	Timers:CreateTimer(5, function()  
 
		    GameRules:SendCustomMessage("<font color='#58ACFA'>Что дальше?</font>", 0, 0)
      end)
 
 
 end
  
	    local zombie_count = 0 
 

 

function InvasionMode:ZombieNight1()  
 -- 1 НОЧЬ
      local points_skelet = Entities:FindAllByName("skeleton")  
      for i=1, 3 do
		local point_skelet = points_skelet[RandomInt(1, #points_skelet)]
		local skelet = CreateUnitByName("npc_cemetery_skelet", point_skelet:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)			 
	 end
 
     self:SpawnZombie("npc_classic_wave_zombie",11)

	Timers:CreateTimer(150,function()
          self:SpawnZombie("npc_undying_1",1)
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

      local points_skelet = Entities:FindAllByName("skeleton")    
      for i=1, 3 do
		local point_skelet = points_skelet[RandomInt(1, #points_skelet)]
		local skelet = CreateUnitByName("npc_cemetery_skelet", point_skelet:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)		
		UpgradeUnitStats(skelet, 2)	
	     SetGoldUsually(skelet, 60)
          SetExpUsually(skelet, 200) 
	 end

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
--[[ 
	Timers:CreateTimer(90, function()
	     while wave_2 <  29 do 
		     self:SpawnZombie("npc_seerdying_2",1)
		 return 100
		 end
	end)	
	
 ]]

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
 
       local points_skelet = Entities:FindAllByName("skeleton")	    
      for i=1, 3 do
		local point_skelet = points_skelet[RandomInt(1, #points_skelet)]
		local skelet = CreateUnitByName("npc_cemetery_skelet", point_skelet:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)		
		UpgradeUnitStats(skelet, 4)	 
	     SetGoldUsually(skelet, 120)
          SetExpUsually(skelet, 250) 		
	 end


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
 --[[
 	Timers:CreateTimer(90, function()
	     while wave_3 <  29 do 
		     self:SpawnZombie("npc_seerdying_3",1)
		 return 90
		 end
	end)	
]]	

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

      local points_skelet = Entities:FindAllByName("skeleton")	    
      for i=1, 3 do
		local point_skelet = points_skelet[RandomInt(1, #points_skelet)]
		local skelet = CreateUnitByName("npc_cemetery_skelet", point_skelet:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)		
		UpgradeUnitStats(skelet, 8)	
	     SetGoldUsually(skelet, 180)
          SetExpUsually(skelet, 350) 			 
	 end


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
 --[[
  	Timers:CreateTimer(90, function()
	     while wave_4 <  29 do 
		     self:SpawnZombie("npc_seerdying_4",1)
		 return 90
		 end
	end)	
]]	
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
 
   	    local zombie_count_hal = 0 
        local ghost_count_hal = 0
 local zombie_count_new = 0
   local ghost_count_new = 0 
	 

function InvasionMode:ChristmasNight()  
 
    local wave_4 = 0
	
  	Timers:CreateTimer(300,function()
		 self:SpawnZombie("npc_classic_new_years",8)
		 self:SpawnGhost("npc_classic_new_years_lich",1)
	end)
 

	Timers:CreateTimer(600,function()
		GameRules:SetTimeOfDay(0.3)
	end)

	Timers:CreateTimer(602,function()
	    EmitGlobalSound("christmas_ne_Bydet")
	    InvasionMode:ChristmassEror()
	end)
 
end

function InvasionMode:ZombieNightHalloween()  
   -- Хэлуинская НОЧЬ 
  
    local wave_4 = 0

      local points_skelet = Entities:FindAllByName("skeleton")	    
      for i=1, 3 do
		local point_skelet = points_skelet[RandomInt(1, #points_skelet)]
		local skelet = CreateUnitByName("npc_cemetery_skelet", point_skelet:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)		
		UpgradeUnitStats(skelet, 12)	
	     SetGoldUsually(skelet, 350)
          SetExpUsually(skelet, 550) 			 
	 end


  	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_wave_golem",12)
		 self:SpawnGhost("npc_classic_wave_fly_pudge",6)
	end)
	
	Timers:CreateTimer(0, function()
	     while wave_4 < 30 do
			 wave_4 = wave_4 + 1
			 

 
		     return 10
		 end			 
	end)

	
 

	Timers:CreateTimer(0, function()
	    while wave_4 < 26 do 
			 self:SpawnZombie("npc_classic_wave_fire_golem",1)
		     return 35
		end
	end)



	Timers:CreateTimer(90,function()
		 self:SpawnZombie("npc_undying_clock",1)
	end)

	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_clock",1)
	end)
	
	Timers:CreateTimer(300,function()
		  InvasionMode:HalloweenEnd()
	end)
  
 
 --[[
  	Timers:CreateTimer(90, function()
	     while wave_4 <  29 do 
		     self:SpawnZombie("npc_seerdying_4",1)
		 return 90
		 end
	end)	
]]	
 
 
	
 
  
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
      local rollBase = 2.8
      local rollBase_ghost = 2.8

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

 	if killedEntity:HasModifier("modifier_survior_passive") then 
		killedEntity:SetTimeUntilRespawn( 2 )
	elseif killedEntity:GetLevel() <= 10 then 
          killedEntity:SetTimeUntilRespawn( HERO_RESPAWN_TIME_BEFORE_10 )
	else  
		killedEntity:SetTimeUntilRespawn( killedEntity:GetLevel() )		
	end
	end

	if killedEntity:GetUnitName() == "NPC_base" then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		EmitGlobalSound("Invasion.HommerWin")
	end	

	if killedEntity:GetUnitName() == "npc_skelet_boss" and killedEntity:IsReincarnating() == false then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end	
	if killedEntity:GetUnitName() == "npc_EdgardBs" then
	    for i=1,2 do
	         local unit = CreateUnitByName("npc_EdgardBs", killedEntity:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	    end 
     GameRules:SendCustomMessage("<font color='#c10020'>)))</font>", 0, 0)
	end	
 

   if Pig_bo_kill == 0 then 
	if killedEntity:GetUnitName() == "npc_boss_pig" then		 
              self:CreateDrop("item_bag_of_gold_pig", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )
              self:CreateDrop("item_big_meat", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )
 
	end	
end 
      
 

 
--*************************************** NIGHT SPAWN ***************************************

 
 
 

     if killedEntity:GetUnitName() == "npc_classic_wave_zombie" or killedEntity:GetUnitName() == "npc_suic_wave_zombie" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count = zombie_count + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(3,6)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase) then 
 		                 unit = CreateUnitByName("npc_suic_wave_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase = 1
 		             else
 		         	       unit = CreateUnitByName("npc_classic_wave_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase = rollBase + 2.8
 		             end

        	             if zombie_count < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
           	             elseif  zombie_count < 238 then 
          	                     SetGoldUsually(unit, -1)          	                  	
           	                  	 SetExpUsually(unit, -8)
            	             elseif  zombie_count > 238 then 
          	                     SetGoldUsually(unit, -2)         	                  	  
           	                  	 SetExpUsually(unit, -18)
             	        end                  

		         unit:SetInitialGoalEntity(point)
 	              end)    
        	             if zombie_count < 105 then 
             	            	 GiveGoldPlayers(5)
           	             elseif  zombie_count < 238 then 
           	                  	 GiveGoldPlayers(3)
            	             elseif  zombie_count > 238 then 
           	                  	 GiveGoldPlayers(2)
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

      if killedEntity:GetUnitName() == "npc_classic_wave_fire_golem" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
 
    
 
	         for i=1, 1 do
		         zombie_count_hal = zombie_count_hal+ 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_fire_golem", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point) 	         
       	                          
        	             if zombie_count_hal < 155 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
             	            	 GiveGoldPlayers(17)
           	             elseif  zombie_count_hal < 245 then 
          	                     SetGoldUsually(unit, -6)
           	                  	 GiveGoldPlayers(13)
           	                  	 SetExpUsually(unit, -60)
            	             elseif  zombie_count_hal > 245 then 
          	                     SetGoldUsually(unit, -10)
           	                  	 GiveGoldPlayers(9)
           	                  	 SetExpUsually(unit, -90)
             	        end
	         end    
                                  
	   	 end             
     end

      if killedEntity:GetUnitName() == "npc_classic_wave_fly_pudge" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("ghost_spawner")
 
    
 
	          for i=1, 1 do
		         ghost_count_hal = ghost_count_hal + 1
		         local point = points[RandomInt(1, #points)]
 		         local unit = CreateUnitByName("npc_classic_wave_fly_pudge", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		         unit:SetInitialGoalEntity(point)
 
        	             if ghost_count_hal < 40 then 
         	                     SetGoldUsually(unit, 0)
           	                  	 GiveGoldPlayers(17)
           	                  	 SetExpUsually(unit, 0)
           	             elseif  ghost_count_hal < 80 then 
         	                     SetGoldUsually(unit, -40)
             	            	 GiveGoldPlayers(12)
           	                  	 SetExpUsually(unit, -40)
           	             elseif  ghost_count_hal > 80 then 
         	                     SetGoldUsually(unit, -60)
             	            	 GiveGoldPlayers(7)
           	                  	 SetExpUsually(unit, -90)
             	        end
	       	            
           	end	                        
	   	 end             
     end


     if killedEntity:GetUnitName() == "npc_classic_new_years" or killedEntity:GetUnitName() == "npc_classic_new_years_ancient" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_new = zombie_count_new + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(3,6)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase) then 
 		                 unit = CreateUnitByName("npc_classic_new_years_ancient", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase = 1
 		             else
 		         	       unit = CreateUnitByName("npc_classic_new_years", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase = rollBase + 0.5
 		             end

        	             if zombie_count_new < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
           	             elseif  zombie_count_new < 238 then 
          	                     SetGoldUsually(unit, -20)          	                  	
           	                  	 SetExpUsually(unit, -90)
            	             elseif  zombie_count_new > 238 then 
          	                     SetGoldUsually(unit, -30)         	                  	  
           	                  	 SetExpUsually(unit, -130)
             	        end                  

		         unit:SetInitialGoalEntity(point)
 	              end)    
        	             if zombie_count_new < 105 then 
             	            	 GiveGoldPlayers(20)
           	             elseif  zombie_count_new < 238 then 
           	                  	 GiveGoldPlayers(15)
            	             elseif  zombie_count_new > 238 then 
           	                  	 GiveGoldPlayers(10)
             	        end
	       	           
                    
           	 end	                        
	   	 end             
     end


     if killedEntity:GetUnitName() == "npc_classic_new_years_lich" or killedEntity:GetUnitName() == "npc_classic_new_years_winterwyvern" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("ghost_spawner")
              local unit

 
	         for i=1, 1 do
		         ghost_count_new = ghost_count_new + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(15,25)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase_ghost) then 
 		                 unit = CreateUnitByName("npc_classic_new_years_winterwyvern", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase_ghost = 10
 		             else
 		         	       unit = CreateUnitByName("npc_classic_new_years_lich", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase_ghost = rollBase_ghost + 15
 		             end

        	             if ghost_count_new < 8 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
           	             elseif  ghost_count_new < 14 then 
          	                     SetGoldUsually(unit, -20)          	                  	
           	                  	 SetExpUsually(unit, -90)
            	             elseif  ghost_count_new > 14 then 
          	                     SetGoldUsually(unit, -30)         	                  	  
           	                  	 SetExpUsually(unit, -130)
             	        end                  

		         unit:SetInitialGoalEntity(point)
 	              end)    
        	             if ghost_count_new < 8 then 
             	            	 GiveGoldPlayers(60)
           	             elseif  ghost_count_new < 8 then 
           	                  	 GiveGoldPlayers(40)
            	             elseif  ghost_count_new > 14 then 
           	                  	 GiveGoldPlayers(30)
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

local tabGoldAll = {
	{units = {'npc_undying_1'}, gold = 150},
	{units = {'npc_undying_2'}, gold = 225},
	{units = {'npc_undying_3'}, gold = 300},
	{units = {'npc_undying_4'}, gold = 375},
	{units = {'npc_wave_boss_big_zombie'}, gold = 500},
	{units = {'npc_wave_boss_half_zombie'}, gold = 500},
	{units = {'npc_wave_boss_necr'}, gold = 850},
	{units = {'npc_wave_boss_suicide'}, gold = 850},
	{units = {'npc_wave_boss_meat_golem'}, gold = 850},
	{units = {'npc_wave_boss_ghost'}, gold = 1600},
	{units = {'npc_wave_boss_undying'}, gold = 1600},
	{units = {'npc_wave_boss_pudge'}, gold = 1600},

	{units = {'npc_undying_clock'}, gold = 800},
	{units = {'npc_classic_wave_fire_golem'}, gold = 650},
	{units = {'npc_classic_new_years'}, gold = 25},
	{units = {'npc_classic_new_years_ancient'}, gold = 3100},

}
for k,v in pairs(tabGoldAll) do  
	local unit = v.units
	local gold = v.gold
	local unit_name = unit[1]

	if killedEntity:GetUnitName() == unit_name and killedEntity:HasModifier("modifier_zombie_passive_fire") then 
		GiveGoldPlayers(gold/2)
	elseif killedEntity:GetUnitName() == unit_name then 
		GiveGoldPlayers(gold)
	end
 
 end
 
 
 

end
 

function InvasionMode:ThemeMusic()
	day_music =
    { 	
 	--[[  	
    	[1] = {
  		    "Akira Yamaoka – Never Forgive Me",
   		    "Ula - Cannabis",
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
  		    "a-ha - Take On Me",	
  		    "Bangers Only, fawlin, Preston Pablo, Chill Only - Circles",	
  		    "Bee Gees - Stayin' Alive",
  		    "Earth Wind And Fire - September",
              "Серега пират - Мой байк",
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
  		    "AJR - World's Smallest Violin",
  		    "Earth Wind And Fire - Let's Groove",
  		    "Redbone - Come and Get Your Love",
    	},
    		 
 
  	   	     
     	[4] = {
		"RSAC - NBA",
		"Daved Guetta - Would I Lie To You",
		 "Sia - Chandelier",
		"Does It Matter - Janieck",	
		"Grover Washington, Jr, Bill Withers - Just The Two Of Us",
		"Серега пират - Я взлетаю вверх",  			
    	},
    ]]
    	--[[ 
        	[5] = {
		"RSAC - NBA",
		"Daved Guetta - Would I Lie To You",
		 "Sia - Chandelier",
		"Does It Matter - Janieck",	  
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
   		    "Серега пират - АМ ФП", 
  		    "Life - Larson",
  		    "Musica - Fly Project",
  		    "Wake Me Up - Avicii",
  		    "Galantis - No Money",
  	        "Jackie Chan - Tiësto, Dzeko feat. Preme, Post Malone",  
  		    "Boulevard of Broken Dreams - Green Day", 
   		    "Akira Yamaoka – Never Forgive Me",
  		    "Ula - Cannabis",
  		    "Toby Fox – Once Upon a Time",  
  		    "C418 - Sweden",
  		    "Mase - Psycho",				
    	},
    	   ]]
        

 

   [1] = {
 "Merry - Christmas Jingle Bells",  
  "Jingle Вells" ,
  "Lofi Origin - Jingle Bells Lo Fi Chill",
  "Andy Williams - Winter Wonderland",
  "Bing Crosby - It's Beginning to Look a Lot Like Christmas"
  },
  
  	       
    	[2] = {
  		    "Aurélie - Jingle Bells", 
  		    "Ансамбль Детские Песни - Три белых коня",
  		    "Дискотека Авария - Новогодняя",
  		    "Brenda Lee - Rockin' Around The Christmas Tree",
  		    "Michael Buble - Holly Jolly Christmas",
    	},

     	[3] = {
  		    "Дима Билан - Новый Год с новой строчки",
  		    "ABBA - Happy New Year",
  		    "Bing Crosby, The Andrews Sisters - Santa Claus is Coming to Town",
  		    "O Liebert - Jinggle Bells",  
  		    "Andy Williams - It's the Most Wonderful Time of the Year",
    	},
    
 
     	   	     
     	[4] = {
     	"Dean Martin, Gus Levene - Let It Snow! Let It Snow! Let It Snow!",
     	"П.Чайковский - Pas de Deux",
		"Jinggle bells - Remix",
		"Wham! - Last Christmas",
 		
    	},
     
    }	 
 	night_music =
 	{
  --[[
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
  ]]
 		--[[ 
  		[5] = {
	 		"Argh Ost – Halloween",
   
 		},
 		]]
 
 
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
 
 	}
 	local last_music = nil

	Timers:CreateTimer(0,function()
	    local time = GameRules:GetDOTATime(false, false)
	    local day_time = GameRules:GetDOTATime(false, false)%600
	    current_day =  math.floor(time/600)+1
	    local music 
	    local time_until_end

	    		local kunkka = Entities:FindByName(nil, 'kunkka')  
	    		local lina = Entities:FindByName(nil, 'lina')  
	    		local meepo = Entities:FindByName(nil, 'miner')  
	    		local crystalka = Entities:FindByName(nil, 'crystalka')  
	    		local deny = Entities:FindByName(nil, 'deny')  
	    		local old_men = Entities:FindByName(nil, 'old_men')  
	    		local guard = Entities:FindByName(nil, 'guard')  
	    		local ping = Entities:FindByName(nil, 'ping')  

	    if day_time > 300 then
	    	music = night_music[current_day]
	    	time_until_end = 600 - day_time
	    	print("night time")

  	    		kunkka:AddNewModifier(kunkka, nil, "modifier_invulnerable", {}) 
  	    		lina:AddNewModifier(lina, nil, "modifier_invulnerable", {}) 
  	    		meepo:AddNewModifier(meepo, nil, "modifier_invulnerable", {}) 
  	    		crystalka:AddNewModifier(crystalka, nil, "modifier_invulnerable", {}) 
  	    		deny:AddNewModifier(deny, nil, "modifier_invulnerable", {}) 
  	          old_men:AddNewModifier(old_men, nil, "modifier_invulnerable", {}) 
  	                  if guard then 
           guard:AddNewModifier(guard, nil, "modifier_invulnerable", {}) 
              else 

             end
  	          ping:AddNewModifier(ping, nil, "modifier_invulnerable", {}) 
              
  	           
  	          
 	
      local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
     
        local building = allBuildings[i]
        building:AddNewModifier(building, nil, "modifier_invulnerable", {}) 
 
end

	    else
	    	music = day_music[current_day]
	    	time_until_end = 300 - day_time
	    	print("day time")
 
        kunkka:RemoveModifierByName('modifier_invulnerable')
        lina:RemoveModifierByName('modifier_invulnerable')        
        crystalka:RemoveModifierByName('modifier_invulnerable')
        meepo:RemoveModifierByName('modifier_invulnerable')
        deny:RemoveModifierByName('modifier_invulnerable')
        old_men:RemoveModifierByName('modifier_invulnerable')
        if guard then 
            guard:RemoveModifierByName('modifier_invulnerable')
        else 

        end
        ping:RemoveModifierByName('modifier_invulnerable')

     local allBuildings = Entities:FindAllByClassname('npc_dota_building')

    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        building:RemoveModifierByName('modifier_invulnerable')
 
end

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
	    		if music_len <= time_until_end and sound ~= last_music then
	    			table.insert(available_music, sound)
	    			print(string.format("sound name = %s",sound))
	    		end
	    	end
          
        
	    	current_music = available_music[RandomInt(1, #available_music)]
	    	 if current_music == nil then 
	    	 	return time_until_end+1
	    	 end
 
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
  	"Дима Билан - Новый Год с новой строчки",
  	"ABBA - Happy New Year",
  	"Bing Crosby, The Andrews Sisters - Santa Claus is Coming to Town",
  	"O Liebert - Jinggle Bells",  
  	"Andy Williams - It's the Most Wonderful Time of the Year",
     "Dean Martin, Gus Levene - Let It Snow! Let It Snow! Let It Snow!",
     "П.Чайковский - Pas de Deux",
	"Jinggle bells - Remix",
	"Wham! - Last Christmas",
	 "Aurélie - Jingle Bells", 
  	"Ансамбль Детские Песни - Три белых коня",
  	"Дискотека Авария - Новогодняя",
  	"Brenda Lee - Rockin' Around The Christmas Tree",
  	"Michael Buble - Holly Jolly Christmas",
  	"Merry - Christmas Jingle Bells",  
    "Jingle Вells" ,
    "Lofi Origin - Jingle Bells Lo Fi Chill",
    "Andy Williams - Winter Wonderland",
    "Bing Crosby - It's Beginning to Look a Lot Like Christmas"
    	},
    }
 
 	night_music =
 	{
 
 		[5] = {
	 		"Пётр Ильич Чайковский - Марш из балета Щелкунчик",
 
 		},

 	}
 
 
 

end

 