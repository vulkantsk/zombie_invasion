function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
 hHookAbility = thisEntity:FindAbilityByName( "pudge_meat_hook_no" )  

	thisEntity:SetContextThink( "PudgeThink", PudgeThink, 1 )
end

 


function PudgeThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	local thinking = RandomInt(3,5)
    local random = RandomInt(1,2)
     local hSpawners = Entities:FindAllByName(  "pudge_points" )
	 local hSpawner = hSpawners[RandomInt(1, #hSpawners)]
    if random == 1 then 
	  	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetOrigin()
	    })  
    else 
    	if hHookAbility:IsFullyCastable() then
        CastHook( hSpawner )
    end
    end
	 

	return thinking
end
 
function CastHook( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hHookAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end
