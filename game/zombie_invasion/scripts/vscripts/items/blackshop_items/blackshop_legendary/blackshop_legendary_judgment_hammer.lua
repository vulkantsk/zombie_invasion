LinkLuaModifier( "modifier_blackshop_legendary_judgment_hammer", "items/blackshop_items/blackshop_legendary/blackshop_legendary_judgment_hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blackshop_legendary_judgment_hammer_debuff", "items/blackshop_items/blackshop_legendary/blackshop_legendary_judgment_hammer", LUA_MODIFIER_MOTION_NONE )
item_blackshop_legendary_judgment_hammer = class({})
function item_blackshop_legendary_judgment_hammer:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_legendary_judgment_hammer")
     if not self.caster:HasAbility("blackshop_legendary_judgment_hammer") then 
        self.caster:AddAbility("blackshop_legendary_judgment_hammer"):SetLevel(1)
        self.caster:EmitSound("Item.TomeOfKnowledge")
        if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
            UTIL_Remove(hItem)
            return
        end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
    end
end

blackshop_legendary_judgment_hammer = class({})

function blackshop_legendary_judgment_hammer:GetIntrinsicModifierName()
    return "modifier_blackshop_legendary_judgment_hammer"
end




modifier_blackshop_legendary_judgment_hammer = class({
    IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_blackshop_legendary_judgment_hammer:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("duration")

        target:AddNewModifier(caster, ability, "modifier_blackshop_legendary_judgment_hammer_debuff", {duration = duration})
    end
end

 modifier_blackshop_legendary_judgment_hammer_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_blackshop_legendary_judgment_hammer_debuff:OnCreated( keys )
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("armor_debuff")
end


function modifier_blackshop_legendary_judgment_hammer_debuff:GetModifierPhysicalArmorBonus()
    return -self.armor_debuff
end