LinkLuaModifier("modifier_drow", "items/book_of_heroes/heroes/item_npc_dota_hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_drow_ranger = class({})

function item_npc_dota_hero_drow_ranger:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("drow_ranger_buff_1") then 
          caster:AddAbility("drow_ranger_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



drow_ranger_buff_1 = class({})

function drow_ranger_buff_1:GetIntrinsicModifierName()
    return "modifier_drow"
end

 modifier_drow = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,

    }end,
})


function modifier_drow:GetModifierBonusStats_Agility()
    return self:GetCaster():GetLevel() * (self:GetAbility():GetSpecialValueFor("agi") / 100)
end
