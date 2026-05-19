LinkLuaModifier("modifier_silencer", "items/book_of_heroes/heroes/item_npc_dota_hero_silencer", LUA_MODIFIER_MOTION_NONE)

item_npc_dota_hero_silencer = class({})

function item_npc_dota_hero_silencer:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("silencer_buff_1") then 
          caster:AddAbility("silencer_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end


silencer_buff_1 = class({})

function silencer_buff_1:GetIntrinsicModifierName()
    return "modifier_silencer"
end

modifier_silencer = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})


function modifier_silencer:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

    }
    return funcs
end

function modifier_silencer:OnCreated( kv )
    self:StartIntervalThink(0.2)
end


function modifier_silencer:OnIntervalThink()    
    self.int = self:GetAbility():GetSpecialValueFor("int") * self:GetParent():GetLevel()
    
end

function modifier_silencer:GetModifierBonusStats_Intellect()
    return self.int
end