LinkLuaModifier("modifier_blackshop_legendary_magic_mushroom", "items/blackshop_items/blackshop_legendary/blackshop_legendary_magic_mushroom", LUA_MODIFIER_MOTION_NONE)

item_blackshop_legendary_magic_mushroom = class({})

function item_blackshop_legendary_magic_mushroom:OnSpellStart()
    local caster = self:GetCaster()
    local hItem = self
    local m = caster:FindModifierByName("modifier_blackshop_legendary_magic_mushroom") 
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        caster:AddNewModifier(caster, self, "modifier_blackshop_legendary_magic_mushroom", {}):SetStackCount(self:GetCurrentCharges())
    end

    caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
    hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

modifier_blackshop_legendary_magic_mushroom = class({})
function modifier_blackshop_legendary_magic_mushroom:IsHidden() 
    return false
end
function modifier_blackshop_legendary_magic_mushroom:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_blackshop_legendary_magic_mushroom:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local radius = 150
        
        GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), radius, false)
    end
end

function modifier_blackshop_legendary_magic_mushroom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function modifier_blackshop_legendary_magic_mushroom:GetModifierDamageOutgoing_Percentage()
    return 120 + 20 * self:GetStackCount()
end

function modifier_blackshop_legendary_magic_mushroom:GetModifierModelScale()
    return 70 + 15 * self:GetStackCount()
end

function modifier_blackshop_legendary_magic_mushroom:GetModifierMoveSpeedBonus_Percentage()
    return -3.5 - 0.5 * self:GetStackCount()
end


function modifier_blackshop_legendary_magic_mushroom:RemoveOnDeath()
    return false
end
