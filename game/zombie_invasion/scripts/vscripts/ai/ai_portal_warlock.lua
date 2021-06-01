require( "ai/ai_utils" )

function Spawn( data )
	Timers:CreateTimer( 0.1, function()
		if not thisEntity or thisEntity:IsNull() or not thisEntity:IsAlive() then
			return
		end

		local golem = thisEntity:FindAbilityByName( "invasion_portal_warlock_portal" )

		print( "golem", golem )

		if golem then
			thisEntity:CastAbilityOnPosition(
				thisEntity:GetAbsOrigin() + thisEntity:GetForwardVector() * 400,
				golem,
				-1
			)
		end

		thisEntity:SetContextThink( "", function()
			return generic_ai( thisEntity ) or 0.1
		end, 1.5 )
	end )
end