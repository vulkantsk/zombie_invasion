--LinkLuaModifier("modifier_extra_kick", "modifiers/modifier_extra_kick.lua", LUA_MODIFIER_MOTION_NONE )


 

function Bitch123()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone1", point, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit.respawn = false    
    unit:SetForwardVector(RandomVector(1))
 
end

function tombstone_night_2()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone2", point, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit.respawn = false    
    unit:SetForwardVector(RandomVector(1))
 
end

function tombstone_night_3()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit.respawn = false    
    unit:SetForwardVector(RandomVector(1))

end

function tombstone_night_4()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone4", point, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit.respawn = false    
    unit:SetForwardVector(RandomVector(1))

end
 
function tombstone_flash_1()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner_2"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone_flash_1", point, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit.respawn = false    
    unit:SetForwardVector(RandomVector(1))

    local point_2 = nil  -- отвечает за то, где появиться свинья
    local unit_2 = nil  -- Кто появиться
    
 
    point_2 = Entities:FindByName( nil, "tomb_spawner_1"):GetAbsOrigin()
    unit_2 = CreateUnitByName("npc_tombstone_flash_2", point_2, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit_2.respawn = false    
    unit_2:SetForwardVector(RandomVector(1))
 
end

function tombstone_flash_2()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner_2"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone_flash_3", point, true, nil, nil, DOTA_TEAM_BADGUYS)
 
 
    local point_2 = nil  -- отвечает за то, где появиться свинья
    local unit_2 = nil  -- Кто появиться
    
 
    point_2 = Entities:FindByName( nil, "tomb_spawner_1"):GetAbsOrigin()
    unit_2 = CreateUnitByName("npc_tombstone_flash_4", point_2, true, nil, nil, DOTA_TEAM_BADGUYS)
    
 
 
end

function tombstone_night_clock()

    local point = nil  -- отвечает за то, где появиться свинья
    local unit = nil  -- Кто появиться
    
 
    point = Entities:FindByName( nil, "tomb_spawner"):GetAbsOrigin()
    unit = CreateUnitByName("npc_tombstone_clock", point, true, nil, nil, DOTA_TEAM_BADGUYS)
 

end