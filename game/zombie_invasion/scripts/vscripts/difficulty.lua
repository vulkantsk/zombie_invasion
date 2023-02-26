Difficulty = Difficulty or {
	diffs = {
		normal = 0,
		medium = 0,
		hard = 0
	},
	players = {},
	leader = "normal"
}

Difficulter = 0 

function Difficulty:Init()
	CustomGameEventManager:RegisterListener( "invasion_select_difficulty", function( _, data )
		self:Select( data )
	end )
end

function Difficulty:Select( data )
	if self.selectionEnd then
		return
	end

	if self.players[data.PlayerID] or not self.diffs[data.diff] then
		return
	end

	self.players[data.PlayerID] = true
	self.diffs[data.diff] = self.diffs[data.diff] + 1

	if self.diffs[data.diff] > self.diffs[self.leader] then
		self.leader = data.diff
	end

	CustomGameEventManager:Send_ServerToAllClients( "update_difficulty_selections", self.diffs )
end

function Difficulty:OnHeroSelectionState()
	self.selectionEnd = true

	print( "Difficulty selected - " .. self.leader  )

	if self.leader == "medium" or self.leader == "hard" then
		for _, unit in pairs( FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			Vector(),
			nil,
			-1,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_ALL,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false
		) ) do
			Difficulty:NPC( unit )
		end

 
	end
end

LinkLuaModifier( "modifier_nothing_dif", "modifiers/modifier_invasion_difficulty", LUA_MODIFIER_MOTION_NONE )

function Difficulty:NPC( npc )
	if self.leader == "normal" or npc:GetTeam() == DOTA_TEAM_GOODGUYS then
		return
	end

	local s = self.leader == "medium" and 1 or 2

	local modifier = npc:AddNewModifier( npc, nil, "modifier_invasion_difficulty", nil )
 
    local tablUnits = {
        {unit = {'npc_classic_half_zombie'}, ability = {'slow_zombie_attack'} },
        {unit = {'npc_classic_wave_ghoul'}, ability = {'ghoul_reincornation'} },
        {unit = {'npc_classic_wave_ghoul_2'}, ability = {'ghoul_reincornation'} },
    }
   
    for k,v in pairs(tablUnits) do 
    	local unit = v.unit 
    	local ability = v.ability
    	local unit_name = unit[1]
    	local ability_name = ability[1]
        
        if npc:GetUnitName() == unit_name then 
            npc:AddAbility(ability_name):SetLevel(1)
        end   
    end
 
   
	modifier:SetStackCount( s )

	Difficulter = s / 2
	local modifier_empt = npc:AddNewModifier( npc, nil, "modifier_nothing_dif", nil )
end