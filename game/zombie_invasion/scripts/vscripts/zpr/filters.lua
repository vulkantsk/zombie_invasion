--init
if ZFilter == nil then
	ZFilter = class({})
end

function ZFilter:init()
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( ZFilter, "OrderFilter" ), self )
end
--

--filters
function ZFilter:OrderFilter(data)
	local type = data.order_type
	local unit 
	local pid = data.issuer_player_id_const
	if data.entindex_target ~= 0 then
		local target = EntIndexToHScript(data.entindex_target)
		if target and target ~= nil and target:IsBaseNPC() and string.match(target:GetUnitName(), "jitel")  then
			local ab = target:GetAbilityByIndex(0) or nil

    		if ab then 
			CustomGameEventManager:Send_ServerToPlayer(	PlayerResource:GetPlayer(pid), "zpr_show_quest", {
			an = ab:GetAbilityName(),
			value = ab:GetSpecialValueFor("value_required"),
			re = ab:GetSpecialValueFor("reward_exp"),
			rg = ab:GetSpecialValueFor("reward_gold"),
			quest_item = ab.quest_item,
			reward_item = ab.reward_item,
			} )
			return false
            end
		end
		if target and target ~= nil and target:IsBaseNPC() and target:GetUnitName() == "npc_market_blackshop" then
			CustomGameEventManager:Send_ServerToPlayer(	PlayerResource:GetPlayer(pid), "show_blackshop_tooltip", {
 
				} )
			return false		
		end
	end
 

	if data.units and data.units["0"] then 
		unit = EntIndexToHScript(data.units["0"])
	end

	if type == DOTA_UNIT_ORDER_PICKUP_ITEM and data.entindex_target ~= 0 and unit and not unit:IsNull() then
		local item = EntIndexToHScript(data.entindex_target)
		if item ~= nil and not item:IsNull() and item.price then
			local player = PlayerResource:GetPlayer(unit:GetPlayerOwnerID())
			if not player then
				return true
			end
			local hero = player:GetAssignedHero()
			if not hero or hero:IsNull() then
				return true
			end
			local currentGold = hero:GetGold()
			local needGold = tostring(item.price - currentGold)

			if item.price > currentGold then
				CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {
					gold = item.price - currentGold,
					message = "Ты бы ещё без денег в мега-маркет сходил, чудила" .. " тебе не хватает" .. " " .. needGold .. " голды ",
				})
				return false
			end
		end
	end

	return true
end

-- 