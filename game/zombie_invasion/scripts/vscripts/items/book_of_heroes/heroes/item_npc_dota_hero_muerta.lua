LinkLuaModifier("modifier_muerta_debuff", "items/book_of_heroes/heroes/item_npc_dota_hero_muerta", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta", "items/book_of_heroes/heroes/item_npc_dota_hero_muerta", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_muerta = class({})

function item_npc_dota_hero_muerta:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("muerta_buff_1") then 
          caster:AddAbility("muerta_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end


muerta_buff_1 = class({})

function muerta_buff_1:GetIntrinsicModifierName()
    return "modifier_muerta"
end


modifier_muerta = class({
	IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_muerta:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("corruption_duration")

        target:AddNewModifier(caster, ability, "modifier_muerta_debuff", {duration = duration})
    end
end

 modifier_muerta_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_muerta_debuff:OnCreated( keys )
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("armor_debuff")
end


function modifier_muerta_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_debuff 
end
