
anduin_sekelet = class({})
 
function anduin_sekelet:OnSpellStart()
    for i=1,4 do
       local unit = CreateUnitByName("npc_classic_big_skeleton_king", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)  
    end
     
end
