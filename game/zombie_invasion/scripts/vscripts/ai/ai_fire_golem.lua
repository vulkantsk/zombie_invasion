function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	hFireAbility = thisEntity:FindAbilityByName( "golem_fireball" )
 
 
 	hSpawner = Entities:FindByName( nil, "final_point" )
 
	thisEntity:SetContextThink( "NeutralAutoCasterThink", NeutralAutoCasterThink, 1 )
end

function NeutralAutoCasterThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	
	local npc = thisEntity
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	local waypoint = Entities:FindByName( nil, "last_boss") 
	local enemy = enemies[1]
	
	if #enemies == 0 then
		 thisEntity:SetInitialGoalEntity( waypoint )  -- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'
	end	

 
		if hFireAbility ~= nil and hFireAbility:IsFullyCastable() then
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealthPercent() <= 100  then 
					 CastFireball(enemies[1])
	
				end		
			end
		end
	 
 
	return 0.5	
end
 
 function CastFireball( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hFireAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end
