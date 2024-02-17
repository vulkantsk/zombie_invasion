LinkLuaModifier( "modifier_blackshop_epic_sword_cleave", "items/blackshop_items/blackshop_epic/blackshop_epic_sword_cleave", LUA_MODIFIER_MOTION_NONE )
item_blackshop_epic_sword_cleave = class({})
function item_blackshop_epic_sword_cleave:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_epic_sword_cleave")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_epic_sword_cleave", {}):SetStackCount(self:GetCurrentCharges())
    end
    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

