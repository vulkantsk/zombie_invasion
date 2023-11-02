LinkLuaModifier("modifier_winter_wyvern", "items/book_of_heroes/heroes/item_npc_dota_hero_winter_wyvern", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_winter_wyvern = class({})

function item_npc_dota_hero_winter_wyvern:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("winter_wyvern_buff_1") then 
          caster:AddAbility("winter_wyvern_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



winter_wyvern_buff_1 = class({})

function winter_wyvern_buff_1:GetIntrinsicModifierName()
    return "modifier_winter_wyvern"
end

 modifier_winter_wyvern = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

    }end,
})


function modifier_winter_wyvern:GetModifierBonusStats_Intellect()
    return self:GetCaster():GetMana() * (self:GetAbility():GetSpecialValueFor("mana_pct") / 100)
end
