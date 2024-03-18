LinkLuaModifier( "modifier_blackshop_rare_lens_of_wisdon", "items/blackshop_items/blackshop_rare/blackshop_rare_lens_of_wisdon", LUA_MODIFIER_MOTION_NONE )
item_blackshop_rare_lens_of_wisdon = class({})
function item_blackshop_rare_lens_of_wisdon:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_rare_lens_of_wisdon")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_rare_lens_of_wisdon", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_rare_lens_of_wisdon = class({})
function modifier_blackshop_rare_lens_of_wisdon:IsHidden()
    return true
end

function modifier_blackshop_rare_lens_of_wisdon:IsDebuff()
    return false
end

function modifier_blackshop_rare_lens_of_wisdon:IsPurgable()
    return false
end

function modifier_blackshop_rare_lens_of_wisdon:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_rare_lens_of_wisdon:IsStunDebuff()
    return false
end

function modifier_blackshop_rare_lens_of_wisdon:RemoveOnDeath()
    return false
end

function modifier_blackshop_rare_lens_of_wisdon:DestroyOnExpire()
    return false
end


function modifier_blackshop_rare_lens_of_wisdon:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end
function modifier_blackshop_rare_lens_of_wisdon:GetModifierCastRangeBonus()
    return self:GetStackCount() * 75
end


function modifier_blackshop_rare_lens_of_wisdon:GetModifierAttackRangeBonus()
    return self:GetStackCount() * 55
end
