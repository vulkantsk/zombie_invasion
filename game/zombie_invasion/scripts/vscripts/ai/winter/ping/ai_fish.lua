function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end
 
 
    hAbility = thisEntity:FindAbilityByName("fish_pounce")

	thisEntity:SetContextThink( "FishThink", FishThink, 1 )

end


function FishThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
 
 
    CastPounce()

	return 6
	
end

 
function CastPounce()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
	})

	return 1.00
end

 