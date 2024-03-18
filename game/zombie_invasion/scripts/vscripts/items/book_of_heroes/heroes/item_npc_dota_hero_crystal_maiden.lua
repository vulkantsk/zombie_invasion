LinkLuaModifier("modifier_crystal_aura_buff", "items/book_of_heroes/heroes/item_npc_dota_hero_crystal_maiden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystal_aura", "items/book_of_heroes/heroes/item_npc_dota_hero_crystal_maiden", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_crystal_maiden = class({})

function item_npc_dota_hero_crystal_maiden:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self
        if not caster:HasAbility("crystal_maiden_buff_1") then 
		  caster:AddAbility("crystal_maiden_buff_1"):SetLevel(1)
		  UTIL_Remove(hItem)
        end
end


if crystal_maiden_buff_1 == nil then
    crystal_maiden_buff_1 = class({})
end

function crystal_maiden_buff_1:GetIntrinsicModifierName()
    return "modifier_crystal_aura"
end

modifier_crystal_aura = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_crystal_aura:IsAura()
    return true
end

function modifier_crystal_aura:GetModifierAura()
    return "modifier_crystal_aura_buff"
end

function modifier_crystal_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_crystal_aura:GetAuraDuration()
    return 0.5
end

function modifier_crystal_aura:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_crystal_aura:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_crystal_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end


modifier_crystal_aura_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        }
    end,
})

function modifier_crystal_aura_buff:GetModifierSpellAmplify_Percentage()
        return self:GetAbility():GetSpecialValueFor("bonus_spell_amp") * (self:GetCaster():GetIntellect() * (self:GetAbility():GetSpecialValueFor("spell_amp_pct") / 100)) 
end

function modifier_crystal_aura_buff:GetModifierIncomingDamage_Percentage()
        return self:GetAbility():GetSpecialValueFor("incom_cm")
end

