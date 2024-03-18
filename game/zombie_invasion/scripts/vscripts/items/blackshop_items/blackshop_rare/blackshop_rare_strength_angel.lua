LinkLuaModifier( "modifier_blackshop_rare_strength_angel", "items/blackshop_items/blackshop_rare/blackshop_rare_strength_angel", LUA_MODIFIER_MOTION_NONE )
item_blackshop_rare_strength_angel = class({})
function item_blackshop_rare_strength_angel:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_rare_strength_angel")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_rare_strength_angel", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_rare_strength_angel = class({})
function modifier_blackshop_rare_strength_angel:IsHidden()
    return true
end

function modifier_blackshop_rare_strength_angel:IsDebuff()
    return false
end

function modifier_blackshop_rare_strength_angel:IsPurgable()
    return false
end

function modifier_blackshop_rare_strength_angel:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_rare_strength_angel:IsStunDebuff()
    return false
end

function modifier_blackshop_rare_strength_angel:RemoveOnDeath()
    return false
end

function modifier_blackshop_rare_strength_angel:DestroyOnExpire()
    return false
end


function modifier_blackshop_rare_strength_angel:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS
    }
end
function modifier_blackshop_rare_strength_angel:GetModifierHealthBonus()
    return self:GetStackCount() * 180
end

function modifier_blackshop_rare_strength_angel:GetModifierExtraStrengthBonus()
    return self:GetStackCount() * 15
end
