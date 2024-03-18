LinkLuaModifier( "modifier_blackshop_legendary_octerinity", "items/blackshop_items/blackshop_legendary/blackshop_legendary_octerinity", LUA_MODIFIER_MOTION_NONE )
item_blackshop_legendary_octerinity = class({})
function item_blackshop_legendary_octerinity:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_legendary_octerinity")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_legendary_octerinity", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_legendary_octerinity = class({})
function modifier_blackshop_legendary_octerinity:IsHidden()
    return true
end

function modifier_blackshop_legendary_octerinity:IsDebuff()
    return false
end

function modifier_blackshop_legendary_octerinity:IsPurgable()
    return false
end

function modifier_blackshop_legendary_octerinity:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_legendary_octerinity:IsStunDebuff()
    return false
end

function modifier_blackshop_legendary_octerinity:RemoveOnDeath()
    return false
end

function modifier_blackshop_legendary_octerinity:DestroyOnExpire()
    return false
end


function modifier_blackshop_legendary_octerinity:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
    }
end
function modifier_blackshop_legendary_octerinity:GetModifierPercentageCooldown()
    return self:GetStackCount() * 5
end


function modifier_blackshop_legendary_octerinity:GetModifierPercentageManacost()
    return self:GetStackCount() * 5
end

function modifier_blackshop_legendary_octerinity:GetModifierPercentageCasttime()
    return -self:GetStackCount() * 0.5
end

