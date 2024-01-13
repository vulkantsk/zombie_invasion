if EndGame == nil then
	EndGame = class({})
end

function EndGame:IsItEndGame()
    local point = Entities:FindByName( nil, "last_boss"):GetAbsOrigin()

     EmitGlobalSound("dead")
        for index=0 ,HeroList:GetHeroCount() do  
		  		if HeroList:GetHero(index)    then   
			        local hero = HeroList:GetHero(index)   
 			   			 
                    if not hero:IsAlive() then 
                        hero:RespawnHero(false, false) 
                    end 
                end
        end	

	local heroes =  
         FindUnitsInRadius(
            DOTA_TEAM_BADGUYS, -- int, your team number
            point, -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            -1, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
	Timers:CreateTimer(1,function()    
    for _,her in pairs(heroes) do 
    	local point = her
    	EndGame:SpawnEdgard(1,her)
    end
    return 5
    end)

	Timers:CreateTimer(2,function()    
		for _, unit in pairs( FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			Vector(),
			nil,
			-1,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false
		) ) do
              
             if unit:GetUnitName() ~= "npc_Edgard" then 
             	 self:SpawnEdgard(1,unit)
		         UTIL_Remove( unit )
		    end
            
		end
		return 1
    end)  
	Timers:CreateTimer(1,function()    
		for _, unit in pairs( FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			Vector(),
			nil,
			-1,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false
		) ) do
              
             if unit:GetUnitName() ~= "npc_Edgard" then 
             	 self:SpawnEdgard(1,unit)
		         UTIL_Remove( unit )
		    end
            
		end
		return 1
    end)  
 

end

LinkLuaModifier("modifier_wake_up", "modifiers/modifier_wake_up", 0)
LinkLuaModifier("modifier_sleep", "modifiers/modifier_sleep", 0)


function EndGame:DemonEnd()
    local point = Entities:FindByName( nil, "techies_start_point"):GetAbsOrigin()
 
 	for index=0 ,HeroList:GetHeroCount() do  
 		if HeroList:GetHero(index)    then   

 		local hero = HeroList:GetHero(index)   

 		local playerID = hero:GetPlayerID()

 		if playerID ~= nil and playerID ~= -1 then 
   
      			 
            if not hero:IsAlive() then 
                hero:RespawnHero(false, false) 
            end   
                  	
            hero:AddNewModifier(hero, nil, "modifier_wake_up", {})
            hero:SetBuyBackDisabledByReapersScythe(true)
 
         end
 		end
    end	


	Timers:CreateTimer(7,function()
		GameRules:SetTimeOfDay(0.8)
		EmitGlobalSound("after_sleep")

 		for index=0 ,HeroList:GetHeroCount() do  
 		if HeroList:GetHero(index)    then   

 		local hero = HeroList:GetHero(index)   

 		local playerID = hero:GetPlayerID()

 		if playerID ~= nil and playerID ~= -1 then 
   
      			 
            if not hero:IsAlive() then 
                hero:RespawnHero(false, false) 
            end   
 			hero:AddNewModifier(hero, nil, "modifier_sleep", {duration = 20})
            for i = 0, 23 do 
				local item = hero:GetItemInSlot( i ) 
				if item ~= nil then 
					item:RemoveSelf() 
				end 
			end 
			hero:SetGold(0,false)
         end
 		end
    	end	 
    	for _, unit in pairs( FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			Vector(),
			nil,
			-1,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false
		) ) do
              
             if unit:GetUnitName() == "npc_classic_pig" or unit:GetUnitName() == "npc_classic_sheep" then 
				unit:SetTeam(DOTA_TEAM_GOODGUYS)
		    end
            
		end 

    local jitels = {
    	"crystalka","deny","kunkka","old_men","lina", "NPC_base"
    }
 
  for i,name in ipairs(jitels) do 
 
    local unit = Entities:FindByName(nil, name)
	local point = Entities:FindByName(nil, "jitel_" ..name):GetAbsOrigin()

    if unit then 
         unit:SetAbsOrigin(point)
         FindClearSpaceForUnit(unit, point, false)
 
    else
          
    end
 end     

	end)
 
	Timers:CreateTimer(60,function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
  	
end


function EndGame:ImpossibleEnd()

  
 	for index=0 ,HeroList:GetHeroCount() do  
 		if HeroList:GetHero(index)    then   

 		local hero = HeroList:GetHero(index)   

 		local playerID = hero:GetPlayerID()

 		if playerID ~= nil and playerID ~= -1 then 
   
      			 
            if not hero:IsAlive() then 
                hero:RespawnHero(false, false) 
            end   
                  	
            hero:AddNewModifier(hero, nil, "modifier_wake_up", {})
            hero:SetBuyBackDisabledByReapersScythe(true)
 
         end
 		end
    end	


	Timers:CreateTimer(7,function()
 		for index=0 ,HeroList:GetHeroCount() do  
 		if HeroList:GetHero(index)    then   

 		local hero = HeroList:GetHero(index)   

 		local playerID = hero:GetPlayerID()

 		if playerID ~= nil and playerID ~= -1 then 
   
      			 
            if not hero:IsAlive() then 
                hero:RespawnHero(false, false) 
            end   
 			hero:AddNewModifier(hero, nil, "modifier_sleep", {})


         end
 		end
    	end	 
    	for _, unit in pairs( FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			Vector(),
			nil,
			-1,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false
		) ) do
              
            if unit:GetUnitName() == "npc_classic_pig" or unit:GetUnitName() == "npc_classic_sheep" then 
				unit:SetTeam(DOTA_TEAM_GOODGUYS)
		    end
            
		end 	      
	end)
 	
 

 	Timers:CreateTimer(12, function()  
 
 	InvasionMode:ZombieNightUnreal()  	 
 
 	   	GameRules:SetTimeOfDay(0.8)
 	   	 
	end)

 
 	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("#imp1",0,0) end)

 	Timers:CreateTimer(12, function() GameRules:SendCustomMessage("#imp2",0,0) end)
 
 
  	
end

LinkLuaModifier("modifier_powelvolya", "modifiers/modifier_powelvolya", 0)


function EndGame:ImposHomer()
 
 	for index=0 ,HeroList:GetHeroCount() do  
 		if HeroList:GetHero(index)    then   

 		local hero = HeroList:GetHero(index)   

 		local playerID = hero:GetPlayerID()

 		if playerID ~= nil and playerID ~= -1 then 
   			 hero:Kill(self,hero)
             hero:SetBuyBackDisabledByReapersScythe(true)
 
         end
 		end
    end	
 
Timers:CreateTimer(2, function()
for index=0 ,HeroList:GetHeroCount() do  
 		if HeroList:GetHero(index)    then   

 		local hero = HeroList:GetHero(index)   

 		local playerID = hero:GetPlayerID()

 		if playerID ~= nil and playerID ~= -1 then 
   
      			 
            if hero:IsAlive() then 
            	hero:Kill(self,hero)
			end
                hero:RespawnHero(false, false) 
                hero:AddNewModifier(hero, nil, "modifier_powelvolya", {})
 
         end
 		end
    	end
 end)

 	Timers:CreateTimer(20, function() GameRules:SendCustomMessage("#imp3",0,0) end)
 	
 	Timers:CreateTimer(30, function() GameRules:SendCustomMessage("#imp4",0,0) end)

			Timers:CreateTimer(32, function() GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) end)
		

end
function EndGame:SpawnEdgard(unit_count,point)
 

	for i=1, unit_count do
		local unit = CreateUnitByName("npc_Edgard", point:GetAbsOrigin() +RandomVector(RandomInt(0,250)), true, nil, nil, DOTA_TEAM_BADGUYS)
		local random = RandomFloat(0.1,5)
		unit:SetModelScale(random)
	end
end

function EndGame:GoodEnd()
	EndGame:GoodEndMessages()

	local techies_start_point = Entities:FindByName(nil, "techies_start_point"):GetAbsOrigin()
	local pudge_start_point = Entities:FindByName(nil, "pudge_start_point"):GetAbsOrigin()
	local pudge_end_point = Entities:FindByName(nil, "pudge_end_point"):GetAbsOrigin()
	local techies_end_point = Entities:FindByName(nil, "techies_end_point"):GetAbsOrigin()
	local antimage_start_point = Entities:FindByName(nil, "antimage_start_point"):GetAbsOrigin()
	local antimage_end_point = Entities:FindByName(nil, "antimage_end_point"):GetAbsOrigin()

	local techies = CreateUnitByName("npc_end_techies", techies_start_point, false, nil, nil, DOTA_TEAM_GOODGUYS)
	
	local pudge = CreateUnitByName("npc_end_pudge", pudge_start_point, false, nil, nil, DOTA_TEAM_BADGUYS)
	local pudge_bear = nil

	local antimage1 = CreateUnitByName("npc_end_antimage", antimage_start_point, false, nil, nil, DOTA_TEAM_BADGUYS)
	local antimage2 = nil
	local antimage3 = nil

	local timer = 0
	Timers:CreateTimer(0,function()
		if timer == 1 then
			--направить текиса в точку
			MoveToPoint(techies, techies_end_point)
			--направить пуджа на точку
			MoveToPoint(pudge, pudge_end_point)
			--направить ама на точку
			MoveToPoint(antimage1, antimage_end_point)
		end
		
		if timer == 9 then
			--направить лицо ама на текиса 
			antimage1:CastPointSkill("intro_rotate",techies:GetAbsOrigin())
			--напривить лицо пуджа на текиса + анимация
			pudge:CastPointSkill("intro_rotate",techies:GetAbsOrigin())
		end
		
		if timer == 10 then
			--текис поворачивает голову в сторону ама
			techies:CastPointSkill("intro_rotate",antimage1:GetAbsOrigin())
		end
		
		if timer == 11 then
			--текис поворачивает голову в сторону пуджа
			techies:CastPointSkill("intro_rotate",pudge:GetAbsOrigin())
		end
		
		if timer == 12 then
			--текис начинает веселиться
			techies:AddNewModifier(techies, nil, "modifier_victory_animation", nil)
			--пудж начинает веселиться
			pudge:AddNewModifier(pudge, nil, "modifier_victory_animation", nil)
			--ам создаёт иллюзию
			local point = antimage1:GetAbsOrigin()
			local fw = antimage1:GetForwardVector()

			antimage1:EmitSound("DOTA_Item.Manta.Activate")
	--		local effect = "particles/items2_fx/manta_phase.vpcf"
	--		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, antimage1)
	--		ParticleManager:ReleaseParticleIndex(pfx)
			antimage1:SetAbsOrigin(point + RandomVector(50))
		 
			antimage2 = CreateUnitByName("npc_end_antimage", point + RandomVector(50), false, nil, nil, DOTA_TEAM_BADGUYS)
			antimage2:SetForwardVector(fw)
	 
			antimage3 = CreateUnitByName("npc_end_antimage", point + RandomVector(50), false, nil, nil, DOTA_TEAM_BADGUYS)
			antimage3:SetForwardVector(fw)
			
			Timers:CreateTimer(1,function()
				AntimageThink(antimage1)
			end)		
			Timers:CreateTimer(2,function()
				AntimageThink(antimage2)
			end)	
			Timers:CreateTimer(3,function()
				AntimageThink(antimage3)	 
			end)		
		end

		if timer == 19 then
			--пудж издаёт звук
			pudge:EmitSound("pudge_pud_anger_0"..RandomInt(1, 5))
		end
		
		if timer == 19 then
			--пудж издаёт звук
			pudge:EmitSound("pudge_pud_anger_0"..RandomInt(1, 5))
		end
		
		if timer == 25 then
			--насмешка текиса
			techies:CastSkill("techies_taunt")
		end
		
		if timer == 29 then
			--ам ульта
			antimage1.stop = true
			antimage1:CastSkill("antimage_ult", techies)
		end
		
		if timer == 31 then
			--санстрайк мимо
			antimage1.stop = false
			
			techies:EmitSound("Hero_Invoker.SunStrike.Ignite")


			local point = techies_end_point+RandomVector(300)
			local effect = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, point)

			ParticleManager:ReleaseParticleIndex(pfx)

		end
		
		if timer == 39 then
			--появляется мишка + идёт на текиса
			local fw = pudge:GetForwardVector()
			local point = pudge:GetAbsOrigin()+fw*100

			pudge_bear = CreateUnitByName("npc_end_bear", point, false, nil, nil, DOTA_TEAM_BADGUYS)
			pudge_bear:SetForwardVector(fw)
			MoveToPoint(pudge_bear, techies_end_point)
		end
		
		if timer == 41 then
			--текис стреляет в медведя
			techies:CastSkill("techies_attack", pudge_bear)
		end
		
		if timer == 51 then
			--пудж падает
			pudge:CastSkill("pudge_death")
		end
		
		if timer == 60 then
			--пудж издаёт звук
			pudge:EmitSound("pudge_pud_anger_0"..RandomInt(1, 5))
		end
		
		if timer == 65 then
			--текис насмешка
			techies:CastSkill("techies_taunt")
		end
		
		if timer == 72 then
			--текис насмешка
			techies:CastSkill("techies_taunt")
		end
		
		if timer == 77 then
			--текис ставит мину
			techies:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
			techies:EmitSound("Hero_Techies.LandMine.Plant")
			local point = techies:GetAbsOrigin()+techies:GetForwardVector()*100

			techies_mine = CreateUnitByName("npc_dota_techies_land_mine", point, false, nil, nil, DOTA_TEAM_GOODGUYS)
			--ам с колнами бегут на текиса
			antimage1.stop = true
			antimage1:CastSkill("antimage_attack", techies)

			antimage2.stop = true
			antimage2:CastSkill("antimage_attack", techies)

			antimage3.stop = true
			antimage3:CastSkill("antimage_attack", techies)
		end
		
		if timer == 78 then
			--мина пищит
			techies:EmitSound("Hero_Techies.LandMine.Priming")
		end
		
		if timer == 79 then
			antimage1:CastSkill("antimage_attack", techies)
			antimage2:CastSkill("antimage_attack", techies)
			antimage3:CastSkill("antimage_attack", techies)
		end
		
		if timer == 80 then
			--мина взрывается
			techies_mine:ForceKill(false)

			techies:EmitSound("Hero_Techies.LandMine.Detonate")
			local effect = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, techies_mine:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(300, 1, 1))
			ParticleManager:ReleaseParticleIndex(pfx)
			--ам с клонами умирают
			antimage1:ForceKill(false)
			antimage2:ForceKill(false)
			antimage3:ForceKill(false)

			techies:EmitSound("antimage_anti_death_0"..RandomInt(1, 9))
		end
		
		if timer == 83 then 
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			return -1 
		end
		
		timer = timer + 1
		return 1
	end)

end

function EndGame:GoodEndMessages()
	local sound_duration = 82

	Timers:CreateTimer(1, function() GameRules:SendCustomMessage("#ending_1",0,0) end)
	
	Timers:CreateTimer(3, function() GameRules:SendCustomMessage("#ending_2",0,0) end)
 
	Timers:CreateTimer(7, function() GameRules:SendCustomMessage("#ending_3",0,0) end)
 
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("#Game_notification_win",0,0) end)
	
	Timers:CreateTimer(sound_duration-40, function() GameRules:SendCustomMessage("#ending_4",0,0) end)
	
	Timers:CreateTimer(sound_duration-35, function() GameRules:SendCustomMessage("#ending_5",0,0) end)
	
	Timers:CreateTimer(sound_duration-30, function() GameRules:SendCustomMessage("#ending_6",0,0) end)
	
	Timers:CreateTimer(sound_duration-25, function() GameRules:SendCustomMessage("#ending_7",0,0) end)
	
	Timers:CreateTimer(sound_duration-10, function() GameRules:SendCustomMessage("#ending_8",0,0) end)
	
	Timers:CreateTimer(sound_duration-3, function() GameRules:SendCustomMessage("#ending_9",0,0) end)
	
	
	EmitGlobalSound("Серега пират - гимн Дахака")
 	GameRules:SendCustomMessage("<font color='#58ACFA'>Серега пират - гимн Дахака</font>",0,0)
end

function EndGame:ChristmasEnd()

 InvasionMode:CristmasPlus()	
	 Timers:CreateTimer(0,function()
  	     GameRules:SendCustomMessage("#christmas_1",0,0)  
	 end)

     Timers:CreateTimer(0.1,function()
         EmitGlobalSound("christmas_Bydet")
         GameRules:SendCustomMessage("<font color='#58ACFA'>Стекловата - Новый год</font>",0,0)  
     end)
 
 

  LinkLuaModifier("modifier_intro_rotate_christmas_passive", "abilities/endgame/intro_rotate_christmas", 0)
 
    local jitels = {
    	"crystalka","deny","kunkka","old_men","miner","lina"
    }

local point_for_lina = Entities:FindByName(nil, "point_for_lina"):GetAbsOrigin()
local point_for_old_men = Entities:FindByName(nil, "point_for_old_men"):GetAbsOrigin()
local point_for_kunkka = Entities:FindByName(nil, "point_for_kunkka"):GetAbsOrigin()
local point_for_crystalka = Entities:FindByName(nil, "point_for_crystalka"):GetAbsOrigin()
local point_for_deny = Entities:FindByName(nil, "point_for_deny"):GetAbsOrigin()
local point_for_miner = Entities:FindByName(nil, "point_for_miner"):GetAbsOrigin()
--local point_for_brodyagi = Entities:FindByName(nil, "for_brodyagi"):GetAbsOrigin()
--local point_for_penguins_1 = Entities:FindByName(nil, "for_penguins_1"):GetAbsOrigin()
--local point_for_penguins_2 = Entities:FindByName(nil, "for_penguins_2"):GetAbsOrigin()
--local point_for_putin = Entities:FindByName(nil, "putin"):GetAbsOrigin() 


 	--local point_for_rotate = Entities:FindByName(nil, "pudge_end_point")
 

--local for_penguins_11 = Entities:FindByName(nil, "for_penguins_11"):GetAbsOrigin()
--local for_penguins_22 = Entities:FindByName(nil, "for_penguins_22"):GetAbsOrigin()
--local for_penguins_33 = Entities:FindByName(nil, "for_penguins_33"):GetAbsOrigin()
--local for_penguins_44 = Entities:FindByName(nil, "for_penguins_44"):GetAbsOrigin()
--local for_penguins_55 = Entities:FindByName(nil, "for_penguins_55"):GetAbsOrigin()

--local penguin_1 = Entities:FindByName(nil, 'penguin_1')   
--local penguin_2 = Entities:FindByName(nil, 'penguin_2')    
--local penguin_3 = Entities:FindByName(nil, 'penguin_3')  
--local penguin_4 = Entities:FindByName(nil, 'penguin_4')   
--local ping = Entities:FindByName(nil, 'ping')

 	Timers:CreateTimer(0, function()  
 GameRules:SetTimeOfDay(0.3)
 --MoveToPoint(penguin_1, for_penguins_11) 
 --MoveToPoint(penguin_2, for_penguins_22) 
 --MoveToPoint(penguin_3, for_penguins_33) 
 --MoveToPoint(penguin_4, for_penguins_44) 
 --MoveToPoint(ping, for_penguins_55) 

   for i,name in ipairs(jitels) do  
    local unit = Entities:FindByName(nil, name)
    local point = Entities:FindByName(nil, "point_for_"..name):GetAbsOrigin() 
    if unit then 
         unit:StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.0)
         MoveToPoint(unit, point) 
    else
          
    end
 end      
    end)
 
 
 

 

	Timers:CreateTimer(88, function()  
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)  	
  end)
       

 
 
 		 

end

--function PuitnThink(npc)
--	Timers:CreateTimer(0, function()
--		if ( not npc:IsAlive() ) then		--если юнит мертв
--			return -1	
--		end
--		
--		if npc.stop then	--если игра приостановлена
--			return 1	
--		end
--
--		local point = Entities:FindByName(nil, "putin"):GetAbsOrigin()
--		local blink_point = point  
--
--		local effect = "models/heroes/antimage_female/debut/particles/blink/antimage_debut_blink_sparkles.vpcf"
--		local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, npc)
--		ParticleManager:SetParticleControl(pfx, 0, npc:GetAbsOrigin())
--		ParticleManager:ReleaseParticleIndex(pfx)
--		npc:SetAbsOrigin(blink_point)
--		npc:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)
--		npc:EmitSound("Hero_Antimage.Blink_out")
--
-- 
--	 
--	end)
--end

function AntimageThink(npc)
	Timers:CreateTimer(0, function()
		if ( not npc:IsAlive() ) then		--если юнит мертв
			return -1	
		end
		
		if npc.stop then	--если игра приостановлена
			return 1	
		end

		local point = Entities:FindByName(nil, "techies_end_point"):GetAbsOrigin()
		local blink_point = point + RandomVector(400)

		local effect = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, npc)
		ParticleManager:SetParticleControl(pfx, 0, npc:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		npc:SetAbsOrigin(blink_point)
		npc:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)
		npc:EmitSound("Hero_Antimage.Blink_out")

		local effect = "particles/units/heroes/hero_antimage/antimage_spell_blink.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, npc)
		ParticleManager:SetParticleControl(pfx, 0, blink_point)
		ParticleManager:ReleaseParticleIndex(pfx)

		npc:CastPointSkill("intro_rotate",point)
		return RandomInt(1, 4)
	end)
end

function MoveToPoint(unit, point)
	Timers:CreateTimer(0.1, function()
		ExecuteOrderFromTable({
			UnitIndex = unit:entindex(),		-- индекс кастера
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,				-- тип приказа
			Position = point,	 	-- положение врага
			Queue = false,						-- ждать очереди ?
		})	
	end)	
end

function CDOTA_BaseNPC:CastSkill(skill_name, unit)
	local ability = self:FindAbilityByName(skill_name)
	local order_type = nil

	if ability then
		if unit then
			ExecuteOrderFromTable({
				UnitIndex = self:entindex(),		-- индекс кастера
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,				-- тип приказа
				AbilityIndex = ability:entindex(),	-- индекс способности
				TargetIndex = unit:entindex(), 	-- индекс врага
				Queue = false,						-- ждать очереди ?
			})		
		else
			ExecuteOrderFromTable({
				UnitIndex = self:entindex(),		-- индекс кастера
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,				-- тип приказа
				AbilityIndex = ability:entindex(),	-- индекс способности
				Queue = false,						-- ждать очереди ?
			})		
		end
				
	else
		print("ability "..skill_name.." not found !!!")
	end
	
end

function CDOTA_BaseNPC:CastPointSkill(skill_name, point)
	local ability = self:FindAbilityByName(skill_name)

	if ability then
		ExecuteOrderFromTable({
		UnitIndex = self:entindex(),		-- индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,				-- тип приказа
		AbilityIndex = ability:entindex(),	-- индекс способности
		Position = point,	 	-- положение врага
		Queue = false,						-- ждать очереди ?
		})		

			
	else
		print("ability "..skill_name.." not found !!!")
	end
	
end
