
function Spawn( entityKeyValues )	-- вызывается когда юнит появляется
	if not IsServer() then		-- если сервер не отвечает
		return
	end

	if thisEntity == nil then	-- если данного юнита не существует
		return
	end

    local waypoint = Entities:FindByName( nil, "wave_spawner_2") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
 	if waypoint then thisEntity:SetInitialGoalEntity( waypoint ) end-- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'

 

	thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 1 )	-- поведение юнита каждую секунду
end
 


 
