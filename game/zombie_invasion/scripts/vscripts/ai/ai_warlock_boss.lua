function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
 	hSpawner = Entities:FindByName( nil, "final_point" )
    agro = false
 
	thisEntity:SetContextThink( "WarlockThink", WarlockThink, 1 )
end

 


function WarlockThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	 
	local npc = thisEntity
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
 
    local enemy = enemies[1]

 
	if #enemies == 0 then
		MoveToTarget()
        agro = false
	else 
        if agro == false then 
        	AttackMove( npc, enemy )
        	agro = true
        end
	end	
	 
	return 1.0
end

 
function AttackMove( unit, enemy )
	if enemy == nil then
		return
	end
--	print("ATTACK MOVE")
	ExecuteOrderFromTable({
		UnitIndex = unit:entindex(),				--индекс кастера
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,	-- тип приказа атака
		Position = enemy:GetOrigin(),				-- пощиция врага
		Queue = false,
	})

	return 0.5
end

function CastROt( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hwarlock_spleshAbility:entindex(),
		Position = enemy:GetOrigin() + RandomVector(RandomInt(0,350)),
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