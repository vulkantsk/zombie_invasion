function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

		hVoodooAbility = thisEntity:FindAbilityByName( "pugna_life_drain_witch" )  
 

	thisEntity:SetContextThink( "GhostThink", GhostThink, 1 )
end

function GhostThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	 
	local npc = thisEntity
 
	 
 
 

	if not thisEntity.bInitialized then
		npc.vInitialSpawnPos = npc:GetOrigin()		-- точка спавна юнита
		npc.fMaxDist = npc:GetAcquisitionRange()	-- радиус агра 
		npc.bInitialized = true						-- флаг инициализации
		npc.agro = false							-- флаг агра
		

 
	end

	local search_radius = 1300						-- радиус поиска зависит от того, имеет ли юнит агр
	if npc.agro then
		search_radius = npc.fMaxDist * 3			-- расшираяется
	else
		search_radius = npc.fMaxDist				-- становится обычным
	end
	
	-- Как далеко юнит находится от своей точки спавна ?
	local fDist = ( npc:GetOrigin() - npc.vInitialSpawnPos ):Length2D()
	if fDist > search_radius then
		RetreatHome()			-- если юнит слишком далеко, то идет на точку спавна
		return 3
	end

	local enemies = FindUnitsInRadius( 
						npc:GetTeamNumber(),		--команда юнита
						npc.vInitialSpawnPos,		--местоположение юнита
						nil,	--айди юнита (необязательно)
						search_radius + 800,	--радиус поиска
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	--поиск по флагам
						FIND_CLOSEST,	--сортировка от ближнего к дальнему 
						false )

 	if   hVoodooAbility:IsFullyCastable() then
        if npc:GetHealth() < npc:GetMaxHealth() * 0.8 then 
		     return  CastVoodoo( enemies[1] )
		end
	end

 

	if #enemies == 0 then	-- если найденных юнитов нету
		if npc.agro then
			RetreatHome()	-- если юнит под действием агра
		end		
		return 0.5
	end
	

	return 1.0	
end
  
 
function CastVoodoo( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hVoodooAbility:entindex(),
	})

	return 1.00
end

function CastCursed( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hCursedAbility:entindex(),
	})

	return 1.00
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

	return 1
end

function RetreatHome()
	thisEntity.agro = false	-- снимается действие агра

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vInitialSpawnPos		
	})
end

 


 