LinkLuaModifier("modifier_dragon", "items/book_of_heroes/heroes/item_npc_dota_hero_dragon_knight", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_dragon_knight = class({})

function item_npc_dota_hero_dragon_knight:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("dragon_knight_buff_1") then 
          caster:AddAbility("dragon_knight_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end


dragon_knight_buff_1 = class({})

function dragon_knight_buff_1:GetIntrinsicModifierName()
    return "modifier_dragon"
end

 modifier_dragon = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

    }end,
})


function modifier_dragon:GetModifierBonusStats_Strength()
    return self:GetCaster():GetLevel() * (self:GetAbility():GetSpecialValueFor("str") / 100)
end
