LinkLuaModifier("modifier_item_desolator_custom", "items/carry/item_desolator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_desolator_custom_debuff", "items/carry/item_desolator", LUA_MODIFIER_MOTION_NONE)

item_desolator_1 = class({})
item_desolator_2_custom = class({})
item_desolator_3_custom = class({})


function item_desolator_1:GetIntrinsicModifierName()
    return "modifier_item_desolator_custom"
end


function item_desolator_2_custom:GetIntrinsicModifierName()
    return "modifier_item_desolator_custom"
end

function item_desolator_3_custom:GetIntrinsicModifierName()
    return "modifier_item_desolator_custom"
end
 
 

modifier_item_desolator_custom = class({
    IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
    }end,
})

function modifier_item_desolator_custom:GetModifierProjectileName()
    return "particles/items_fx/desolator_projectile.vpcf"
end

function modifier_item_desolator_custom:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage") +  self:GetAbility():GetCurrentCharges()
end
function modifier_item_desolator_custom:GetModifierExtraHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health") +  self:GetAbility():GetCurrentCharges()
end


function modifier_item_desolator_custom:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("corruption_duration")

        target:AddNewModifier(caster, ability, "modifier_item_desolator_custom_debuff", {duration = duration})
    end
end

function modifier_item_desolator_custom:OnDeath(data)
    if not IsServer() then
        return
    end

    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end

    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end

    local killer = data.attacker
    local killed_unit = data.unit

    local chance = ability:GetSpecialValueFor("chance_to_stack")
    local max_charge = ability:GetSpecialValueFor("max_damage")
    local charges = ability:GetSpecialValueFor("bonus_damage_per_kill") + ability:GetCurrentCharges()
    if killer == parent and killed_unit and killed_unit:HasModifier("modifier_item_desolator_custom_debuff") and RollPercentage(chance) then
        ability:SetCurrentCharges(math.min(charges, max_charge))
        if parent.CalculateStatBonus then
            parent:CalculateStatBonus(true)
        end
    end
end

modifier_item_desolator_custom_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_item_desolator_custom_debuff:OnCreated(data)
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("corruption_armor")
end


function modifier_item_desolator_custom_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_debuff 
end
