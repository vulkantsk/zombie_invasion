LinkLuaModifier("modifier_troll_warlord", "items/book_of_heroes/heroes/item_npc_dota_hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_troll_warlord = class({})

function item_npc_dota_hero_troll_warlord:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("troll_warlord_buff_1") then 
          caster:AddAbility("troll_warlord_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



troll_warlord_buff_1 = class({})

function troll_warlord_buff_1:GetIntrinsicModifierName()
    return "modifier_troll_warlord"
end

 modifier_troll_warlord = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

    }end,
})


function modifier_troll_warlord:GetModifierAttackSpeedBonus_Constant()
    return self:GetCaster():GetAgility() * (self:GetAbility():GetSpecialValueFor("agi_pct") / 100)
end
