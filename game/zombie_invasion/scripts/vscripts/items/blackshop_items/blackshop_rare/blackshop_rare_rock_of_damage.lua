LinkLuaModifier( "modifier_blackshop_rare_rock_of_damage", "items/blackshop_items/blackshop_rare/blackshop_rare_rock_of_damage", LUA_MODIFIER_MOTION_NONE )
item_blackshop_rare_rock_of_damage = class({})
function item_blackshop_rare_rock_of_damage:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_rare_rock_of_damage")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_rare_rock_of_damage", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_rare_rock_of_damage = class({})
function modifier_blackshop_rare_rock_of_damage:IsHidden()
    return true
end

function modifier_blackshop_rare_rock_of_damage:IsDebuff()
    return false
end

function modifier_blackshop_rare_rock_of_damage:IsPurgable()
    return false
end

function modifier_blackshop_rare_rock_of_damage:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_rare_rock_of_damage:IsStunDebuff()
    return false
end

function modifier_blackshop_rare_rock_of_damage:RemoveOnDeath()
    return false
end

function modifier_blackshop_rare_rock_of_damage:DestroyOnExpire()
    return false
end


function modifier_blackshop_rare_rock_of_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end
function modifier_blackshop_rare_rock_of_damage:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * 175
end

function modifier_blackshop_rare_rock_of_damage:GetModifierMoveSpeedBonus_Constant()
    return -self:GetStackCount() * 45
end
