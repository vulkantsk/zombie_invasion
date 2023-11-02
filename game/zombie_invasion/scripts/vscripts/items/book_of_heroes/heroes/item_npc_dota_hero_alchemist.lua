LinkLuaModifier("modifier_alchemist_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_alchemist", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_alchemist= class({})

function item_npc_dota_hero_alchemist:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("alchemist_buff_1") then 
          caster:AddAbility("alchemist_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



alchemist_buff_1 = class({})

function alchemist_buff_1:GetIntrinsicModifierName()
    return "modifier_alchemist_buff"
end

modifier_alchemist_buff = {}

function modifier_alchemist_buff:IsHidden()
    return true
end

function modifier_alchemist_buff:IsPurgable()
    return false
end

function modifier_alchemist_buff:RemoveOnDeath()
    return false
end

function modifier_alchemist_buff:OnCreated()
    self.spell_gold = self:GetAbility():GetSpecialValueFor("spell_gold")/100

    self:OnIntervalThink()
     self:StartIntervalThink(1.0)
end

function modifier_alchemist_buff:OnRefresh( kv )
    -- references
    self:OnCreated()
 
 end

function modifier_alchemist_buff:OnIntervalThink()
    local caster = self:GetCaster()
    local gold = caster:GetGold()

     self:SetStackCount(gold)
end

function modifier_alchemist_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, 
    }
end

function modifier_alchemist_buff:GetModifierSpellAmplify_Percentage()
    return self:GetStackCount() * self.spell_gold
end