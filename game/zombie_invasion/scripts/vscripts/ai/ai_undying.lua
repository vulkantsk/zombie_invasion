function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	hTomb1Ability = thisEntity:FindAbilityByName( "tombestone_und_1" )
	hTomb2Ability = thisEntity:FindAbilityByName( "tombestone_und_2" )
	hTomb3Ability = thisEntity:FindAbilityByName( "tombestone_und_3" )
	hTomb4Ability = thisEntity:FindAbilityByName( "tombestone_und_4" )

 	hSpawner = Entities:FindByName( nil, "final_point" )
 
	thisEntity:SetContextThink( "NeutralAutoCasterThink", NeutralAutoCasterThink, 1 )
end

function NeutralAutoCasterThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	
	local npc = thisEntity
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	local enemy = enemies[1]
	
	if #enemies == 0 then
		return MoveToTarget()
	end	

	if thisEntity:GetUnitName() == "npc_undying" then
		if hTomb1Ability ~= nil and hTomb1Ability:IsFullyCastable() then
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealthPercent() <= 100  then 
					 CastTomb1()
	
				end		
			end
		end
	end

	 if thisEntity:GetUnitName() == "npc_undying_2" then
		if hTomb2Ability ~= nil and hTomb2Ability:IsFullyCastable() then
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealthPercent() <= 100  then 
					 CastTomb2()
	
				end		
			end
		end
	end

	if thisEntity:GetUnitName() == "npc_undying_3" then
		if hTomb3Ability ~= nil and hTomb3Ability:IsFullyCastable() then
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealthPercent() <= 100  then 
					 CastTomb3()
	
				end		
			end
		end
	end

	 if thisEntity:GetUnitName() == "npc_undying_4" then
		if hTomb4Ability ~= nil and hTomb4Ability:IsFullyCastable() then
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealthPercent() <= 100  then 
					 CastTomb4()
	
				end		
			end
		end
	end

	return 0.5	
end

function CastTomb1()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hTomb1Ability:entindex(),
	})

	return 1.00
end

 function CastTomb2()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hTomb2Ability:entindex(),
	})

	return 1.00
end

function CastTomb3()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hTomb3Ability:entindex(),
	})

	return 1.00
end

function CastTomb4()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hTomb4Ability:entindex(),
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
