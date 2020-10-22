Sounds = Sounds or {
  	playerSounds = {},
  	playersStateMusic = {},
  	SoundDuration = {

  		["Akira Yamaoka – Never Forgive Me"] = 134,
  		["Ula - Cannabis"] = 182,
  		["Toby Fox – Once Upon a Time"] = 89,  
  		["C418 - Sweden"] = 217,
  		["Mase - Psycho"] = 194,  
		
  		["Серега пират - АМ ФП"] = 128,  
  		["Life - Larson"] = 69,
  		["Musica - Fly Project"] = 46,
  		["Wake Me Up - Avicii"] = 107,
  		["Galantis - No Money"] = 75,
  		["Jackie Chan - Tiësto, Dzeko feat. Preme, Post Malone"] = 93,  
  		["Boulevard of Broken Dreams - Green Day"] = 71,
		
  		["Lana Del Rey - Summertime Sadness (smoke remix)"] = 63,
  		["I Follow Rivers - Lykke Li"] = 54,
  		["August - Intelligency"] = 91,  
  		["Shotgun - Yellow Claw feat. Rochelle"] = 72,
  		["Runaway - Parachute Youth feat. Jay Martin"] = 89,
  		["Sia - Cheap Thrills"] = 60,
  		["L Starz - My Life Be LikeGrits"] = 38,
  		["Kiesza - Hideaway"] = 92,
  		["John  Newman - Fire In Me"] = 93,
  		["iSpy - KYLE feat. Lil Yachty"] = 114,
		
		["RSAC - NBA"] = 131,
		["Daved Guetta - Would I Lie To You"] = 38,
		["Sia - Chandelier"] = 107,
		["Does It Matter - Janieck"] = 65,
		
		["C418-Key"] = 184,
		["Undertale - Respite"] = 105,
		["Argh Ost – Halloween"] = 145,
		
  	},
}

function Sounds:Activate()
	CustomGameEventManager:RegisterListener( "set_sound_state", function( _, data )
		if data.state == 1 then
			self:ComebackClientSounds( data.PlayerID )
		else
			self:RemoveClientSounds( data.PlayerID )
		end
		self.playersStateMusic[data.PlayerID] = data.state == 1
	end )

	CustomGameEventManager:RegisterListener( "looping_sound_test", function( _, data )
		Sounds:CreateLoopingSoundOnClient( data.PlayerID, "Hero_Clinkz.Pick" )
	end )
	CustomGameEventManager:RegisterListener( "looping_sound_test_end", function( _, data )
		Sounds:RemoveLoopingSoundOnClient( data.PlayerID, "Hero_Clinkz.Pick" )
	end )
  	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)
end

function Sounds:OnGameRulesStateChange()
  	local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
      	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
    end
end

function Sounds:OnThink()
	local now = GameRules:GetGameTime()
--	print("current time = "..now)

	for id, sounds in pairs( self.playerSounds ) do
		if self.playersStateMusic[id] then
			for sound, time in pairs( sounds ) do
				if now >= time then
					time = nil
					self:CreateLoopingSoundOnClient( id, sound )
				end
			end
		end
	end

	return 1
end

function Sounds:GetSoundDuration( sound )
	return GameRules:GetGameModeEntity():GetSoundDuration( sound, nil )
end

function Sounds:CreateGlobalLoopingSound( sound )
	if self.SoundDuration[sound] then
		print("sound duration = "..self.SoundDuration[sound])
	end

    for id = 0,9 do       
        Sounds:CreateLoopingSoundOnClient(id, sound)
    end
end

function Sounds:CreateGlobalSound( sound )
    for id = 0,9 do       
        Sounds:CreateSoundOnClient(id, sound)
    end
end

function Sounds:RemoveGlobalSound( sound )
    for id = 0,9 do       
        Sounds:RemoveSoundOnClient(id, sound)
    end
end

function Sounds:RemoveGlobalLoopingSound( sound )
    for id = 0,9 do       
        Sounds:RemoveSoundOnClient(id, sound)
        self.playerSounds[id][sound] = nil
    end
end

function Sounds:CreateLoopingSoundOnClient( id, sound )
	if self.playersStateMusic[id] == false then 
		print("player state - false")
		print(self.playersStateMusic[id])
		return 
	end
	self:Player( id )

	if self.playersStateMusic[id] then
		self:CreateSoundOnClient( id, sound )
	end

	if self.SoundDuration[sound] then
		self.playerSounds[id][sound] = GameRules:GetGameTime() + self.SoundDuration[sound]
	end
end

function Sounds:RemoveLoopingSoundOnClient( id, sound )
	self:Player( id )

	self:RemoveSoundOnClient( id, sound )
	self.playerSounds[id][sound] = nil
end

function Sounds:CreateSoundOnClient( id, sound )
	if self.playersStateMusic[id] == false then return end
	local player = PlayerResource:GetPlayer( id )
	if player then
		CustomGameEventManager:Send_ServerToPlayer( player, "emit_sound", { sound = sound} )
	end
end

function Sounds:RemoveSoundOnClient( id, sound )
	local player = PlayerResource:GetPlayer( id )

	if player then
		CustomGameEventManager:Send_ServerToPlayer( player, "stop_sound", { sound = sound} )
	end
end

function Sounds:ComebackClientSounds( id )
	self:Player( id )

	if not self.playersStateMusic[id] then
		self.playersStateMusic[id] = true

		for sound, time in pairs( self.playerSounds[id] ) do
			print(self.playersStateMusic[id])
			print(sound)
			self:CreateLoopingSoundOnClient( id, sound )
		end
	end
end

function Sounds:RemoveClientSounds( id )
	self:Player( id )

	if self.playersStateMusic[id] then
		self.playersStateMusic[id] = false

		for sound, _ in pairs( self.playerSounds[id] ) do
			self:RemoveSoundOnClient( id, sound )
		end
	end
end

function Sounds:Player( id )
	if not self.playerSounds[id] then
		self.playerSounds[id] = {}
		self.playersStateMusic[id] = true
	end
end
function Sounds:GetSoundDuration(sound_name)
	local sound_length = self.SoundDuration[sound_name]

	return sound_length
end

Sounds:Activate()