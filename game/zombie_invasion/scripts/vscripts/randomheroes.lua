 
if Randomheroes == nil then
	Randomheroes = class({})
end

randomheroess = 0 

function Randomheroes:Init()
	print('31231')
	CustomGameEventManager:RegisterListener( "invasion_select_ran_heroes", function( _, data )
		Randomheroes:HeroesChoseRandlimn(  )
	end
	 )

end

function Randomheroes:HeroesChoseRandlimn(  )
    randomheroess = randomheroess + 1
    print(randomheroess)
    GameRules:SendCustomMessage("<font color='#ffff00'>РАНДОМ МОД ВКЛЮЧЕН!</font>", 0, 0)
	--CustomGameEventManager:Send_ServerToAllClients( "update_difficulty_selections", self.diffs )
end
 
 Randomheroes:Init()