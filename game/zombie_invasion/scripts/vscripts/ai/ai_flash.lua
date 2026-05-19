function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
		hSprayAbility = thisEntity:FindAbilityByName( "alchemist_acid_spray_flash_1" )
		hSoulRipAbility = thisEntity:FindAbilityByName( "undying_soul_rip_flash_1" )   
 		hSprayAbility2 = thisEntity:FindAbilityByName( "alchemist_acid_spray_flash_2" )
		hSoulRipAbility2 = thisEntity:FindAbilityByName( "undying_soul_rip_flash_2" )  
		hTombAbility = thisEntity:FindAbilityByName( "tombestone_flash_1" )  
 		hSprayAbility3 = thisEntity:FindAbilityByName( "alchemist_acid_spray_flash_3" )
		hSoulRipAbility3 = thisEntity:FindAbilityByName( "undying_soul_rip_flash_3" )  
		hTombAbility2 = thisEntity:FindAbilityByName( "tombestone_flash_2" )  

 	hSpawner = Entities:FindByName( nil, "final_point" )
 
	thisEntity:SetContextThink( "NeutralAutoCasterThink", NeutralAutoCasterThink, 1 )
end

 


function NeutralAutoCasterThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	
	local npc = thisEntity
 
 
	
	-- Как далеко юнит находится от своей точки спавна ?
 	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
 
 
 		local enemy = enemies[1]	-- врагом выбирается первый близжайший

 
  		if #enemies == 0   then

	return MoveToTarget()
 
	end	
	 
 
 if thisEntity:GetUnitName() == "npc_flash_golem" then
	if hSprayAbility ~= nil and hSprayAbility:IsFullyCastable() then
 
		return  CastSprayLunge( enemies[ 1 ] )
	end

		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.9 ) then 		  
		 
		    if hSoulRipAbility ~= nil and hSoulRipAbility:IsFullyCastable() then
			    	return CastSoulRip()
		end
		end

end	 

 
 if thisEntity:GetUnitName() == "npc_flash_golem_2" then
	if hSprayAbility2 ~= nil and hSprayAbility2:IsFullyCastable() then
 
		return  CastSprayLunge_2( enemies[ 1 ] )
	end


		if thisEntity:GetHealth() <= ( thisEntity:GetMaxHealth() * 1.0 ) then 		  
		 
		    if hTombAbility ~= nil and hTombAbility:IsFullyCastable() then
			    	return CastTomb()
			end
		end

		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.9 ) then 		  
		 
		    if hSoulRipAbility2 ~= nil and hSoulRipAbility2:IsFullyCastable() then
			    	return CastSoulRip_2()
		end
		end

end	 

 
 if thisEntity:GetUnitName() == "npc_flash_golem_3" then
	if hSprayAbility3 ~= nil and hSprayAbility3:IsFullyCastable() then
 
		return  CastSprayLunge_3( enemies[ 1 ] )
	end


		if thisEntity:GetHealth() <= ( thisEntity:GetMaxHealth() * 1.0 ) then 		  
		 
		    if hTombAbility2 ~= nil and hTombAbility2:IsFullyCastable() then
			    	return CastTomb_2()
			end
		end

		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.9 ) then 		  
		 
		    if hSoulRipAbility3 ~= nil and hSoulRipAbility3:IsFullyCastable() then
			    	return CastSoulRip_3()
		end
		end

end	 


	return 0.5
	
end

 
 

function ItemAbilityCast( enemy )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),	--индекс кастера
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	-- тип приказа
			AbilityIndex = ItemAbility:entindex(), -- индекс способности
					TargetIndex = enemy:entindex(),
			Queue = false,
		})
	return 1.5
end

 
 
function CastSoulRip()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = hSoulRipAbility:entindex(),
	})

	return 1.00
end

function CastSprayLunge( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hSprayAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end


function CastTomb()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hTombAbility:entindex(),
	})

	return 1.00
end

function CastSprayLunge_2( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hSprayAbility2:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end

function CastSoulRip_2()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = hSoulRipAbility2:entindex(),
	})

	return 1.00
end


function CastTomb_2()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hTombAbility2:entindex(),
	})

	return 1.00
end

function CastSprayLunge_3( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hSprayAbility3:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end

function CastSoulRip_3()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = hSoulRipAbility3:entindex(),
	})

	return 1.00
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
