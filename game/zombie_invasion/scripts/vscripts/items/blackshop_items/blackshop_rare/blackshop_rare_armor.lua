LinkLuaModifier( "modifier_blackshop_rare_armor", "items/blackshop_items/blackshop_rare/blackshop_rare_armor", LUA_MODIFIER_MOTION_NONE )
item_blackshop_rare_armor = class({})
function item_blackshop_rare_armor:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_rare_armor")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_rare_armor", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_rare_armor = class({})
function modifier_blackshop_rare_armor:IsHidden()
    return true
end

function modifier_blackshop_rare_armor:IsDebuff()
    return false
end

function modifier_blackshop_rare_armor:IsPurgable()
    return false
end

function modifier_blackshop_rare_armor:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_rare_armor:IsStunDebuff()
    return false
end

function modifier_blackshop_rare_armor:RemoveOnDeath()
    return false
end

function modifier_blackshop_rare_armor:DestroyOnExpire()
    return false
end


function modifier_blackshop_rare_armor:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end
function modifier_blackshop_rare_armor:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * 12
end

function modifier_blackshop_rare_armor:GetModifierAttackSpeedBonus_Constant()
    return -self:GetStackCount() * 45
end
