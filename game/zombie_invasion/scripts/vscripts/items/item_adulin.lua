 
item_adulin = class({
})

function item_adulin:OnSpellStart()
    local unit = CreateUnitByName("npc_classic_alduin_boss", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)  
    self:GetCaster():RemoveItem(self)
end
 