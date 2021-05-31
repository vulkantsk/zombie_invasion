require( "ai/ai_utils" )

function Spawn( data )
	thisEntity:SetContextThink( "", function()
		if not thisEntity:IsAlive() then
			return
		end

		if GameRules:IsGamePaused() then
			return 0.1
		end

		if thisEntity:IsChanneling() then
			return 0.3
		end

		return generic_ai( thisEntity ) or 0.1
	end, 0 )
end