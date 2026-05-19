LinkLuaModifier("modifier_wisp", "items/book_of_heroes/heroes/item_npc_dota_hero_wisp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_aura", "items/book_of_heroes/heroes/item_npc_dota_hero_wisp", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_wisp = class({})

function item_npc_dota_hero_wisp:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("wisp_buff_1") then 
          caster:AddAbility("wisp_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end


wisp_buff_1 = class({})

function wisp_buff_1:GetIntrinsicModifierName()
    return "modifier_wisp_aura"
end

modifier_wisp_aura = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_wisp_aura:IsAura()
    return true
end

function modifier_wisp_aura:GetModifierAura()
    return "modifier_wisp"
end

function modifier_wisp_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_wisp_aura:GetAuraDuration()
    return 0.1
end

function modifier_wisp_aura:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_wisp_aura:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_wisp_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end


modifier_wisp = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_HEALTH_BONUS,
        }
    end,
})

function modifier_wisp:GetModifierHealthBonus()
        return self:GetCaster():GetHealth() * (self:GetAbility():GetSpecialValueFor("bonus_health_pct")  / 100)
end


