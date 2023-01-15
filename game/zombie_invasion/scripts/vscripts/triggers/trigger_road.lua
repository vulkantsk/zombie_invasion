function OnStartTouch(data)
	local triggerName = thisEntity:GetName()
	local ent_index = thisEntity:entindex()
	local unit = data.activator
	local unit_name = unit:GetUnitName()
	local team = unit:GetTeam()

	if team == DOTA_TEAM_NEUTRALS or unit.IsSpawnedInHammer then
		return
	end

	if unit.trigger_count == nil or unit.trigger_count < 0 then
		unit.trigger_count = 0
	end

	unit:RemoveModifierByName("modifier_sled_penguin_movement_self")
	unit:RemoveModifierByName("modifier_dry")

	unit.trigger_count = unit.trigger_count + 1
end

function OnEndTouch(data)
	local triggerName = thisEntity:GetName()
	local ent_index = thisEntity:entindex()
	local unit = data.activator
	local unit_name = unit:GetUnitName()
	local team = unit:GetTeam()

	if team == DOTA_TEAM_NEUTRALS or unit.IsSpawnedInHammer then
		return
	end	
	
	unit.trigger_count = unit.trigger_count - 1

	if unit.toss or unit.invuln or unit:HasModifier("modifier_trigger_road_ignore") then
		return
	end

	if unit.trigger_count == 0 then
		if unit:IsAlive() then
			unit:ForceKill(false)

			print('KILL')
			return
		end
	end	
end