

local triggerActive = true

function OnStartTouch(trigger)
	local activator = trigger.activator
	local target = Entities:FindByName( nil, "techies_start_point" )

    if activator:HasModifier("modifier_survior_passive") then 
    	activator:RemoveModifierByName("modifier_survior_passive")
	    FindClearSpaceForUnit(activator, target:GetAbsOrigin(), true)
	    activator:Stop()
	    activator:EmitSound("Portal.Hero_Appear")
    end
end



