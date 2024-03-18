LinkLuaModifier("modifier_sniper_debuff", "items/book_of_heroes/heroes/item_npc_dota_hero_sniper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sniper", "items/book_of_heroes/heroes/item_npc_dota_hero_sniper", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_sniper = class({})

function item_npc_dota_hero_sniper:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("sniper_buff_1") then 
          caster:AddAbility("sniper_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end



sniper_buff_1 = class({})

function sniper_buff_1:GetIntrinsicModifierName()
    return "modifier_sniper"
end


modifier_sniper = class({
	IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_sniper:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("corruption_duration")

        target:AddNewModifier(caster, ability, "modifier_sniper_debuff", {duration = duration})
    end
end

 modifier_sniper_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_sniper_debuff:OnCreated(data)
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("armor_debuff")
end


function modifier_sniper_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_debuff - self:GetCaster():GetAgility() * (self:GetAbility():GetSpecialValueFor("agi_pct") / 100)
end
