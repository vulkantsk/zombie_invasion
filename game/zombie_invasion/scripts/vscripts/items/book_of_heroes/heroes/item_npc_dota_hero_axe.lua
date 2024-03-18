LinkLuaModifier("modifier_axe", "items/book_of_heroes/heroes/item_npc_dota_hero_axe", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_axe = class({})

function item_npc_dota_hero_axe:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("axe_buff_1") then 
          caster:AddAbility("axe_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



axe_buff_1 = class({})

function axe_buff_1:GetIntrinsicModifierName()
    return "modifier_axe"
end

function axe_buff_1:RemoveOnDeath()
    return true
end



modifier_axe = class({})

function modifier_axe:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,

    }
    return funcs
end

function modifier_axe:IsHidden()
    return true
end

function modifier_axe:IsPurgable()
    return false
end 

function modifier_axe:RemoveOnDeath()
    return true
end

 

function modifier_axe:OnIntervalThink()
    local counter =  100 - ( self:GetCaster():GetHealth() / ( self:GetCaster():GetMaxHealth()/100 ) )
            self:SetStackCount( counter )
end

function modifier_axe:OnCreated(kv)
    self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
    self.strength = self:GetAbility():GetSpecialValueFor( "strength" )    
    self:StartIntervalThink(0.1)
end

function modifier_axe:GetModifierPhysicalArmorBonus()
    return self:GetCaster():GetStrength()  *  self.armor
 
end

function modifier_axe:GetModifierExtraStrengthBonus()
    return self:GetStackCount()  *  self.strength
 
end