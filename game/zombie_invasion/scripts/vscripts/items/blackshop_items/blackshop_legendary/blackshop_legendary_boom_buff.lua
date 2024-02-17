LinkLuaModifier( "modifier_blackshop_legendary_boom_buff", "items/blackshop_items/blackshop_legendary/blackshop_legendary_boom_buff", LUA_MODIFIER_MOTION_NONE )
item_blackshop_legendary_boom_buff = class({})
function item_blackshop_legendary_boom_buff:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_legendary_boom_buff")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddAbility("blackshop_legendary_boom_buff"):SetLevel(1)
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_legendary_boom_buff", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

blackshop_legendary_boom_buff = class({})


modifier_blackshop_legendary_boom_buff = class({})
function modifier_blackshop_legendary_boom_buff:IsHidden()
    return true
end
