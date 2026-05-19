function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
 

	thisEntity:SetContextThink( "NeutralAutoCasterThink", NeutralAutoCasterThink, 1 )

end


function NeutralAutoCasterThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		  	 	local hSpawners = Entities:FindAllByName(  "greevil_walk" )
	           local hSpawner = hSpawners[RandomInt(1, #hSpawners)]
	  	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetOrigin()
	})
 
	end
 
	return 10
	
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
