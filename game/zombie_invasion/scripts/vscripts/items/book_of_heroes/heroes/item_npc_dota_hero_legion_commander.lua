LinkLuaModifier("modifier_legion_aura_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_legion_commander", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_aura", "items/book_of_heroes/heroes/item_npc_dota_hero_legion_commander", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_legion_commander = class({})

function item_npc_dota_hero_legion_commander:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self
        if not caster:HasAbility("legion_buff_1") then 
		  caster:AddAbility("legion_buff_1"):SetLevel(1)
		  UTIL_Remove(hItem)
        end
end


if legion_buff_1 == nil then
    legion_buff_1 = class({})
end

function legion_buff_1:GetIntrinsicModifierName()
    return "modifier_legion_aura"
end

modifier_legion_aura = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_legion_aura:IsAura()
    return true
end

function modifier_legion_aura:GetModifierAura()
    return "modifier_legion_aura_buff"
end

function modifier_legion_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_legion_aura:GetAuraDuration()
    return 0.5
end

function modifier_legion_aura:GetAuraSearchTeam()  
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_legion_aura:GetAuraSearchType()  
        return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_legion_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end


modifier_legion_aura_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        }
    end,
})

function modifier_legion_aura_buff:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("atr_pct")
end
