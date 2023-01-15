LinkLuaModifier("modifier_survior_passive", "modifiers/winter/modifier_survior_passive", LUA_MODIFIER_MOTION_NONE)

    local win = 0

function StartTouchWin_1( trigger )
 

    if win == 0 and trigger.activator:HasModifier("modifier_survior_passive") then 
    win = win + 1
     
    local unit = trigger.activator
    local home = Entities:FindByName( nil, "techies_start_point") --строка ищет как раз таки нашу точку pnt1
    local home_peng = Entities:FindByName( nil, "penguin_save"):GetAbsOrigin() --строка ищет как раз таки нашу точку pnt1
    local point = home:GetAbsOrigin()
    local peng = Entities:FindByName( nil, "penguin_1") --строка ищет как раз таки нашу точку pnt1     
 
    GiveGoldPlayers(375)
    GiveExperiencePlayers( 325 )
     _G.Penguin_save_1 = _G.Penguin_save_1 + 1


 
     unit:AddNewModifier(unit,self,"modifier_invulnerable",{})
     unit:RemoveModifierByName("modifier_survior_passive")
     local victory_particle = ParticleManager:CreateParticle('particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf', PATTACH_ABSORIGIN, unit)
     ParticleManager:SetParticleControl(victory_particle, 0, unit:GetAbsOrigin())
            
     unit:EmitSound("Hero_LegionCommander.Duel.Victory")   

    Timers:CreateTimer(5.0, function()  
        _G.Penguin_save_1 = _G.Penguin_save_1 + 1
        unit:SetAbsOrigin(point)
        unit:RemoveModifierByName("modifier_invulnerable")
        peng:SetAbsOrigin(home_peng + RandomVector( RandomFloat( 50, 150)))
    end)

    end
end

  local win2 = 0

function StartTouchWin_2( trigger )
 

    if win2 == 0 and trigger.activator:HasModifier("modifier_survior_passive") then 
    win2 = win2 + 1
     
    local unit = trigger.activator
    local home = Entities:FindByName( nil, "techies_start_point") --строка ищет как раз таки нашу точку pnt1
    local home_peng = Entities:FindByName( nil, "penguin_save"):GetAbsOrigin() --строка ищет как раз таки нашу точку pnt1
    local point = home:GetAbsOrigin()
    local peng = Entities:FindByName( nil, "penguin_2") --строка ищет как раз таки нашу точку pnt1     
 
 
    GiveGoldPlayers(650)
    GiveExperiencePlayers( 800 )

     _G.Penguin_save_2 = _G.Penguin_save_2 + 1


 
     unit:AddNewModifier(unit,self,"modifier_invulnerable",{})
     unit:RemoveModifierByName("modifier_survior_passive")
     local victory_particle = ParticleManager:CreateParticle('particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf', PATTACH_ABSORIGIN, unit)
     ParticleManager:SetParticleControl(victory_particle, 0, unit:GetAbsOrigin())
            
     unit:EmitSound("Hero_LegionCommander.Duel.Victory")   

    Timers:CreateTimer(5.0, function()  
        _G.Penguin_save_2 = _G.Penguin_save_2 + 1
        unit:SetAbsOrigin(point)
        unit:RemoveModifierByName("modifier_invulnerable")
        peng:SetAbsOrigin(home_peng + RandomVector( RandomFloat( 50, 150)))
    end)

    end
end
 

-----------------------------------------------------------------------------------------

  local win3 = 0

function StartTouchWin_3( trigger )
 

    if win3 == 0 and trigger.activator:HasModifier("modifier_survior_passive") then 
    win3 = win3 + 1
     
    local unit = trigger.activator
    local home = Entities:FindByName( nil, "techies_start_point") --строка ищет как раз таки нашу точку pnt1
    local home_peng = Entities:FindByName( nil, "penguin_save"):GetAbsOrigin() --строка ищет как раз таки нашу точку pnt1
    local point = home:GetAbsOrigin()
    local peng = Entities:FindByName( nil, "penguin_3") --строка ищет как раз таки нашу точку pnt1     
 
    GiveGoldPlayers(950)
    GiveExperiencePlayers( 1800 )

     _G.Penguin_save_3 = _G.Penguin_save_3 + 1


 
     unit:AddNewModifier(unit,self,"modifier_invulnerable",{})
     unit:RemoveModifierByName("modifier_survior_passive")
     local victory_particle = ParticleManager:CreateParticle('particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf', PATTACH_ABSORIGIN, unit)
     ParticleManager:SetParticleControl(victory_particle, 0, unit:GetAbsOrigin())
            
     unit:EmitSound("Hero_LegionCommander.Duel.Victory")   

    Timers:CreateTimer(5.0, function()  
        _G.Penguin_save_3 = _G.Penguin_save_3 + 1
        unit:SetAbsOrigin(point)
        unit:RemoveModifierByName("modifier_invulnerable")
        peng:SetAbsOrigin(home_peng + RandomVector( RandomFloat( 50, 150)))
    end)

    end
end


-----------------------------------------------------------------------------------------

  local win4 = 0

function StartTouchWin_4( trigger )
 

    if win4 == 0 and trigger.activator:HasModifier("modifier_survior_passive") then 
    win4 = win4 + 1
     
    local unit = trigger.activator
    local home = Entities:FindByName( nil, "techies_start_point") --строка ищет как раз таки нашу точку pnt1
    local home_peng = Entities:FindByName( nil, "penguin_save"):GetAbsOrigin() --строка ищет как раз таки нашу точку pnt1
    local point = home:GetAbsOrigin()
    local peng = Entities:FindByName( nil, "penguin_4") --строка ищет как раз таки нашу точку pnt1     
 
    GiveGoldPlayers(1500)
    GiveExperiencePlayers( 3250 )

     _G.Penguin_save_4 = _G.Penguin_save_4 + 1


 
     unit:AddNewModifier(unit,self,"modifier_invulnerable",{})
     unit:RemoveModifierByName("modifier_survior_passive")
     local victory_particle = ParticleManager:CreateParticle('particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf', PATTACH_ABSORIGIN, unit)
     ParticleManager:SetParticleControl(victory_particle, 0, unit:GetAbsOrigin())
            
     unit:EmitSound("Hero_LegionCommander.Duel.Victory")   

    Timers:CreateTimer(5.0, function()  
        _G.Penguin_save_4 = _G.Penguin_save_4 + 1
        unit:SetAbsOrigin(point)
        unit:RemoveModifierByName("modifier_invulnerable")
        peng:SetAbsOrigin(home_peng + RandomVector( RandomFloat( 50, 150)))
    end)

    end
end