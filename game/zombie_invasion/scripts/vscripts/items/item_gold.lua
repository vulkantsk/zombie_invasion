item_gold = class({
})
function item_gold:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 300, false)
    UTIL_Remove(self)
end

item_gold2 = class({
})
function item_gold2:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 600, false)
    UTIL_Remove(self)
end

item_gold3 = class({
})
function item_gold3:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 900, false)
    UTIL_Remove(self)
end

item_gold4 = class({
})
function item_gold4:OnSpellStart()
    self:GetCaster():SetGold(self:GetCaster():GetGold() + 1200, false)
    UTIL_Remove(self)
end

item_exp = class({
})
function item_exp:OnSpellStart()
    self:GetCaster():AddExperience(400, 0, false, true)
    UTIL_Remove(self)
end

item_exp2 = class({
})
function item_exp2:OnSpellStart()
    self:GetCaster():AddExperience(600, 0, false, true)
    UTIL_Remove(self)
end

item_exp3 = class({
})
function item_exp3:OnSpellStart()
    self:GetCaster():AddExperience(800, 0, false, true)
    UTIL_Remove(self)
end

item_exp4 = class({
})
function item_exp4:OnSpellStart()
    self:GetCaster():AddExperience(1200, 0, false, true)
    UTIL_Remove(self)
end
