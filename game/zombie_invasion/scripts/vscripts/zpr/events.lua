if ZEvent == nil then
	ZEvent = class({})
end

function ZEvent:init()
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(ZEvent, 'OnStateChanged'), self)
end

function ZEvent:OnStateChanged()
	local state = GameRules:State_Get()
	
	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		ZSpawn:Cycle()
	end
end