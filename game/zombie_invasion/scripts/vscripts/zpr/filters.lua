--init
if ZFilter == nil then
	ZFilter = class({})
end

function ZFilter:init()
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( ZFilter, "OrderFilter" ), self )
end
--

--filters
function ZFilter:OrderFilter(kv)
	local pid = kv.issuer_player_id_const
	if kv.entindex_target ~= 0 then
		local target = EntIndexToHScript(kv.entindex_target)
		if target and target ~= nil and target:IsBaseNPC() and string.match(target:GetUnitName(), "jitel") then
			local ab = target:GetAbilityByIndex(0)
			CustomGameEventManager:Send_ServerToPlayer(	PlayerResource:GetPlayer(pid), "zpr_show_quest", {
			an = ab:GetAbilityName(),
			rq = ab:GetSpecialValueFor("value_required"),
			re = ab:GetSpecialValueFor("reward_exp"),
			rg = ab:GetSpecialValueFor("reward_gold"),
			} )
			return false
		end
	end
	
	return true
end

--