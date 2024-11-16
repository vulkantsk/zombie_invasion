LinkLuaModifier( "modifier_blackshop_legendary_judgment_hammer", "items/blackshop_items/blackshop_legendary/blackshop_legendary_judgment_hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blackshop_legendary_judgment_hammer_debuff", "items/blackshop_items/blackshop_legendary/blackshop_legendary_judgment_hammer", LUA_MODIFIER_MOTION_NONE )

item_blackshop_legendary_judgment_hammer = class({})

function item_blackshop_legendary_judgment_hammer:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    
    local modifier = self.caster:FindModifierByName("modifier_blackshop_legendary_judgment_hammer")
    if modifier then
        modifier:IncrementStackCount()
    else
        self.caster:AddNewModifier(self.caster, self, "modifier_blackshop_legendary_judgment_hammer", {}):SetStackCount(1)
    end
    
    self.caster:EmitSound("Item.TomeOfKnowledge")
    
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
    
    hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end

modifier_blackshop_legendary_judgment_hammer = class({
    IsHidden = function(self) return true end,
    GetAttributes = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    RemoveOnDeath = function(self) return false end,
    DeclareFunctions = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})

function modifier_blackshop_legendary_judgment_hammer:OnAttackLanded(data)
    local parent = self:GetParent()
    local target = data.target
    local attacker = data.attacker

    if attacker == parent then
        local duration = 20
        local parent_stacks = parent:FindModifierByName("modifier_blackshop_legendary_judgment_hammer"):GetStackCount()

        local modifier = target:FindModifierByName("modifier_blackshop_legendary_judgment_hammer_debuff")
        
            target:AddNewModifier(parent, self:GetAbility(), "modifier_blackshop_legendary_judgment_hammer_debuff", {
                duration = duration,
                parent_stacks = parent_stacks
            }):SetStackCount(parent_stacks)
  
    end
end

modifier_blackshop_legendary_judgment_hammer_debuff = class({
    IsHidden = function(self) return false end,
    DeclareFunctions = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }end,
})

function modifier_blackshop_legendary_judgment_hammer_debuff:OnCreated(keys)
    self.armor_debuff = 20
    if IsServer() then
        self.parent_stacks = keys.parent_stacks or 0
    end
end

function modifier_blackshop_legendary_judgment_hammer_debuff:GetModifierPhysicalArmorBonus()
    return -(self.armor_debuff + 5 * self:GetStackCount())
end