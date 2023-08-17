function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
    move_count = 0
    agro = false

	thisEntity:SetContextThink( "LinaThink", LinaThink, 1 )
end

function LinaThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	 
 
	local npc = thisEntity
	local enemies = {}
 
    local spawners = Entities:FindAllByName("npc_classic_lina_point")
    local point_spawner = spawners[RandomInt(1,#spawners)] 
	if npc:GetMaxHealth() == npc:GetHealth() then 
         
	else
        enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(),
        nil, 
        800, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, 
        false )

    
	end
 
     local enemy = enemies[1]

	local allies = FindUnitsInRadius(	-- ищет всех союзных братков в радиусе 
			npc:GetTeamNumber(), 
			npc:GetOrigin(), 
			nil, 
			400, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_CLOSEST, 
			false )	
 
        if agro == true then 
		for i=1,#allies do	-- заставляет братков быть агрессивными и атаковать врага
			local ally = allies[i]
           
			 	
			if ally:GetMaxHealth() == ally:GetHealth() then 
				ally:SetHealth(ally:GetMaxHealth() - 1)
				AttackMove(ally, enemy)
			end
		end	
        end
	   
	
	if #enemies == 0 then
		agro = false
		return MoveTo(point_spawner)
	else 
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
 

function MoveTo(point)
	move_count = move_count + 1
    

    
    if move_count%RandomInt(8,12) == 1 then 
	    ExecuteOrderFromTable({
		    UnitIndex = thisEntity:entindex(),
		    OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		    Position = point:GetOrigin() +RandomVector(RandomInt(75,500))
	    })
	    return 1
	end
	    return 1
     
end

 