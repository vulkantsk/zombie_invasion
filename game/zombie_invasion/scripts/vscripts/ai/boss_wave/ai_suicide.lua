function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
 

 	hSpawner = Entities:FindByName( nil, "techies_start_point" )
      
 

    hSuicideAbility = thisEntity:FindAbilityByName( "suicide_boys" )
	
	thisEntity:SetContextThink( "SuicideThink", SuicideThink, 1 )
end

 


function SuicideThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end

	
	local npc = thisEntity
 
   MoveToTarget()
 if npc:HasModifier("modifier_homer_3") then 
     return CastSuicide()
 end
	return 0.5
	
end

function CastSuicide()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hSuicideAbility:entindex(),
	})

	return 1.00
end

function MoveToTarget()
 

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetAbsOrigin()
	})
	return 1
end

 