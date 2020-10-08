
function Spawn( entityKeyValues )	-- вызывается когда юнит появляется
	if not IsServer() then		-- если сервер не отвечает
		return
	end

	if thisEntity == nil then	-- если данного юнита не существует
		return
	end

    local waypoint = Entities:FindByName( nil, "wave_spawner_2") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
 	if waypoint then thisEntity:SetInitialGoalEntity( waypoint ) end-- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'

 

	ItemAbility = FindItemAbility( thisEntity, "item_toxic_boots" )

	thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 1 )	-- поведение юнита каждую секунду
end

function NecroLordThink()
	if ( not thisEntity:IsAlive() ) then		--если юнит мертв
		return -1	
	end
	
	if GameRules:IsGamePaused() == true then	--если игра приостановлена
		return 1	
	end


	local enemies = FindUnitsInRadius( 
						thisEntity:GetTeamNumber(),	--команда юнита
						thisEntity:GetOrigin(),		--местоположение юнита
						nil,	--айди юнита (необязательно)
						1250,	--радиус поиска
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	--поиск по флагам
						FIND_CLOSEST,	--сортировка от ближнего к дальнему или от дальнего к ближнему
						false )

	if #enemies > 0 	then	-- если количество найденных юнитов больше нуля
		
			
 
	
	
	
 
			
 

		if ItemAbility ~= nil and ItemAbility:IsFullyCastable()  then	--если предмет существует и её можно использовать
           return  ItemAbilityCast()
		end
		


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
