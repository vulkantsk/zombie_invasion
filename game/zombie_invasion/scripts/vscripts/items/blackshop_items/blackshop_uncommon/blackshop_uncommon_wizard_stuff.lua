LinkLuaModifier( "modifier_blackshop_uncommon_wizard_stuff", "items/blackshop_items/blackshop_uncommon/blackshop_uncommon_wizard_stuff", LUA_MODIFIER_MOTION_NONE )
item_blackshop_uncommon_wizard_stuff = class({})
function item_blackshop_uncommon_wizard_stuff:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_uncommon_wizard_stuff")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_uncommon_wizard_stuff", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_uncommon_wizard_stuff = class({})
function modifier_blackshop_uncommon_wizard_stuff:IsHidden()
    return true
end

function modifier_blackshop_uncommon_wizard_stuff:IsDebuff()
    return false
end

function modifier_blackshop_uncommon_wizard_stuff:IsPurgable()
    return false
end

function modifier_blackshop_uncommon_wizard_stuff:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_uncommon_wizard_stuff:IsStunDebuff()
    return false
end

function modifier_blackshop_uncommon_wizard_stuff:RemoveOnDeath()
    return false
end

function modifier_blackshop_uncommon_wizard_stuff:DestroyOnExpire()
    return false
end


function modifier_blackshop_uncommon_wizard_stuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end
function modifier_blackshop_uncommon_wizard_stuff:GetModifierSpellAmplify_Percentage()
    return self:GetStackCount() * 15
end
