function Activate()
	thisEntity.iHeroCount = 0
	thisEntity.tUnits = {}
end

function OnStartTouch(tTrigger)
	local hUnit = tTrigger.activator
	
	if hUnit:IsRealHero() and hUnit:GetPlayerOwner() ~= nil then
		thisEntity.iHeroCount = thisEntity.iHeroCount + 1
	else
		thisEntity.tUnits[#thisEntity.tUnits+1] = hUnit
	end
	
	if thisEntity.iHeroCount == 0 then 
		ToggleAllUnits(false) 
	else
		ToggleAllUnits(true)
	end
end

function OnEndTouch(tTrigger)
	local hUnit = tTrigger.activator
	
	if hUnit:IsRealHero() and hUnit:GetPlayerOwner() ~= nil then
		thisEntity.iHeroCount = thisEntity.iHeroCount - 1
	end
	
	if thisEntity.iHeroCount == 0 then 
		ToggleAllUnits(false) 
	else
		ToggleAllUnits(true)
	end
end

function ToggleAllUnits(bToggle)
	for i = 1,#thisEntity.tUnits do
		local hUnit = thisEntity.tUnits[i]
		if thisEntity:IsTouching(hUnit) then
			if bToggle then
				hUnit:RemoveEffects(EF_NODRAW)
				hUnit:RemoveModifierByName("modifier_stunned")
			else
				hUnit:AddEffects(EF_NODRAW)
				hUnit:AddNewModifier(hUnit, nil, "modifier_stunned", {})
			end
		end
	end
end