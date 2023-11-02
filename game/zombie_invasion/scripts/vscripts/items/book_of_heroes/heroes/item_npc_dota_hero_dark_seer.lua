LinkLuaModifier("modifier_dark_seer", "items/book_of_heroes/heroes/item_npc_dota_hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_dark_seer = class({})

function item_npc_dota_hero_dark_seer:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("dark_seer_buff_1") then 
          caster:AddAbility("dark_seer_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



dark_seer_buff_1 = class({})

function dark_seer_buff_1:GetIntrinsicModifierName()
    return "modifier_dark_seer"
end

 modifier_dark_seer = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

    }end,
})

function modifier_dark_seer:OnCreated()
        
end


function modifier_dark_seer:GetModifierSpellAmplify_Percentage()
    return self:GetCaster():GetIntellect() * (self:GetAbility():GetSpecialValueFor("int_pct") / 100)
end
