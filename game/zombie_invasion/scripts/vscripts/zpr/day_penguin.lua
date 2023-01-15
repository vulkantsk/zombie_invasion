LinkLuaModifier("modifier_survior_passive", "modifiers/winter/modifier_survior_passive", LUA_MODIFIER_MOTION_NONE)

function StartTouchPenguin( trigger )
    local ent = nil

   if current_day == 1 and Penguin_save_1 == 0 then 
       ent = Entities:FindByName( nil, "slide_penguin_1") --строка ищет как раз таки нашу точку pnt1
   elseif current_day == 2 and Penguin_save_2 == 0 then
       ent = Entities:FindByName( nil, "slide_penguin_2") --строка ищет как раз таки нашу точку pnt1
   elseif current_day == 3 and Penguin_save_3 == 0 then
       ent = Entities:FindByName( nil, "slide_penguin_3") --строка ищет как раз таки нашу точку pnt1
   elseif current_day == 4 and Penguin_save_4 == 0 then
       ent = Entities:FindByName( nil, "slide_penguin_4") --строка ищет как раз таки нашу точку pnt1
   end
   local point = ent:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты

   trigger.activator:SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
   FindClearSpaceForUnit(trigger.activator, point, false) --нужно чтобы герой не застрял
   trigger.activator:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке
   trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_survior_passive", {})
end

 

-----------------------------------------------------------------------------------------

 