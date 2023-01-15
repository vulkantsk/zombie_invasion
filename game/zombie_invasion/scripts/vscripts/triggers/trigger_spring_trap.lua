

local triggerActive = true

function OnStartTouch(trigger)
	local triggerName = thisEntity:GetName()
	local activator = trigger.activator
	--print("Trap Button Trigger Entered")
	local button = triggerName .. "_button"
	local model = triggerName .. "_model"
	local target = Entities:FindByName( nil, triggerName .. "_target" )
--	local fireTrap = npc:FindAbilityByName("breathe_fire")
	if not triggerActive then
		print( "Trap Skip" )
		return
	end
	triggerActive = false
	activator.toss = true
	print('Activator toss')
--	thisEntity:EmitSound( "ui.ui_player_disconnected" )
	local reset_time = 1
	Timers:CreateTimer(reset_time, function()
		triggerActive = true
	end)
	
--	npc:CastAbilityOnPosition(target:GetOrigin(), fireTrap, -1 )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", reset_time, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", reset_time + 0.25, self, self )
	
	local pos1 = activator:GetAbsOrigin() 
	local pos2 = target:GetAbsOrigin() 
	local distance = (pos1 - pos2):Length2D()
	local fw_vector = (pos1 - pos2)/distance
	local center_fw =  pos1 + fw_vector 

	local kv = {
	should_stun = 2,
	knockback_duration = 1.5,
	duration = 1.5,
	tree_destroy_radius = -1,
	knockback_distance = distance,
	knockback_height = 1200,
	center_x = center_fw.x,
	center_y = center_fw.y,
	center_z = center_fw.z
	}

	Timers:CreateTimer(0.75, function()
		activator.toss = false
	end)
	activator:AddNewModifier( activator, self, "modifier_knockback", kv )
	activator:Stop()
	activator:EmitSound("jump_up")
--	activator:EmitSound("trap_sping.jump")
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local activator = trigger.activator
	--print("Trap Button Trigger Exited")
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
end


