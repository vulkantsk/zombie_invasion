function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
    move_count = 0
    agro = false
    
    hChaosGolem = thisEntity:FindAbilityByName("warlock_chaos")
	thisEntity:SetContextThink( "WarlockThink", WarlockThink, 1 )
end

function WarlockThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	 
 
	local npc = thisEntity
 
 
    local spawners = Entities:FindAllByName("npc_classic_warlock_point")
    local point_spawner = spawners[RandomInt(1,#spawners)] 
 
    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(),
        nil, 
        800, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, 
        false )
 
     local enemy = enemies[1]

	if #enemies == 0 then
		agro = false
		return MoveTo(point_spawner)
	else 
		if hChaosGolem:IsFullyCastable() then 
			return CastAbility(enemy, hChaosGolem)
		end
	    if agro == false then 
            AttackMove(npc, enemy)	
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

function CastAbility( enemy, ability )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = ability:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end 

function MoveTo(point)
	move_count = move_count + 1
    

    
    if move_count%RandomInt(28,33) == 1 then 
	    ExecuteOrderFromTable({
		    UnitIndex = thisEntity:entindex(),
		    OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		    Position = point:GetOrigin() +RandomVector(RandomInt(50,600))
	    })
	    return 1
	end
	    return 1
     
end

 