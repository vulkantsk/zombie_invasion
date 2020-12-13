if EndGame == nil then
	EndGame = class({})
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

	Timers:CreateTimer(0,function()
				--направить текиса в точку
		MoveToPoint(techies, techies_end_point)
		--направить пуджа на точку
		MoveToPoint(pudge, pudge_end_point)
		--направить ама на точку
		MoveToPoint(antimage1, antimage_end_point)
	end)
	
	Timers:CreateTimer(9,function()
		--направить лицо ама на текиса 
		antimage1:CastPointSkill("intro_rotate",techies:GetAbsOrigin())
		--напривить лицо пуджа на текиса + анимация
		pudge:CastPointSkill("intro_rotate",techies:GetAbsOrigin())
	end)
	
	Timers:CreateTimer(10,function()
		--текис поворачивает голову в сторону ама
		techies:CastPointSkill("intro_rotate",antimage1:GetAbsOrigin())
	end)
	
	Timers:CreateTimer(11,function()
		--текис поворачивает голову в сторону пуджа
		techies:CastPointSkill("intro_rotate",pudge:GetAbsOrigin())
	end)
	
	Timers:CreateTimer(12,function()
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
				Timers:CreateTimer(1,function()
			AntimageThink(antimage1)
		end)		
					Timers:CreateTimer(2,function()
			AntimageThink(antimage2)
		end)	
		antimage1:SetAbsOrigin(point + RandomVector(50))
	 

		antimage2 = CreateUnitByName("npc_end_antimage", point + RandomVector(50), false, nil, nil, DOTA_TEAM_BADGUYS)
		antimage2:SetForwardVector(fw)
 

		antimage3 = CreateUnitByName("npc_end_antimage", point + RandomVector(50), false, nil, nil, DOTA_TEAM_BADGUYS)
		antimage3:SetForwardVector(fw)
		Timers:CreateTimer(3,function()
 
		end)
		
	end)

	Timers:CreateTimer(19,function()
		--пудж издаёт звук
		pudge:EmitSound("pudge_pud_anger_0"..RandomInt(1, 5))
	end)
	
	Timers:CreateTimer(19,function()
		--пудж издаёт звук
		pudge:EmitSound("pudge_pud_anger_0"..RandomInt(1, 5))
	end)
	
	Timers:CreateTimer(25,function()
		--насмешка текиса
		techies:CastSkill("techies_taunt")
	end)
	
	Timers:CreateTimer(29,function()
		--ам ульта
		antimage1.stop = true
		antimage1:CastSkill("antimage_ult", techies)
	end)
	
	Timers:CreateTimer(31,function()
		--санстрайк мимо
		antimage1.stop = false
		
		techies:EmitSound("Hero_Invoker.SunStrike.Ignite")


		local point = techies_end_point+RandomVector(300)
		local effect = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, point)

		ParticleManager:ReleaseParticleIndex(pfx)

	end)
	
	Timers:CreateTimer(39,function()
		--появляется мишка + идёт на текиса
		local fw = pudge:GetForwardVector()
		local point = pudge:GetAbsOrigin()+fw*100

		pudge_bear = CreateUnitByName("npc_end_bear", point, false, nil, nil, DOTA_TEAM_BADGUYS)
		pudge_bear:SetForwardVector(fw)
		MoveToPoint(pudge_bear, techies_end_point)
	end)
	
	Timers:CreateTimer(41,function()
		--текис стреляет в медведя
		techies:CastSkill("techies_attack", pudge_bear)
	end)
	
	Timers:CreateTimer(51,function()
		--пудж падает
		pudge:CastSkill("pudge_death")
	end)
	
	Timers:CreateTimer(60,function()
		--пудж издаёт звук
		pudge:EmitSound("pudge_pud_anger_0"..RandomInt(1, 5))
	end)
	
	Timers:CreateTimer(65,function()
		--текис насмешка
		techies:CastSkill("techies_taunt")
	end)
	
	Timers:CreateTimer(72,function()
		--текис насмешка
		techies:CastSkill("techies_taunt")
	end)
	
	Timers:CreateTimer(77,function()
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
	end)
	
	Timers:CreateTimer(78,function()
		--мина пищит
		techies:EmitSound("Hero_Techies.LandMine.Priming")
	end)
	
	Timers:CreateTimer(79,function()
		antimage1:CastSkill("antimage_attack", techies)
		antimage2:CastSkill("antimage_attack", techies)
		antimage3:CastSkill("antimage_attack", techies)
	end)
	
	Timers:CreateTimer(80,function()
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
	end)
	
	Timers:CreateTimer(83, function() 
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) 
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
