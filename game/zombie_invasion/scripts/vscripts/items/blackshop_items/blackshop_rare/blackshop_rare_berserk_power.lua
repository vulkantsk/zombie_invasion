LinkLuaModifier( "modifier_blackshop_rare_berserk_power", "items/blackshop_items/blackshop_rare/blackshop_rare_berserk_power", LUA_MODIFIER_MOTION_NONE )
item_blackshop_rare_berserk_power = class({})
function item_blackshop_rare_berserk_power:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_rare_berserk_power")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_rare_berserk_power", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_rare_berserk_power = class({})
function modifier_blackshop_rare_berserk_power:IsHidden()
    return false
end

function modifier_blackshop_rare_berserk_power:IsDebuff()
    return false
end

function modifier_blackshop_rare_berserk_power:IsPurgable()
    return false
end

function modifier_blackshop_rare_berserk_power:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_rare_berserk_power:IsStunDebuff()
    return false
end

function modifier_blackshop_rare_berserk_power:RemoveOnDeath()
    return false
end

function modifier_blackshop_rare_berserk_power:DestroyOnExpire()
    return false
end


function modifier_blackshop_rare_berserk_power:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
    }
end
function modifier_blackshop_rare_berserk_power:GetModifierProcAttack_BonusDamage_Magical()
    return self:GetStackCount() * 75
end
