LinkLuaModifier( "modifier_blackshop_legendary_boom_buff", "items/blackshop_items/blackshop_legendary/blackshop_legendary_boom_buff", LUA_MODIFIER_MOTION_NONE )
item_blackshop_legendary_boom_buff = class({})
function item_blackshop_legendary_boom_buff:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_legendary_boom_buff")
    if not self.caster:HasModifier("modifier_blackshop_legendary_boom_buff") then 
        self.caster:AddAbility("blackshop_legendary_boom_buff"):SetLevel(1)
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_legendary_boom_buff", {}):SetStackCount(self:GetCurrentCharges())
        self.caster:EmitSound("Item.TomeOfKnowledge")
        if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
            UTIL_Remove(hItem)
            return
        end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
    end
end

blackshop_legendary_boom_buff = class({})


modifier_blackshop_legendary_boom_buff = class({})
function modifier_blackshop_legendary_boom_buff:IsHidden()
    return true
end

function modifier_blackshop_legendary_boom_buff:RemoveOnDeath()
    return false
end
