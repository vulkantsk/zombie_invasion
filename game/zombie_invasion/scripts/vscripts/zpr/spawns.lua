if ZSpawn == nil then
	_G.ZSpawn = {}
	
	ZSpawn.spawners = {}
	
	ZSpawn.RESPAWN_DELAY = 10
	ZSpawn.SPAWNER_NAME = "zspawn_point"
	ZSpawn.UNIT_TEAM = DOTA_TEAM_BADGUYS
	ZSpawn.nowNight = true
	ZSpawn.spawnDelayMin = 2
	ZSpawn.spawnDelayMax = 3
	
	ZSpawn.units_list = {
		"npc_invasion_portal_wd",
		"npc_invasion_portal_warlock",
		"npc_invasion_portal_necr",
		"npc_invasion_portal_veno"
	}
end

local function NowTrueNight()
	return not GameRules:IsDaytime() and not GameRules:IsTemporaryNight() and not GameRules:IsNightstalkerNight()
end

function ZSpawn:InitUnit( unit )
	local time = math.ceil( GameRules:GetDOTATime( false, false ) / 60 )
	unit:SetBaseDamageMax( unit:GetBaseDamageMax() * time )
	unit:SetBaseDamageMin( unit:GetBaseDamageMin() * time )
	unit:SetBaseMaxHealth( unit:GetBaseMaxHealth() * time )
	unit:AddNewModifier( unit, nil, "modifier_portal_unit_vision", nil )
end

function ZSpawn:Init()
	local spawners = Entities:FindAllByName(self.SPAWNER_NAME)
	for _,spawner in pairs(spawners) do
		if spawner then
			self.spawners[#self.spawners+1] = spawner:GetAbsOrigin()
		end
	end
	
	print( "ZSPAWN: spawner count = " .. #self.spawners )

	if not self.timer and #self.spawners > 0 then
		self.timer = Timers:CreateTimer( 0, function()
			self:OnTimer()
			return 0
		end)
	end
end

function ZSpawn:OnTimer()
	local time = GameRules:GetGameTime()

	nowNight = NowTrueNight()

	if nowNight and not self.nowNight then
		self.nowNight = true
	elseif not nowNight and self.nowNight then
		self.nowNight = false
		self:Cycle()
	end

	if not self.nextSpawn or self.nextSpawn >= time then
		return
	end

	print( "ZSpawn spawn" )

	local ru = RandomInt( 1, #self.units_list )
	local unitName = self.units_list[ru]
	--local units = self.units_list[ru]
	
	local rs = RandomInt(1, #self.spawners)
	local spawner = self.spawners[rs]
	
	--local group = {}

	--for _, unitName in pairs( units ) do
	local unit = CreateUnitByName( unitName, spawner, true, nil, nil, self.UNIT_TEAM )
	self:InitUnit( unit )
		
	--	unit.group = group

	--	table.insert( group, unit )
	--end

	self.nextSpawn = nil
end

function ZSpawn:Cycle()
	print( "ZSpawn Cycle" )
	self.nextSpawn = GameRules:GetGameTime() + RandomInt( self.spawnDelayMin, self.spawnDelayMax )
end