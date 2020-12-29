
if item_bag_of_gold_mutant == nil then
	item_bag_of_gold_mutant = class({})
end

function item_bag_of_gold_mutant:OnSpellStart()
	if IsServer() then
		for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:IsValidPlayerID(playerID) then
				local hero = PlayerResource:GetSelectedHeroEntity( playerID)
				PlayerResource:ModifyGold(playerID, 4000, true, DOTA_ModifyGold_SharedGold)
				EmitSoundOnClient( "General.Coins", PlayerResource:GetPlayer(playerID))
				SendOverheadEventMessage( PlayerResource:GetPlayer(playerID), OVERHEAD_ALERT_GOLD, hero, 4000, nil )
			end
		end
		UTIL_Remove(self:GetContainer())
		UTIL_Remove(self)
	end
end

