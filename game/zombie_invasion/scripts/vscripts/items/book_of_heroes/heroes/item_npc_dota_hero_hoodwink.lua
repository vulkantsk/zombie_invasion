LinkLuaModifier("modifier_hoodwink", "items/book_of_heroes/heroes/item_npc_dota_hero_hoodwink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hoodwink_acorn", "items/book_of_heroes/heroes/item_npc_dota_hero_hoodwink", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_hoodwink = class({})

function item_npc_dota_hero_hoodwink:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self
        if not caster:HasAbility("hoodwink_buff_1") then 
		  caster:AddAbility("hoodwink_buff_1"):SetLevel(1)
		  caster:RemoveItem(hItem)
        end
end


if hoodwink_buff_1== nil then
    hoodwink_buff_1 = class({})
end

function hoodwink_buff_1:GetIntrinsicModifierName()
    return "modifier_hoodwink"
end

modifier_hoodwink = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_EVENT_ON_ATTACK,
    }end,
})

function modifier_hoodwink:OnCreated( data )
    self.ability = self:GetAbility()
    self.acorn_damage = self:GetAbility():GetSpecialValueFor("acorn_damage")
    self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
end

function modifier_hoodwink:OnRefresh()
    self:OnCreated()
end

function modifier_hoodwink:OnAttack( data )
        local caster = self:GetCaster()
        local target = data.target
        local attacker = data.attacker
     if attacker == caster then
        local ability = self:GetAbility()
        if  self:GetAbility():IsCooldownReady() then
            self:GetAbility():StartCooldown(self.cooldown)
        end
     end
end

function modifier_hoodwink:GetModifierPreAttack_BonusDamage()
    if self.ability:IsCooldownReady() then return self.acorn_damage + (self:GetParent():GetAttackDamage() * (self:GetAbility():GetSpecialValueFor("acorn_pct") / 100))
    else
        return 
    end
    
end

function modifier_hoodwink:GetModifierProjectileName()
    if self.ability:IsCooldownReady() then return "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf"

    else
        return 
    end
end