function Spawn( entityKeyValues )    -- вызывается когда юнит появляется
    if not IsServer() then        -- если сервер не отвечает
        return
    end
    if thisEntity == nil then    -- если данного юнита не существует
        return
    end
    
    NoTargetAbility = thisEntity:FindAbilityByName( "medusa_spirit_lance" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "lich_sinister_gaze_custom" )

    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 )    -- поведение юнита каждую секунду
end

function NecroLordThink()

    if ( not thisEntity:IsAlive() ) then        --если юнит мертв
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then    --если игра приостановлена
        return 1  
    end
	
	local hp = thisEntity:GetHealthPercent()
	
    local enemies = FindUnitsInRadius(
                        thisEntity:GetTeamNumber(),    --команда юнита
                        thisEntity:GetOrigin(),        --местоположение юнита
                        nil,    --айди юнита (необязательно)
                        1000,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_HERO,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )

				
	

	if #enemies > 0 then
        if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
				NoTargetAbilityCast()
			return 1
		end
	
	if hp < 100 then
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then    --если абилка существует и её можно использовать
            for _,unit in pairs(enemies) do
				if unit then
				NoTargetAbilityCast2(unit)
        end
		end
		end
		end
		end
	return 0.5 
end


function NoTargetAbilityCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbilityCast2(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,  
			TargetIndex = unit:entindex(),			-- тип приказа
            AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end