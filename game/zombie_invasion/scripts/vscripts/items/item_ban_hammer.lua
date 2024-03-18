item_ban_hammer = class({})

function item_ban_hammer:OnSpellStart()
    --print("OnSpellStart")
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
    local hItem = self
        hCaster:EmitSound("DOTA_Item.Cheese.Activate")
        UTIL_Remove(hTarget)
end