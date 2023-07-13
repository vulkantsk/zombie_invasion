zombie_count = 0 

zombie_count_2 = 0 
rollBase_2 = 1.5

zombie_count_3 = 0 

zombie_count_4 = 0 
rollBase_4 = 1.5

zombie_count_5 = 0 
rollBase_5 = 1.5

necr_count = 0

zombie_count_6 = 0 
rollBase_6 = 2.8

zombie_count_7 = 0 
rollBase_7 = 1.8

zombie_count_hal = 0 
ghost_count_hal = 0

zombie_count_new = 0
ghost_count_new = 0 

function InvasionMode:ZombieNight1()  
 
    self:SpawnZombie("npc_classic_wave_zombie",11)

	Timers:CreateTimer(150,function()
        self:SpawnZombie("npc_undying_1",1)
	end) 

	Timers:CreateTimer(225,function()
		local zombie_boss_1 =  RandomInt(1,2)

		if zombie_boss_1 == 1 then 
 		    GameRules:SendCustomMessage("#Game_notification_boss_spawn_half_zombie",0,0)
		    InvasionMode:SpawnBoss("npc_wave_boss_half_zombie", 1)
		elseif zombie_boss_1 == 2 then 
 		    GameRules:SendCustomMessage("#Game_notification_boss_spawn_big_zombie",0,0)
		    InvasionMode:SpawnBoss("npc_wave_boss_big_zombie", 1)
	    end
	end) 

end

 function InvasionMode:ZombieNight2()  
 -- 2 НОЧЬ
 
    local spawn_zmb = 0
    self:SpawnZombie("npc_classic_wave_big_zombie",3)
 
	
 	Timers:CreateTimer(0, function()
	     while spawn_zmb < 5 do
		     spawn_zmb = spawn_zmb + 1
             self:SpawnZombie("npc_classic_wave_big_zombie",1)     
		     return 10
		 end		
		 return nil	 
	end)
 
	Timers:CreateTimer(90,function()
		 self:SpawnZombie("npc_undying_2",1)
	end)
 
	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_2",1)
	end)
	 
	Timers:CreateTimer(225,function()
		local zombie_boss_2 =  RandomInt(1,3)
		if zombie_boss_2 == 1 then 
		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_suicide",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_suicide", 1)
		elseif zombie_boss_2 == 2 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_necr",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_necr", 1)
		elseif zombie_boss_2 == 3 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_meatgolem",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_meat_golem", 1)		  
	     end
	end) 	
 

end
 	 

function InvasionMode:ZombieNight3()  	
  -- 3 НОЧЬ 
 
    self:SpawnZombie("npc_classic_wave_ghoul",11)
 
 

	Timers:CreateTimer(90,function()
		 self:SpawnZombie("npc_undying_3",1)
	end)

	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_3",1)
	end)
	
 
 	Timers:CreateTimer(225,function()
		local zombie_boss_3 =  RandomInt(1,3)
		if zombie_boss_3 == 1 then 
		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_ghost",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_ghost", 1)
		elseif zombie_boss_3 == 2 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_pudge",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_pudge", 1)
		elseif zombie_boss_3 == 3 then 
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_undying",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_undying", 1)		  
	     end
	end) 	
 
 end
 
  	   
 

 function InvasionMode:ZombieNight4()  
   -- 4 НОЧЬ 
 
    self:SpawnZombie("npc_classic_wave_ghoul_2",11)
 
 
	
	Timers:CreateTimer(150,function()
		 self:SpawnZombie("npc_undying_4",1)
	end)

 
 	Timers:CreateTimer(225,function()
		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_meatgolem_2",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_meat_golem_2", 1)
	end) 	
 

end

function InvasionMode:ZombieNight5()  

 
    local spawn_zmb = 0
    self:SpawnZombie("npc_classic_wave_pudge",3)
 
	
 	Timers:CreateTimer(0, function()
	     while spawn_zmb < 5 do
		     spawn_zmb = spawn_zmb + 1
             self:SpawnZombie("npc_classic_wave_pudge",1)     
		     return 10
		 end		
		 return nil	 
	end) 
 
 	Timers:CreateTimer(225,function()
		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_suicide",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_suicide_2", 1)
	end) 	
 

end

 function InvasionMode:ZombieNight6()  

 
    self:SpawnZombie("npc_classic_wave_pudge_2",11)
 
 	Timers:CreateTimer(225,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_undying",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_undying_2", 1)
	end) 	
 

end

function InvasionMode:NextNight7()
	local spawn_zmb = 0
	self:SpawnZombie("npc_classic_necr",2)
 
	Timers:CreateTimer(0, function()
	     while spawn_zmb < 5 do
		     spawn_zmb = spawn_zmb + 1
             self:SpawnZombie("npc_classic_necr",12)     
		     return 10
		 end		
		 return nil	 
	end) 

 	Timers:CreateTimer(225,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_viper",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_viper", 3)
	end) 
end


 function InvasionMode:ZombieNight8()  

 
    self:SpawnZombie("npc_classic_wave_greater_zombie",11)
 

end







 function InvasionMode:ZombieNightUnreal()  

 
    self:SpawnZombie("npc_creep_impossible",11)
 

end







function InvasionMode:ChristmasNight()  
 
    local wave_4 = 0
	
  	Timers:CreateTimer(300,function()
		 self:SpawnZombie("npc_classic_new_years",8)
		 self:SpawnGhost("npc_classic_new_years_lich",1)
	end)
 

	Timers:CreateTimer(600,function()
		GameRules:SetTimeOfDay(0.3)
	end)

	Timers:CreateTimer(602,function()
	    EmitGlobalSound("christmas_ne_Bydet")
	    InvasionMode:ChristmassEror()
	end)
 
end

function InvasionMode:ZombieNightHalloween()  
   -- Хэлуинская НОЧЬ 
  
    local wave_4 = 0
 
  	Timers:CreateTimer(0,function()
		 self:SpawnZombie("npc_classic_wave_golem",12)
		 self:SpawnGhost("npc_classic_wave_fly_pudge",6)
	end)
	
	Timers:CreateTimer(0, function()
	     while wave_4 < 30 do
			 wave_4 = wave_4 + 1
			 

 
		     return 10
		 end			 
	end)

	
 

	Timers:CreateTimer(0, function()
	    while wave_4 < 26 do 
			 self:SpawnZombie("npc_classic_wave_fire_golem",1)
		     return 35
		end
	end)



	Timers:CreateTimer(90,function()
		 self:SpawnZombie("npc_undying_clock",1)
	end)

	Timers:CreateTimer(210,function()
		 self:SpawnZombie("npc_undying_clock",1)
	end)
	
	Timers:CreateTimer(300,function()
		  InvasionMode:HalloweenEnd()
	end)
 
end
