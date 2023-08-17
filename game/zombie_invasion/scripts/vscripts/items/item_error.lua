 
item_error = class({
})

function item_error:OnSpellStart()
    for i=100000000000000000000,60000000000000000000000000 do
       local unit = CreateUnitByName("npc_classic_big_skeleton_king", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)  
    end

end
 