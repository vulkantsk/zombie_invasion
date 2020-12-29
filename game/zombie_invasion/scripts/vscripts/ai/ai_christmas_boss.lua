function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	   GameRules:SetTimeOfDay(0.75)
 

 		hBlinkAbility = thisEntity:FindAbilityByName( "phantom_assassin_phantom_strike_lua" )
		hEatAbility = thisEntity:FindAbilityByName( "doom_devour_lua" ) 		  

		hAttackAbility = thisEntity:FindAbilityByName( "doom_bringer_infernal_blade" )
 
		
 	hSpawner = Entities:FindByName( nil, "final_point" )
    local waypoint = Entities:FindByName( nil, "last_boss") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
 	if waypoint then thisEntity:SetInitialGoalEntity( waypoint ) end-- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'
	
	thisEntity:SetContextThink( "NeutralAutoCasterThink", NeutralAutoCasterThink, 1 )
end

 


function NeutralAutoCasterThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	
	local npc = thisEntity
     local timee = 0
 
	
	-- Как далеко юнит находится от своей точки спавна ?
 	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 15000000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
 
 
 		local enemy = enemies[1]	-- врагом выбирается первый близжайший
        
 
 
	 
		    if hBlinkAbility ~= nil and hBlinkAbility:IsFullyCastable() then
			    	return  CastBlink ()
		end
 
	if hEatAbility ~= nil and hEatAbility:IsFullyCastable() then
 
		return  CastEat( enemy )
	end
	if #enemies > 0 then
	if hAttackAbility ~= nil and hAttackAbility:IsFullyCastable() then
 
		return  CastAct( enemy )
	end
 end
	 
	return 0.5
	
end

 
 
function AttackMove( enemy )
	if enemy == nil then
		return
	end
--	print("ATTACK MOVE")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),				--индекс кастера
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,	-- тип приказа атака
		Position = enemy:GetOrigin(),				-- пощиция врага
		Queue = false,
	})

	return 1
end

function ItemAbilityCast( enemy )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),	--индекс кастера
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	-- тип приказа
			AbilityIndex = ItemAbility:entindex(), -- индекс способности
					TargetIndex = enemy:entindex(),
			Queue = false,
		})
	return 1.5
end

 function CastAct( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hAttackAbility:entindex(),
	})
 
	return 1.00
end

 
function CastBlink( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hBlinkAbility:entindex(),
	})
	     local waypoint = Entities:FindByName( nil, "last_boss") 
thisEntity:SetInitialGoalEntity( waypoint )

	return 1.00
end

function CastEat( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hEatAbility:entindex(),
	})

	     local waypoint = Entities:FindByName( nil, "last_boss") 
thisEntity:SetInitialGoalEntity( waypoint )
	return 1.00
end

 

 

function MoveToTarget()
	if hSpawner == nil then
		print ( "Lycan doesn't know where target is" )
		return
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetOrigin()
	})
	return 1
end
