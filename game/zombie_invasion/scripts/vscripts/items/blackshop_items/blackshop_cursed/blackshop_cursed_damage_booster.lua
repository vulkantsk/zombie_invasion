LinkLuaModifier( "modifier_blackshop_cursed_damage_booster", "items/blackshop_items/blackshop_cursed/blackshop_cursed_damage_booster", LUA_MODIFIER_MOTION_NONE )
item_blackshop_cursed_damage_booster = class({})
function item_blackshop_cursed_damage_booster:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_cursed_damage_booster")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_cursed_damage_booster", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_cursed_damage_booster = class({})
function modifier_blackshop_cursed_damage_booster:IsHidden()
    return true
end

function modifier_blackshop_cursed_damage_booster:IsDebuff()
    return false
end

function modifier_blackshop_cursed_damage_booster:IsPurgable()
    return false
end

function modifier_blackshop_cursed_damage_booster:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_cursed_damage_booster:IsStunDebuff()
    return false
end

function modifier_blackshop_cursed_damage_booster:RemoveOnDeath()
    return false
end

function modifier_blackshop_cursed_damage_booster:DestroyOnExpire()
    return false
end

function modifier_blackshop_cursed_damage_booster:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
end

function modifier_blackshop_cursed_damage_booster:OnCreated()
    self:StartIntervalThink(60)
end

function modifier_blackshop_cursed_damage_booster:OnIntervalThink()
    if RollPercentage(5 * self:GetStackCount()) then
        self:GetCaster():ForceKill(false)
    end
end

function modifier_blackshop_cursed_damage_booster:GetModifierBonusStats_Strength()
    return self:GetCaster():GetBaseStrength() * 2 * self:GetStackCount()
end

function modifier_blackshop_cursed_damage_booster:GetModifierBonusStats_Agility()
    return self:GetCaster():GetBaseAgility() * 2 * self:GetStackCount()
end

function modifier_blackshop_cursed_damage_booster:GetModifierBonusStats_Intellect()
    return self:GetCaster():GetBaseIntellect() * 2 * self:GetStackCount()
end

