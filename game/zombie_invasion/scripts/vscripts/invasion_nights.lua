zombie_count = 0 

zombie_count_2 = 0 
rollBase_2 = 1.5

zombie_count_3 = 0 
rollBase_3 = 1.5

zombie_count_4 = 0 
rollBase_4 = 1.5

zombie_count_5 = 0 
rollBase_5 = 1.5

rollBase_65 = 1.5
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
 	if GetMapName() == "invasion_refresh" then
    	self:SpawnZombie("npc_classic_wave_zombie",6)
		self:SpawnZombie("npc_classic_wave_zombie_down",3)
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
	else			

			local spawn_zmb = 0
			Timers:CreateTimer(0, function()
		     while spawn_zmb < 22 do
			     spawn_zmb = spawn_zmb + 1
    	         self:SpawnZombie("npc_classic_big_pig_wave",8)     
			     return 10
			 end		
			 Timers:CreateTimer(270, function()
		 return nil	 
 
		end)
    		 end)
			Timers:CreateTimer(150,function()
    		    self:SpawnZombie("npc_boss_pig_wave",1)
			end) 
		
			Timers:CreateTimer(225,function()
				    InvasionMode:SpawnBoss("npc_boss_pig_pet_wave", 1)
				
			end) 
		
		
			
		

	end


end

 function InvasionMode:ZombieNight2()  
 -- 2 НОЧЬ
 	if GetMapName() == "invasion_refresh" then
    	local spawn_zmb = 0
    	self:SpawnZombie("npc_suic_wave_zombie",2)
    	self:SpawnZombie("npc_classic_wave_big_zombie",6)
 	
		
 		Timers:CreateTimer(0, function()
		     while spawn_zmb < 12 do
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
	else

		local spawn_zmb = 0
	
 	Timers:CreateTimer(0, function()
	     while spawn_zmb < 16 do
		     spawn_zmb = spawn_zmb + 1
             self:SpawnZombie("npc_Edgard_wave",6)     

             InvasionMode:SpawnBoss("npc_wave_boss_suicide_fun", 1)
		     return 10
		 end		
		 Timers:CreateTimer(270, function()
		 return nil	 

	end) 
		end)
 
end
end
 	 

function InvasionMode:ZombieNight3()  	
  -- 3 НОЧЬ 
 
 	if GetMapName() == "invasion_refresh" then
    	self:SpawnZombie("npc_classic_wave_ghoul",6)
 	
 	
	
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
	else
		Timers:CreateTimer(0,function()
			 self:SpawnZombie("npc_wave_boss_ghost",3)
		end)
		Timers:CreateTimer(10,function()
			 self:SpawnZombie("npc_wave_boss_suicide_2",3)
		end)
		Timers:CreateTimer(30,function()
			 self:SpawnZombie("npc_creep_impossible",6)
		end)
		Timers:CreateTimer(60,function()
			 self:SpawnZombie("npc_wave_boss_viper",3)
		end)
		Timers:CreateTimer(90,function()
			 self:SpawnZombie("npc_wave_boss_undying_2",5)
		end)
		Timers:CreateTimer(180,function()
			 self:SpawnZombie("npc_wave_boss_necr",8)
		end)
		Timers:CreateTimer(220,function()
			 self:SpawnZombie("npc_wave_boss_pudge",4)
		end)
	end

 
 end
 
  	   
 

 function InvasionMode:ZombieNight4()  
   -- 4 НОЧЬ 
 	if GetMapName() == "invasion_refresh" then
    	self:SpawnZombie("npc_classic_wave_ghoul_2",3)
 	
		
		Timers:CreateTimer(150,function()
			 self:SpawnZombie("npc_undying_4",1)
		end)
	
 	
 		Timers:CreateTimer(225,function()
			  GameRules:SendCustomMessage("#Game_notification_boss_spawn_meatgolem_2",0,0)
			  InvasionMode:SpawnBoss("npc_wave_boss_meat_golem_2", 1)
		end) 	
	else
		Timers:CreateTimer(0,function()
			 self:SpawnZombie("npc_classic_wave_ghoul",4)
			 Timers:CreateTimer(270, function()
		 return 10	 
		end)
		end)
		Timers:CreateTimer(90,function()
			 self:SpawnZombie("npc_wave_boss_viper",1)
		end)
		Timers:CreateTimer(180,function()
			 self:SpawnZombie("npc_classic_necr",20)
			 Timers:CreateTimer(120, function()
		 return 10	 
		end)
		end)
	end
 

end

function InvasionMode:ZombieNight5()  

 
    local spawn_zmb = 0
    self:SpawnZombie("npc_classic_wave_pudge",2)
 
	
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

 
    self:SpawnZombie("npc_classic_wave_pudge_2",6)
 
 	Timers:CreateTimer(225,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_undying",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_undying_2", 1)
	end) 	
 

end

function InvasionMode:NextNight7()
	local spawn_zmb = 0
	self:SpawnZombie("npc_classic_necr",4)
 
	Timers:CreateTimer(0, function()
	     while spawn_zmb < 6 do
		     spawn_zmb = spawn_zmb + 1
             self:SpawnZombie("npc_classic_necr",4)     
		     return 10
		 end		
		 return nil	 
	end) 

 	Timers:CreateTimer(60,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_viper",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_viper", 1)
	end) 
	Timers:CreateTimer(120,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_viper",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_viper", 1)
	end) 
	Timers:CreateTimer(180,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_viper",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_viper", 1)
	end) 
	Timers:CreateTimer(240,function()
 		  GameRules:SendCustomMessage("#Game_notification_boss_spawn_viper",0,0)
		  InvasionMode:SpawnBoss("npc_wave_boss_viper", 1)
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
