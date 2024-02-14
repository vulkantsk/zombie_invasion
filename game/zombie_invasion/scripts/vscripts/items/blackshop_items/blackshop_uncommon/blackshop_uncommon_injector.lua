LinkLuaModifier( "modifier_blackshop_uncommon_injector", "items/blackshop_items/blackshop_uncommon/blackshop_uncommon_injector", LUA_MODIFIER_MOTION_NONE )
item_blackshop_uncommon_injector = class({})
function item_blackshop_uncommon_injector:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_uncommon_injector")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_uncommon_injector", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_uncommon_injector = class({})
function modifier_blackshop_uncommon_injector:IsHidden()
    return true
end

function modifier_blackshop_uncommon_injector:IsDebuff()
    return false
end

function modifier_blackshop_uncommon_injector:IsPurgable()
    return false
end

function modifier_blackshop_uncommon_injector:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_uncommon_injector:IsStunDebuff()
    return false
end

function modifier_blackshop_uncommon_injector:RemoveOnDeath()
    return false
end

function modifier_blackshop_uncommon_injector:DestroyOnExpire()
    return false
end


function modifier_blackshop_uncommon_injector:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end
function modifier_blackshop_uncommon_injector:GetModifierAttackSpeedBonus_Constant()
    return self:GetStackCount() * 15
end
function modifier_blackshop_uncommon_injector:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount() * 15
end