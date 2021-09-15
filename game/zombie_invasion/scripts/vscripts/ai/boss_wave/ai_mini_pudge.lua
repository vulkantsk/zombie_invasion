function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 

 	hSpawner = Entities:FindByName( nil, "final_point" )
      local waypoint = Entities:FindByName( nil, "last_boss") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
 	if waypoint then thisEntity:SetInitialGoalEntity( waypoint ) end-- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'

    hHookAbility = thisEntity:FindAbilityByName( "pudge_meat_hook_mini" )
    hDismemberAbility = thisEntity:FindAbilityByName( "pudge_dismember_mini" )

	thisEntity:SetContextThink( "PudgeMiniThink", PudgeMiniThink, 1 )
end

 


function PudgeMiniThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	
	local npc = thisEntity
      local waypoint = Entities:FindByName( nil, "last_boss") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19 
 
 	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 15000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false )
 
 
 		local enemy = enemies[1] 

 
  		if #enemies == 0   then
 
 
 else 
 		if   hHookAbility:IsFullyCastable() then
		return  CastHook( enemies[ RandomInt( 1, #enemies ) ] )
	end
  
  	if   hDismemberAbility:IsFullyCastable() then
 
		return  CastDismember( enemy )
	end
  thisEntity:SetInitialGoalEntity( waypoint )  -- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'

	end	
	 
	return 0.5
	
end

function CastHook( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position = enemy:GetOrigin(),
		AbilityIndex = hHookAbility:entindex(),
	})

	return 1.00
end

function CastDismember( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hDismemberAbility:entindex(),
	})

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
