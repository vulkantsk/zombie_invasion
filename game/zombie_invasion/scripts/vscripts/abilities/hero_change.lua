LinkLuaModifier( "modifier_change_hero", "abilities/hero_change", LUA_MODIFIER_MOTION_NONE )

function GiveNewHero(keys)
	local caster = keys.caster
	local playerID = caster:GetPlayerID()
	local oldHero = caster
	local newHeroName = keys.hero_name
	local gold = oldHero:GetGold()
	local experience = oldHero:GetCurrentXP()
	local abuzer = oldHero:HasModifier("modifier_item_midas_tress_use")
	print("gold = "..gold.." exp = "..experience)
	if not PlayerResource:IsValidPlayer(playerID) or not PlayerResource:GetPlayer(playerID) then
		return
	end

	if playerID == nil or playerID == -1 then
		return
	end

	caster:ForceKill(false)
	local items_table = {}
	for i = 0, 23 do
		local item = oldHero:GetItemInSlot(i)
		if item ~= nil then
			items_table[item:GetName()] = item:GetCurrentCharges()
			item:RemoveSelf()
		end
	end

	ReplaceHeroWithPrecache(playerID, newHeroName, function(newHero)
		if not newHero then
			return
		end
		Timers:CreateTimer(1.0, function()
			CustomGameEventManager:Send_ServerToAllClients("update_top_bar", {})
		end)
		newHero:RespawnHero(false, false)
		newHero:SetGold(gold, false)
		newHero:AddExperience(experience, 0, false, true)
		if abuzer then
			newHero:AddNewModifier(newHero, nil, "modifier_change_hero", { duration = 89 })
		end
		for itemName, stacks in pairs(items_table) do
			local newItem = newHero:AddItemByName(itemName)
			if newItem then
				newItem:SetCurrentCharges(stacks)
			end
		end
	end)
end

modifier_change_hero = {}

function modifier_change_hero:IsHidden()
	return true
end

function modifier_change_hero:RemoveOnDeath()
	return false
end
