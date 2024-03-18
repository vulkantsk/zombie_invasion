LinkLuaModifier("modifier_medusa", "items/book_of_heroes/heroes/item_npc_dota_hero_medusa", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_medusa = class({})

function item_npc_dota_hero_medusa:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("medusa_buff_1") then 
          caster:AddAbility("medusa_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



medusa_buff_1 = class({})

function medusa_buff_1:GetIntrinsicModifierName()
    return "modifier_medusa"
end

 modifier_medusa = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_MANA_BONUS,

    }end,
})


function modifier_medusa:GetModifierManaBonus()
    return self:GetCaster():GetAgility() * (self:GetAbility():GetSpecialValueFor("agi_pct") / 100)
end
