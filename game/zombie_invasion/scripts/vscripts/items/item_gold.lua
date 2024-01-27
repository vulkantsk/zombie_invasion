item_gold = class({
})
function item_gold:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 150, false)
    self:GetCaster():RemoveItem(self)
end

item_gold2 = class({
})
function item_gold2:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 300, false)
    self:GetCaster():RemoveItem(self)
end

item_gold3 = class({
})
function item_gold3:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 450, false)
    self:GetCaster():RemoveItem(self)
end

item_gold4 = class({
})
function item_gold4:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 600, false)
    self:GetCaster():RemoveItem(self)
end

item_exp = class({
})
function item_exp:OnSpellStart()
    self:GetCaster():AddExperience(150, 0, false, true)
    self:GetCaster():RemoveItem(self)
end

item_exp2 = class({
})
function item_exp2:OnSpellStart()
    self:GetCaster():AddExperience(300, 0, false, true)
    self:GetCaster():RemoveItem(self)
end

item_exp3 = class({
})
function item_exp3:OnSpellStart()
    self:GetCaster():AddExperience(450, 0, false, true)
    self:GetCaster():RemoveItem(self)
end

item_exp4 = class({
})
function item_exp4:OnSpellStart()
    self:GetCaster():AddExperience(600, 0, false, true)
    self:GetCaster():RemoveItem(self)
end
