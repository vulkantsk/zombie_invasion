LinkLuaModifier( "modifier_blackshop_cursed_intellectual_moving", "items/blackshop_items/blackshop_cursed/blackshop_cursed_intellectual_moving", LUA_MODIFIER_MOTION_NONE )
item_blackshop_cursed_intellectual_moving = class({})
function item_blackshop_cursed_intellectual_moving:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_cursed_intellectual_moving")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_cursed_intellectual_moving", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end
modifier_blackshop_cursed_intellectual_moving = class({})
function modifier_blackshop_cursed_intellectual_moving:IsHidden()
    return true
end

function modifier_blackshop_cursed_intellectual_moving:IsDebuff()
    return false
end

function modifier_blackshop_cursed_intellectual_moving:IsPurgable()
    return false
end

function modifier_blackshop_cursed_intellectual_moving:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_cursed_intellectual_moving:IsStunDebuff()
    return false
end

function modifier_blackshop_cursed_intellectual_moving:RemoveOnDeath()
    return false
end

function modifier_blackshop_cursed_intellectual_moving:DestroyOnExpire()
    return false
end


function modifier_blackshop_cursed_intellectual_moving:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
end
function modifier_blackshop_cursed_intellectual_moving:GetModifierBonusStats_Intellect()
    return 70 / 100 * self:GetCaster():GetBaseIntellect()
end
function modifier_blackshop_cursed_intellectual_moving:GetModifierBonusStats_Strength()
    return -35 / 100 * self:GetCaster():GetBaseStrength()
end
function modifier_blackshop_cursed_intellectual_moving:GetModifierBonusStats_Agility()
    return -35 / 100 * self:GetCaster():GetBaseAgility()
end

