if ZEvent == nil then
	ZEvent = class({})
end

function ZEvent:init()
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(ZEvent, 'OnStateChanged'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(ZEvent, 'OnNpcSpawned'), self)
end

function ZEvent:OnStateChanged()
	local state = GameRules:State_Get()
	
 
end

function ZEvent:OnNpcSpawned(kv)
	local npc = EntIndexToHScript(kv.entindex)
	if npc and npc:GetUnitName() == "npc_dota_courier" then
		npc:AddNewModifier(npc, nil, "modifier_invulnerable", nil)
	end
end