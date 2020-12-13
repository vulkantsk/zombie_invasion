function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	   GameRules:SetTimeOfDay(0.75)
		hClawLungeAbility = thisEntity:FindAbilityByName( "lycan_boss_claw_lunge" )
		hClawAttackAbility = thisEntity:FindAbilityByName( "lycan_boss_claw_attack" )  
		hRaptureAbility = thisEntity:FindAbilityByName( "rupture_custom" )
		
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
 
 
	
	-- Как далеко юнит находится от своей точки спавна ?
 	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 7500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
 
 
 		local enemy = enemies[1]	-- врагом выбирается первый близжайший

 
  		if #enemies == 0   then

	return MoveToTarget()
 
	end	
	 
		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.35 ) then 	
	if hRaptureAbility ~= nil and hRaptureAbility:IsFullyCastable() then
 
		return   CastRapture()
	end
end
	if hClawAttackAbility ~= nil and hClawAttackAbility:IsFullyCastable() then
 
		return  CastClawAttack( enemy )
	end

 
  
	 
 

		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.9 ) then 		  
		 
		    if hClawLungeAbility ~= nil and hClawLungeAbility:IsFullyCastable() then
			    	return  CastClawLunge( enemies[ RandomInt( 1, #enemies ) ] )
		end
		end

	 
	return 0.5
	
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

 
 
function CastClawAttack( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hClawAttackAbility:entindex(),
	})

	return 1.00
end

function CastRapture()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hRaptureAbility:entindex(),
	})

	return 1.00
end

function CastClawLunge( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hClawLungeAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
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
