
function Spawn( entityKeyValues )	-- вызывается когда юнит появляется
	if not IsServer() then		-- если сервер не отвечает
		return
	end

	if thisEntity == nil then	-- если данного юнита не существует
		return
	end

 
 
	ItemAbility = FindItemAbility( thisEntity, "item_satanic" )

	thisEntity:SetContextThink( "NecroLordThink1", NecroLordThink1, 1 )	-- поведение юнита каждую секунду
end

function NecroLordThink1()
	if ( not thisEntity:IsAlive() ) then		--если юнит мертв
		return -1	
	end
	
	if GameRules:IsGamePaused() == true then	--если игра приостановлена
		return 1	
	end
	local npc = thisEntity
	if not thisEntity.bInitialized then
		npc.vInitialSpawnPos = npc:GetOrigin()		-- точка спавна юнита
		npc.fMaxDist = npc:GetAcquisitionRange()	-- радиус агра 
		npc.bInitialized = true						-- флаг инициализации
		npc.agro = false							-- флаг агра
		

 
	end

	local search_radius = 1800						-- радиус поиска зависит от того, имеет ли юнит агр

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


	if #enemies > 0 	then	-- если количество найденных юнитов больше нуля
 
		if ItemAbility ~= nil and ItemAbility:IsFullyCastable()  then	--если предмет существует и её можно использовать
			if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.2 ) then 
				ItemAbilityCast()
			end
		end
 
	end
 
 

	if #enemies == 0 then	-- если найденных юнитов нету
			RetreatHome()	-- если юнит под действием агра
		return 5.0
	end

	local fDist = ( npc:GetOrigin() - npc.vInitialSpawnPos ):Length2D()
	if fDist > search_radius then
		RetreatHome()			-- если юнит слишком далеко, то идет на точку спавна
		return 3
	end
 	
	
	return 0.5
	
end


 
  

function ItemAbilityCast()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),	--индекс кастера
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
			AbilityIndex = ItemAbility:entindex(), -- индекс способности
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


function FindItemAbility( hCaster, szItemName )	--необходимая утилита , без нее не будет работать функция FindItemAbility
	for i = 0, 5 do
		local item = hCaster:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == szItemName then
				return item
			end
		end
	end
end
