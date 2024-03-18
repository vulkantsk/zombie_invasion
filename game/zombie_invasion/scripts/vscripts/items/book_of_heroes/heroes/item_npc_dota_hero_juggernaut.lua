LinkLuaModifier("modifier_juggernaut_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_juggernaut = class({})

function item_npc_dota_hero_juggernaut:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("juggernaut_buff") then 
          caster:AddAbility("juggernaut_buff"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



juggernaut_buff = class({})

function juggernaut_buff:GetIntrinsicModifierName()
    return "modifier_juggernaut_buff"
end


modifier_juggernaut_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
})

function modifier_juggernaut_buff:OnCreated()
    self:StartIntervalThink(60)
end
 
function modifier_juggernaut_buff:OnIntervalThink()
        self:IncrementStackCount()
end

function modifier_juggernaut_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_juggernaut_buff:GetModifierBonusStats_Agility()
    return self:GetStackCount() * 10
end
