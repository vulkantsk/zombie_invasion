Difficulty = Difficulty or {
	diffs = {
		normal = 0,
		medium = 0,
		hard = 0,
		demon = 0,
		impossible = 0,

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

	if self.leader == "normal" or self.leader == "medium" or self.leader == "hard" or self.leader == "demon" or self.leader == "impossible" then
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

 
function Difficulty:NPC( npc )
	if npc:GetTeam() == DOTA_TEAM_GOODGUYS then
		return
	end

	local s

	if self.leader == "normal" then 
		s = 1 
	elseif self.leader == "medium" then
		s = 1.25
	elseif self.leader == "hard" then
		s = 1.5 
	elseif self.leader == "demon" then
		s = 3 
	elseif self.leader == "impossible" then
		s = 6
	end		
 
	local result = (s)
 		if self.leader == "normal" or self.leader == "medium" or self.leader == "hard" then
 			npc:SetBaseMaxHealth(npc:GetMaxHealth() * result * 2)
	        npc:SetMaxHealth(npc:GetMaxHealth() * result * 2)	
	       	npc:SetHealth(npc:GetMaxHealth())
	        npc:SetBaseHealthRegen(npc:GetBaseHealthRegen() * result * 2)
	        npc:SetPhysicalArmorBaseValue(npc:GetPhysicalArmorBaseValue() + result * 5 * 2)
	        npc:SetBaseDamageMin(npc:GetBaseDamageMin() * result * 2)
	        npc:SetBaseDamageMax(npc:GetBaseDamageMax() * result * 2)
	        npc:SetDeathXP(npc:GetDeathXP() * (result * 2))
		elseif self.leader == "demon" then
	    	npc:SetBaseMaxHealth(npc:GetMaxHealth() * result)
	        npc:SetMaxHealth(npc:GetMaxHealth() * result)	
	       	npc:SetHealth(npc:GetMaxHealth())
	        npc:SetBaseHealthRegen(npc:GetBaseHealthRegen() * result)
	        npc:SetPhysicalArmorBaseValue(npc:GetPhysicalArmorBaseValue() + result * 5)
	        npc:SetBaseDamageMin(npc:GetBaseDamageMin() * result)
	        npc:SetBaseDamageMax(npc:GetBaseDamageMax() * result)
	        npc:SetDeathXP(npc:GetDeathXP() * (result))
		elseif self.leader == "impossible" then
			npc:SetBaseMaxHealth(npc:GetMaxHealth() * result )
	        npc:SetMaxHealth(npc:GetMaxHealth() * result )	
	       	npc:SetHealth(npc:GetMaxHealth())
	        npc:SetBaseHealthRegen(npc:GetBaseHealthRegen() * result )
	        npc:SetPhysicalArmorBaseValue(npc:GetPhysicalArmorBaseValue() + result * 5 )
	        npc:SetBaseDamageMin(npc:GetBaseDamageMin() * result )
	        npc:SetBaseDamageMax(npc:GetBaseDamageMax() * result)
	        npc:SetDeathXP(npc:GetDeathXP() * (result ))
		end



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
 
   
 
	_G.Difficulter = s  
	print(Difficulter)
 end