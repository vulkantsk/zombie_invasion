LinkLuaModifier("modifier_phantom_assassin_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_phantom_assassin = class({})

function item_npc_dota_hero_phantom_assassin:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("phantom_assassin_buff_1") then 
          caster:AddAbility("phantom_assassin_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



phantom_assassin_buff_1 = class({})

function phantom_assassin_buff_1:GetIntrinsicModifierName()
    return "modifier_phantom_assassin_buff"
end


modifier_phantom_assassin_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
})

function modifier_phantom_assassin_buff:IsHidden()
    return true
end

