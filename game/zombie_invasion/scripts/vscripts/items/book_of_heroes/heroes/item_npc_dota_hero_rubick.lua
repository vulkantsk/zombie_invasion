LinkLuaModifier("modifier_rubick", "items/book_of_heroes/heroes/item_npc_dota_hero_rubick", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_rubick = class({})

function item_npc_dota_hero_rubick:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self
        local hero = caster:GetUnitName()
        if not caster:HasAbility("rubick_buff_1") then 
          caster:AddAbility("rubick_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end


rubick_buff_1 = class({})

function rubick_buff_1:GetIntrinsicModifierName()
    return "modifier_rubick"
end
modifier_rubick = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})
