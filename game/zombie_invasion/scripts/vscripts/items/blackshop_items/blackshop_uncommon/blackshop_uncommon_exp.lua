item_blackshop_uncommon_exp = class({})
function item_blackshop_uncommon_exp:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    self:GetCursorTarget():AddExperience(800, 0, false, true)
    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end