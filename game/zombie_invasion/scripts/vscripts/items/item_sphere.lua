Item_sphere = {}

function Item_sphere:new(items)
    local itemExample = {}
 
    function itemExample:OnSpellStart()
        local caster = self:GetCaster()
        local cost = self:GetSpecialValueFor("cost")
        local position = caster:GetAbsOrigin()

        if caster:GetGold() < cost then return caster:DropItemAtPositionImmediate(self, position)  end

        caster:SpendGold(cost, DOTA_ModifyGold_PurchaseItem)
        UTIL_Remove(self)

        caster:AddItemByName(items[RandomInt(1,#items)])
     end
 
    return itemExample
end
