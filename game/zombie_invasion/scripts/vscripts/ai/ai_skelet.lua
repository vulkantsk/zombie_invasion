
function Spawn( entityKeyValues )	-- вызывается когда юнит появляется
	if not IsServer() then		-- если сервер не отвечает
		return
	end

	if thisEntity == nil then	-- если данного юнита не существует
		return
	end
 
 
	NoTargetAbility2 = thisEntity:FindAbilityByName( "clinkz_wind_walk" )
 
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
		
			
 
	
	
	
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then	--если абилка существует и её можно использовать
			if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.3 ) then 
				NoTargetAbility2Cast()
			end
		end
			
	 

 
		


	end
	
	return 0.5
	
end


 

function NoTargetAbility2Cast()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
		AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
		Queue = false,
	})
	
	return 1.5
end



 

 

 
