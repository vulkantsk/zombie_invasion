
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
 
HERO_RESPAWN_TIME_BEFORE_10 =	 10

Witch_killed = 0
  
  
model_lookup = {}
model_lookup["npc_dota_hero_phantom_lancer"] = "models/units/sara/sara.vmdl"
model_lookup["npc_dota_hero_treant"] = "models/hero_shinobu/shinobu_01.vmdl"


function InvasionMode:InvasionMap()
     
  
	
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )

 
	GameRules:SetSameHeroSelectionEnabled(false)
 
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )	
 
 
 	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled( true )
 
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

Drow_was_picked = 0
 
 function InvasionMode:InvasionMapGameRulesStateChange(data)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		InvasionMode:InvasionGameStart()
 
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for id = 0, 24 do
			local player = PlayerResource:GetPlayer( id )

			if player and not PlayerResource:HasSelectedHero( id ) then
				player:MakeRandomHeroSelection()
			end
			--	EmitGlobalSound("amekudeku - Drow Ranger")
	
		end
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then

		Difficulty:OnHeroSelectionState()
	Timers:CreateTimer( 0.01, function()
    		for id=0, PlayerResource:GetPlayerCount() - 1 do
  
 			local hero_name   = PlayerResource:GetSelectedHeroName(id)

      		if hero_name == "npc_dota_hero_drow_ranger" then 
      			Drow_was_picked = Drow_was_picked + 1
      			EmitGlobalSound("amekudeku - Drow Ranger")
      			return nil
      		end

    		end

    		if newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
    			return nil 
    		end
   		 return 1
 	end)
 		 
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
 
function InvasionMode:Bo_plus()
      Pig_bo_kill = Pig_bo_kill + 1 
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
 
   Timers:CreateTimer( 0.05, function()
      -- Setup variables
       
      local hero = EntIndexToHScript( data.entindex )
      local model_name = ""
 
      -- Check if npc is hero
      if not hero:IsHero() then return end
 
      -- Getting model name
      if model_lookup[ hero:GetName() ] ~= nil and hero:GetModelName() ~= model_lookup[ hero:GetName() ] then
        model_name = model_lookup[ hero:GetName() ]
      else
        return nil
      end
 
      -- Check if it's correct format
      if hero:GetModelName() ~= "models/development/invisiblebox.vmdl" then return nil end
 print('lket')
      -- Never got changed before
      local toRemove = {}
      local wearable = hero:FirstMoveChild()
      while wearable ~= nil do
        if wearable:GetClassname() == "dota_item_wearable" then
          table.insert( toRemove, wearable )
        end
        wearable = wearable:NextMovePeer()
      end
 
      -- Remove wearables
      for k, v in pairs( toRemove ) do
        v:SetModel( "models/development/invisiblebox.vmdl" )
        v:RemoveSelf()
      end
 
      -- Set model
 --     hero:SetModel( model_name )
      hero:SetOriginalModel( model_name )
      hero:MoveToPosition( hero:GetAbsOrigin() )
 
      return nil
    end
  )
  
end

function InvasionMode:spawn_last_boss()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "last_boss"):GetAbsOrigin()
	unit = CreateUnitByName("npc_last_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
end

function InvasionMode:spawn_warlock_boss()
	local point = nil  -- отвечает за то, где появиться свинья
	local unit = nil  -- Кто появиться
	
 
	point = Entities:FindByName( nil, "warlock_point"):GetAbsOrigin()
	unit = CreateUnitByName("npc_warlock_boss", point, true, nil, nil, DOTA_TEAM_BADGUYS)
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
 
--
DEFAULT_DAYTIME = 300
DEFAULT_NIGHTTIME = 300 -- лучше не менять, в этом костыльном говне это значение прописано ещё раз 1000
currentNight = 0
current_day = 0

function InvasionMode:NextNight()
	local time = DEFAULT_DAYTIME --+ (math.abs(PlayerResource:GetPlayerCount() - 4) * 60)
	InvasionMode:NightTimer(time)
end
 
function InvasionMode:NightTimer(time)
	local timeLeft = time  
	local putin = Entities:FindByName(nil, 'NPC_base') 
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
				InvasionMode:ZombieNight2()  
			elseif currentNight == 3 then
				InvasionMode:ZombieNight3()  
			elseif currentNight == 4 then
				InvasionMode:ZombieNight4() 
			elseif currentNight == 5 then
				InvasionMode:ZombieNight5() 
			elseif currentNight == 6 then
				InvasionMode:ZombieNight6() 
			elseif currentNight == 7 then
				InvasionMode:ZombieNight7() 

				Timers:CreateTimer(DEFAULT_NIGHTTIME, function()
                        InvasionMode:UsuallyEnd()  
				end)

 
			end
 

			Timers:CreateTimer(DEFAULT_NIGHTTIME , function()
				if randomheroess >= 1 then 
                     	InvasionMode:RandomHeroes()  
                    end
				if oneDownHeroess >= 1 then 
                     	InvasionMode:RespawnAllHeroes() 
                    end
                     
				InvasionMode:NextNight()
				UpgradeUnitStats(putin, 1.2)
			end)
			
			return nil;
		end
          
 
 
		return 1.0
	end)
end
--

 
 
function InvasionMode:InvasionGameStart()

 
 	InvasionMode:ThemeMusic()
 
	InvasionMode:NextNight()
     
     if randomheroess >= 1 then 
     	InvasionMode:RandomHeroes()  
     end
     if oneDownHeroess >= 1 then 
     	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
     end  

 	--	 self:SpawnGhost("npc_classic_wave_fly_pudge",8)
 --self:SpawnZombie("npc_wave_boss_suicide",1)
 
end

function InvasionMode:RandomHeroes()  
 -- Обычнй конец
 	local point = Entities:FindByName( nil, "techies_start_point"):GetAbsOrigin()
 

 local heroes_name = {	"npc_dota_hero_alchemist",	
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_wisp",		
	"npc_dota_hero_bristleback"		,
	"npc_dota_hero_rubick"		,
	"npc_dota_hero_jakiro"		,
	"npc_dota_hero_medusa"	,
 	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_axe"	,
 	"npc_dota_hero_slark",
	"npc_dota_hero_clinkz",			
	"npc_dota_hero_troll_warlord",		
	"npc_dota_hero_ursa"		,	
	"npc_dota_hero_sand_king"	,
	"npc_dota_hero_skywrath_mage"	,
	"npc_dota_hero_juggernaut"	,
    "npc_dota_hero_hoodwink"	,
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_sven"		,
	"npc_dota_hero_crystal_maiden",		"npc_dota_hero_sniper"	,
	"npc_dota_hero_oracle"	,
	"npc_dota_hero_dark_seer"	,
	"npc_dota_hero_luna"	,
	"npc_dota_hero_enigma",
	"npc_dota_hero_drow_ranger",	
	"npc_dota_hero_lion",
	"npc_dota_hero_shredder",	
	"npc_dota_hero_antimage"	,
	"npc_dota_hero_terrorblade",
 	"npc_dota_hero_oracle",
"npc_dota_hero_techies", "npc_dota_hero_phantom_lancer", "npc_dota_hero_muerta", "npc_dota_hero_nevermore","npc_dota_hero_treant",
}

	local modifier_table = {"modifier_item_aghanims_shard","modifier_item_ultimate_scepter_consumed",
"modifier_item_ultimate_scepter_consumed_alchemist","modifier_item_moon_shard_consumed","modifier_alchemist_scepter_bonus_damage","modifier_tide_health","modifier_veteran_grow_water_2",
"tome_strenght_modifier",
"tome_agility_modifier",
"tome_intelect_modifier","modifier_int_buff","modifier_lion_finger_of_death_lua","modifier_item_pirog_tank","modifier_item_pirog_magic","modifier_item_pirog_dps","modifier_bone",}
 
	local heroes =  
         FindUnitsInRadius(
            DOTA_TEAM_BADGUYS, -- int, your team number
            point, -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            -1, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )

     	for _,hero in pairs( heroes ) do

 
			local playerID = hero:GetPlayerID()
			local oldHero = hero--PlayerResource:GetSelectedHeroEntity(playerID)	
			local newHeroName = heroes_name[RandomInt(1,#heroes_name)]
			local gold = oldHero:GetGold()
			local experience = oldHero:GetCurrentXP() 
 

	if playerID ~= nil and playerID ~= -1 then 
		if hero:IsAlive() then 
		     hero:ForceKill(false)
	     end
		items_table = {} 
		modif_table = {}
    		for k,v in pairs(modifier_table) do 
    			local unit = v.unit 
    			local ability = v.ability
    			local modif_name = modifier_table[k]
        
      		if oldHero:HasModifier(v) then 
           		modif_table[v] = oldHero:GetModifierStackCount(modif_name,nil)   

       		end   
    		end   
		for i = 0, 23 do 
			local item = oldHero:GetItemInSlot( i ) 
			if item ~= nil then 
				items_table[item:GetName()] = item:GetCurrentCharges() 

		 
				item:RemoveSelf() 
			end 
		end 
 

		local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
		newHero:RespawnHero(false, false) 
	 
		newHero:SetGold(gold, false)
		newHero:AddExperience(experience, 0, false, true)
		for item,stacks in pairs(items_table) do 
			print(item)
			local item = newHero:AddItemByName(item) 
			item:SetCurrentCharges(stacks)
		end 
		for modif,stacks in pairs(modif_table) do 
			local modif = newHero:AddNewModifier(newHero, nil, modif, {  }) 
			modif:SetStackCount(stacks)
		end 
	end 


     end	
 
 
end

function InvasionMode:RespawnAllHeroes()  
 -- Обычнй конец
 	local point = Entities:FindByName( nil, "techies_start_point"):GetAbsOrigin()

	local heroes =  
         FindUnitsInRadius(
            DOTA_TEAM_BADGUYS, -- int, your team number
            point, -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            -1, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )

     for _,hero in pairs( heroes ) do
         	
         	if not hero:IsAlive() then 
			hero:RespawnHero(false, false) 
		end
 
     end	
 
 
end
function InvasionMode:UsuallyEnd()  
 -- Обычнй конец

	GameRules:SendCustomMessage("#begining_1", 0, 0)


	Timers:CreateTimer(8,function()
		GameRules:SendCustomMessage("#begining_2", 0, 0)
	end)

	Timers:CreateTimer(16,function()
		GameRules:SendCustomMessage("#beginend", 0, 0)
		InvasionMode:spawn_warlock_boss()
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
 
function InvasionMode:SpawnZombie(unit_name, unit_count)
	local points = Entities:FindAllByName("zombie_spawner")

	for i=1, unit_count do
		local point = points[RandomInt(1, #points)]
		local unit = CreateUnitByName(unit_name, point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		unit:SetInitialGoalEntity(point)
	end
end
 

function InvasionMode:SpawnBoss(unit_name, unit_count)
	for i=1, unit_count do
		local point =  Entities:FindByName( nil, "boss_spawner"):GetAbsOrigin()
		local unit = CreateUnitByName(unit_name, point, true, nil, nil, DOTA_TEAM_BADGUYS)
 	unit:SetForwardVector(RandomVector(1))
	end
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

 	if oneDownHeroess >= 1 then 
 
 		local point = Entities:FindByName( nil, "techies_start_point"):GetAbsOrigin()
		killedEntity:SetRespawnsDisabled(true)
		Timers:CreateTimer(5, function()  
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
    		  local result = #heroes > 0 and '' or "true"
 
           if result ~= '' then 
           	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
           end
     end)

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

	if killedEntity:GetUnitName() == "npc_zombie_fort" then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end	

	if killedEntity:GetUnitName() == "npc_warlock_boss" then
		if Difficulter == 1 then 
			 EndGame:IsItEndGame()
			 GameRules:SendCustomMessage("<font color='#c10020'>FATAL ERROR:SYNTAX GOOD ENDING WAS NOT FOUND</font>", 0, 0)
		else
		     EndGame:GoodEnd()
 
	     end
	end	
	 

	if killedEntity:GetUnitName() == "npc_skelet_boss" and killedEntity:IsReincarnating() == false then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end	

	if killedEntity:GetUnitName() == "npc_Edgard_jitel" and killedEntity:IsReincarnating() == false then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end	

	if killedEntity:GetUnitName() == "npc_EdgardBs" then
    		 local jitels = {
    			"crystalka","deny","kunkka","old_men","miner","lina","guard","NPC_base","edgard_ed",
   		 }
 
               for i,name in ipairs(jitels) do
                   local unit = Entities:FindByName(nil,name)    
                   
                   if unit then 
                   	local unit_origin = unit:GetAbsOrigin()
                   	unit:Destroy()
                   	local unit_ed = CreateUnitByName("npc_Edgard_jitel", unit_origin, true, nil, nil, DOTA_TEAM_GOODGUYS)

                   end
               end

          GameRules:SendCustomMessage("<font color='#c10020'>.............................................................</font>", 0, 0)
	end	

	if killedEntity:GetUnitName() == "npc_boss_Gurd" then
          GameRules:SendCustomMessage("<font color='#c10020'>Пиздец, я в тильте(</font>", 0, 0)
	end

   if Pig_bo_kill == 0 then 
		if killedEntity:GetUnitName() == "npc_boss_pig" then		 
              self:CreateDrop("item_bag_of_gold_pig", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )
              self:CreateDrop("item_big_meat", killedEntity:GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )
 
		end	
	end 
      

	if killedEntity:GetUnitName() == "npc_witch_boss_1" or killedEntity:GetUnitName() == "npc_witch_boss_2" or killedEntity:GetUnitName() == "npc_witch_boss_3" then
		Witch_killed = Witch_killed + 1
          local with_mult = Witch_killed-2
		local point = Entities:FindByName(nil,"npc_witch_boss_point"):GetAbsOrigin()
          Timers:CreateTimer(RandomInt(6*60,9*60),function()	
             if Witch_killed <= 2 then 
                 local unit = CreateUnitByName("npc_witch_boss_2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
             elseif Witch_killed >= 3 then
                 local unit = CreateUnitByName("npc_witch_boss_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
                 UpgradeWitchStats(unit, with_mult * 3, with_mult * 4000, with_mult * 300 )
             end
          end)
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
 
      if killedEntity:GetUnitName() == "npc_classic_wave_big_zombie" or killedEntity:GetUnitName() == "npc_wave_zombie_toxic"  then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_2 = zombie_count_2 + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(6,15)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase_2) then 
 		                 unit = CreateUnitByName("npc_wave_zombie_toxic", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase_2 = 1.5
 		             else
                           unit = CreateUnitByName("npc_classic_wave_big_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase_2 = rollBase_2 + 1.5
 		             end
         	
        	             if zombie_count_2 < 50 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	      SetExpUsually(unit, 0)
           	             elseif  zombie_count_2 < 110 then 
          	                     SetGoldUsually(unit, -3)          	                  	
           	                  	 SetExpUsually(unit, -16)
            	             elseif  zombie_count_2 > 110 then 
          	                     SetGoldUsually(unit, -6)         	                  	  
           	                  	 SetExpUsually(unit, -32)
             	        end                  

	 
 	              end)    
        	             if zombie_count_2 < 50 then 
             	            	 GiveGoldPlayers(8)
           	             elseif  zombie_count_2 < 110 then 
           	                  	 GiveGoldPlayers(6)
            	             elseif  zombie_count_2 > 110 then 
           	                  	 GiveGoldPlayers(4)
             	        end
	       	           
                    
           	 end	                        
	   	 end             
     end

 
      if killedEntity:GetUnitName() == "npc_classic_wave_ghoul" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_3 = zombie_count_3 + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(3,8)
		         Timers:CreateTimer(time_res, function()

 
                       unit = CreateUnitByName("npc_classic_wave_ghoul", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 
         	
        	             if zombie_count_3 < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	      SetExpUsually(unit, 0)
           	             elseif  zombie_count_3 < 238 then 
          	                     SetGoldUsually(unit, -3)          	                  	
           	                  	 SetExpUsually(unit, -16)
            	             elseif  zombie_count_3 > 238 then 
          	                     SetGoldUsually(unit, -6)         	                  	  
           	                  	 SetExpUsually(unit, -32)
             	        end                  
 
 	              end)    
        	             if zombie_count_3 < 105 then 
             	            	 GiveGoldPlayers(8)
           	             elseif  zombie_count_3 < 238 then 
           	                  	 GiveGoldPlayers(6)
            	             elseif  zombie_count_3 > 238 then 
           	                  	 GiveGoldPlayers(4)
             	        end
	       	           
                    
           	 end	                        
	   	 end             
     end

 
      if killedEntity:GetUnitName() == "npc_classic_wave_ghoul_2" or killedEntity:GetUnitName() == "npc_classic_wave_ghoul_big"  then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_4 = zombie_count_4 + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(3,8)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase_4) then   
 		                 unit = CreateUnitByName("npc_classic_wave_ghoul_big", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase_4 = 1.5
 		             else
                           unit = CreateUnitByName("npc_classic_wave_ghoul_2", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase_4 = rollBase_4 + 1.5
 		             end
         	
        	             if zombie_count_4 < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	      SetExpUsually(unit, 0)
           	             elseif  zombie_count_4 < 238 then 
          	                     SetGoldUsually(unit, -4)          	                  	
           	                  	 SetExpUsually(unit, -20)
            	             elseif  zombie_count_4 > 238 then 
          	                     SetGoldUsually(unit, -7)         	                  	  
           	                  	 SetExpUsually(unit, -45)
             	        end                  

		  
 	              end)    
        	             if zombie_count_4 < 105 then 
             	            	 GiveGoldPlayers(9)
           	             elseif  zombie_count_4 < 238 then 
           	                  	 GiveGoldPlayers(7)
            	             elseif  zombie_count_4 > 238 then 
           	                  	 GiveGoldPlayers(6)
             	        end
	       	           
                    
           	 end	                        
	   	 end             
     end
 

      if killedEntity:GetUnitName() == "npc_classic_wave_pudge" or killedEntity:GetUnitName() == "npc_wave_zombie_toxic_2"  then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_5 = zombie_count_5 + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(6,15)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase_5) then 
 		                 unit = CreateUnitByName("npc_wave_zombie_toxic_2", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase_5 = 1.5
 		             else
                           unit = CreateUnitByName("npc_classic_wave_pudge", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase_5 = rollBase_5 + 1.5
 		             end
         	
        	             if zombie_count_5 < 50 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	      SetExpUsually(unit, 0)
           	             elseif  zombie_count_5 < 110 then 
          	                     SetGoldUsually(unit, -9)          	                  	
           	                  	 SetExpUsually(unit, -36)
            	             elseif  zombie_count_5 > 110 then 
          	                     SetGoldUsually(unit, -16)         	                  	  
           	                  	 SetExpUsually(unit, -70)
             	        end                  

		         
 	              end)    
        	             if zombie_count_5 < 50 then 
             	            	 GiveGoldPlayers(15)
           	             elseif  zombie_count_5 < 110 then 
           	                  	 GiveGoldPlayers(12)
            	             elseif  zombie_count_5 > 110 then 
           	                  	 GiveGoldPlayers(8)
             	        end
	       	           
                    
           	 end	                        
	   	 end             
     end
 
     if killedEntity:GetUnitName() == "npc_classic_wave_pudge_2" or killedEntity:GetUnitName() == "npc_classic_wave_pudge_mini" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_6 = zombie_count_6 + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(3,6)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase_6) then 
 		                 unit = CreateUnitByName("npc_classic_wave_pudge_mini", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase_6 = 1
 		             else
 		         	       unit = CreateUnitByName("npc_classic_wave_pudge_2", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase_6 = rollBase_6 + 2.0
 		             end

        	             if zombie_count_6 < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
           	             elseif  zombie_count_6 < 238 then 
          	                     SetGoldUsually(unit, -9)          	                  	
           	                  	 SetExpUsually(unit, -32)
            	             elseif  zombie_count_6 > 238 then 
          	                     SetGoldUsually(unit, -16)         	                  	  
           	                  	 SetExpUsually(unit, -55)
             	        end                  
 
 	              end)    
        	             if zombie_count_6 < 105 then 
             	            	 GiveGoldPlayers(12)
           	             elseif  zombie_count_6 < 238 then 
           	                  	 GiveGoldPlayers(8)
            	             elseif  zombie_count_6 > 238 then 
           	                  	 GiveGoldPlayers(6)
             	        end
	       	           
                    
           	 end	                        
	   	 end             
     end

     if killedEntity:GetUnitName() == "npc_classic_wave_greater_zombie" or killedEntity:GetUnitName() == "npc_classic_wave_reflect_zombie" then 
     	 if GameRules:IsDaytime() then
     		 return nil 
     	 else
	         local points = Entities:FindAllByName("zombie_spawner")
              local unit

 
	         for i=1, 1 do
		         zombie_count_7 = zombie_count_7 + 1
		         local point = points[RandomInt(1, #points)]
                   local time_res = RandomInt(3,6)
		         Timers:CreateTimer(time_res, function()

		             if RollPercentage(rollBase_7) then 
 		                 unit = CreateUnitByName("npc_classic_wave_reflect_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
 		                 rollBase_7 = 1
 		             else
 		         	       unit = CreateUnitByName("npc_classic_wave_greater_zombie", point:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
                           rollBase_7 = rollBase_7 + 2.0
 		             end

        	             if zombie_count_7 < 105 then 
           	                     SetGoldUsually(unit, 0)       	             	
                             	 SetExpUsually(unit, 0)
           	             elseif  zombie_count_7 < 238 then 
          	                     SetGoldUsually(unit, -12)          	                  	
           	                  	 SetExpUsually(unit, -35)
            	             elseif  zombie_count_7 > 238 then 
          	                     SetGoldUsually(unit, -24)         	                  	  
           	                  	 SetExpUsually(unit, -60)
             	        end                  
 
 	              end)    
        	             if zombie_count_7 < 105 then 
             	            	 GiveGoldPlayers(14)
           	             elseif  zombie_count_7 < 238 then 
           	                  	 GiveGoldPlayers(10)
            	             elseif  zombie_count_7 > 238 then 
           	                  	 GiveGoldPlayers(7)
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
 
 
    if pig_count == 350 then		 
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
	{units = {'npc_wave_boss_ghost'}, gold = 1400},
	{units = {'npc_wave_boss_undying'}, gold = 1400},
	{units = {'npc_wave_boss_pudge'}, gold = 1400},
	{units = {'npc_wave_boss_meat_golem_2'}, gold = 2000},
	{units = {'npc_wave_boss_suicide_2'}, gold = 2500},
	{units = {'npc_wave_boss_undying_2'}, gold = 3000},
	{units = {'npc_witch_boss_1'}, gold = 1000},
	{units = {'npc_witch_boss_2'}, gold = 1650},
	{units = {'npc_witch_boss_3'}, gold = 2500},
	{units = {'npc_boss_slark'}, gold = 1500},
	{units = {'npc_classic_Night_Stalker_boss'}, gold = 2000},
	{units = {'npc_boss_Gurd'}, gold = 500},

 
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
  		    "Summertime",
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
  	   	     
     [5] = {
		"RSAC - NBA",
  		"Galantis - No Money",
  	        "Jackie Chan - Tiësto, Dzeko feat. Preme, Post Malone",  
  		    "Boulevard of Broken Dreams - Green Day", 
  		    "a-ha - Take On Me",	
  		    "Bangers Only, fawlin, Preston Pablo, Chill Only - Circles",	
  		    "Bee Gees - Stayin' Alive",
  		    "Earth Wind And Fire - September",	
		  		    "C418 - Sweden",		
    	},

     [6] = {
  		    "Kiesza - Hideaway",
  		    "John  Newman - Fire In Me",
  		    "iSpy - KYLE feat. Lil Yachty",
  		    "AJR - World's Smallest Violin",
  		    "Earth Wind And Fire - Let's Groove",
  		    "Redbone - Come and Get Your Love",
  		    "Akira Yamaoka – Never Forgive Me",			
    	},
     [7] = {
  		    "Bee Gees - Stayin' Alive",
  		    "Earth Wind And Fire - September",
              "Серега пират - Мой байк",
		"Серега пират - Я взлетаю вверх",  	
		  		    "C418 - Sweden",	
  		    "Runaway - Parachute Youth feat. Jay Martin",
  		    "Sia - Cheap Thrills",
    	},

 	[8] = {
  		    "GigaChad Theme",

    	},
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
        

 --[[

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
        ]] 
    }	

    if Drow_was_picked == 1 then 
    		day_music = {
    			[1] = {
    				"Amekudeku - Drow Rangerr",
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
  		    "Summertime",
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
  	   	     
     [5] = {
		"RSAC - NBA",
  		"Galantis - No Money",
  	        "Jackie Chan - Tiësto, Dzeko feat. Preme, Post Malone",  
  		    "Boulevard of Broken Dreams - Green Day", 
  		    "a-ha - Take On Me",	
  		    "Bangers Only, fawlin, Preston Pablo, Chill Only - Circles",	
  		    "Bee Gees - Stayin' Alive",
  		    "Earth Wind And Fire - September",	
		  		    "C418 - Sweden",		
    	},

     [6] = {
  		    "Kiesza - Hideaway",
  		    "John  Newman - Fire In Me",
  		    "iSpy - KYLE feat. Lil Yachty",
  		    "AJR - World's Smallest Violin",
  		    "Earth Wind And Fire - Let's Groove",
  		    "Redbone - Come and Get Your Love",
  		    "Akira Yamaoka – Never Forgive Me",			
    	},
     [7] = {
  		    "Bee Gees - Stayin' Alive",
  		    "Earth Wind And Fire - September",
              "Серега пират - Мой байк",
		"Серега пират - Я взлетаю вверх",  	
		  		    "C418 - Sweden",	
  		    "Runaway - Parachute Youth feat. Jay Martin",
  		    "Sia - Cheap Thrills",
    	},

 	[8] = {
  		    "GigaChad Theme",

    	},
    		}
    	end

 	night_music =
 	{
 
 		[1] = {
			"Babymetal - Gimme Chocolate",
			"Josh A - So Tired",
		},

 		[2] = {
	 		"Unknown - mne malo malo malo tebya",
	 		"CMH Lida - STIKER",
 		},
 		[3] = {
			"plenka - No",
			"t1de sadkawaii - Regret",

 		},
 		[4] = {
	 		"evan wheel -  emptines",
	 		"slowbarry - myortvyj vnutri",

          },
 		[5] = {
	 		"benedixhion - toxin",
			"benedixhion - Go2Hell",  
          },
 		[6] = {
	 		"AZAZLO - SSC Tuatara",
			"AZAZLO - Revolver",
          },
 		[7] = {
			"Kordhell - Murder In My Mind",
			"convolk - soldier freestyle", 
          },
 		--[[ 
  		[5] = {
	 		"Argh Ost – Halloween",
   
 		},
 	 
 
 
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
	    current_day =  math.floor(time/600)+1
	    local music 
	    local time_until_end

    local jitels = {
    	"crystalka","deny","kunkka","old_men","miner","lina","guard"
    }
 
  

	    if day_time > 300 then
	    	music = night_music[current_day]
	    	time_until_end = 600 - day_time
	    	print("night time")

               for i,name in ipairs(jitels) do
                   local unit = Entities:FindByName(nil,name)    

                   if unit then 
                   	unit:AddNewModifier(unit,nil,"modifier_invulnerable", {})
                   end
               end
 
     local allBuildings = Entities:FindAllByClassname('npc_dota_building')

    for i = 1, #allBuildings, 1 do
     
        local building = allBuildings[i]
        building:AddNewModifier(building, nil, "modifier_invulnerable", {}) 
 
    end

	    else
	    	music = day_music[current_day]
	    	time_until_end = 300 - day_time
	    	print("day time")
 
               for i,name in ipairs(jitels) do
                   local unit = Entities:FindByName(nil,name)    

                   if unit then 
                       unit:RemoveModifierByName('modifier_invulnerable')
                   end
               end
 
 

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

 		[7] = {
	 		"Kordhell - Murder In My Mind",
 
 		},

 	}
 
 
 

end

 