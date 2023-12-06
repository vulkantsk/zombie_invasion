item_book_of_heroes = class({})

function item_book_of_heroes:OnSpellStart()
     local caster = self:GetCaster()
     local hero = caster:GetUnitName()
     local hItem = self
     if caster:GetLevel() >= 25 then
         caster:EmitSound("DOTA_Item.Cheese.Activate")
         caster:AddItemByName("item_"..hero)
         if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
            caster:RemoveItem(hItem)
            return
         end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
     end
end 

