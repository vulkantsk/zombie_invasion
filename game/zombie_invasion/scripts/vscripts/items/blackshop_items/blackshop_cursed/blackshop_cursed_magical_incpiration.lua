LinkLuaModifier( "modifier_blackshop_cursed_magical_incpiration", "items/blackshop_items/blackshop_cursed/blackshop_cursed_magical_incpiration", LUA_MODIFIER_MOTION_NONE )
item_blackshop_cursed_magical_incpiration = class({})
function item_blackshop_cursed_magical_incpiration:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_cursed_magical_incpiration")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_cursed_magical_incpiration", {}):SetStackCount(self:GetCurrentCharges())
    end
    

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end
modifier_blackshop_cursed_magical_incpiration = class({})

function modifier_blackshop_cursed_magical_incpiration:IsHidden()
    return false
end

function modifier_blackshop_cursed_magical_incpiration:IsDebuff()
    return false
end

function modifier_blackshop_cursed_magical_incpiration:IsPurgable()
    return false
end

function modifier_blackshop_cursed_magical_incpiration:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_cursed_magical_incpiration:IsStunDebuff()
    return false
end

function modifier_blackshop_cursed_magical_incpiration:RemoveOnDeath()
    return false
end

function modifier_blackshop_cursed_magical_incpiration:DestroyOnExpire()
    return false
end


function modifier_blackshop_cursed_magical_incpiration:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_blackshop_cursed_magical_incpiration:GetModifierSpellAmplify_Percentage()
    return 200 * self:GetStackCount()
end

function modifier_blackshop_cursed_magical_incpiration:GetModifierIncomingPhysicalDamage_Percentage()
    return 10000
end

function modifier_blackshop_cursed_magical_incpiration:GetModifierIncomingDamage_Percentage()
    return 10000
end



