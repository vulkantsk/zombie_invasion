function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

 	hSnowballAbility = thisEntity:FindAbilityByName( "yuki_snowball" )

	thisEntity:SetContextThink( "ZombieThink", ZombieThink, 1 )
end

function ZombieThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	
	local npc = thisEntity
	local friendly = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	local lowest_ally = nil 
	local lower_hp = 101
	for _, ally in pairs( friendly ) do
		if ally:GetUnitName() == thisEntity:GetUnitName()  then    else
		local healt_pct =  ( ally:GetHealth() / ally:GetMaxHealth() ) * 100

		if healt_pct < lower_hp then 
			lower_hp = healt_pct
			lowest_ally = ally
		end
	end
	end 	

	if lowest_ally then 
		if hSnowballAbility:IsFullyCastable() then 
			CastSnowballAttack( lowest_ally )
		end
	end
 	

	return 1.0	
end

 
function CastSnowballAttack( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hSnowballAbility:entindex(),
	})

	return 1.00
end
