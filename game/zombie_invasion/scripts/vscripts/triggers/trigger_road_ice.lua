LinkLuaModifier( "modifier_sled_penguin_movement_self", "modifiers/winter/modifier_sled_penguin_movement_self", LUA_MODIFIER_MOTION_NONE )

function OnStartTouch(data)
	local triggerName = thisEntity:GetName()
	local ent_index = thisEntity:entindex()
	local unit = data.activator
	local unit_name = unit:GetUnitName()
	local team = unit:GetTeam()

	if team == DOTA_TEAM_NEUTRALS then
		return
	end
 
	
	local ability = unit:FindAbilityByName("sled_penguin_active")
	unit:AddNewModifier(unit, ability, "modifier_sled_penguin_movement_self", nil)
	
 
end


function OnEndTouch(data)
	local triggerName = thisEntity:GetName()
	local ent_index = thisEntity:entindex()
	local unit = data.activator
	local unit_name = unit:GetUnitName()
	local team = unit:GetTeam()

	if team == DOTA_TEAM_NEUTRALS then
		return
	end	
 	 
 	unit:RemoveAbility("modifier_sled_penguin_movement_self")
end