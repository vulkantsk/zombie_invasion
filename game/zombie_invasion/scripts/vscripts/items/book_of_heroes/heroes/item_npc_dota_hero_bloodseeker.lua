LinkLuaModifier("modifier_blood", "items/book_of_heroes/heroes/item_npc_dota_hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_bloodseeker = class({})

function item_npc_dota_hero_bloodseeker:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("blood_buff_1") then 
          caster:AddAbility("blood_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



blood_buff_1 = class({})

function blood_buff_1:GetIntrinsicModifierName()
    return "modifier_blood"
end

modifier_blood = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})


