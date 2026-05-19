LinkLuaModifier("modifier_tide_damage", "items/book_of_heroes/heroes/item_npc_dota_hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
item_npc_dota_hero_tidehunter = class({})

function item_npc_dota_hero_tidehunter:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("tide_buff_1") then 
          caster:AddAbility("tide_buff_1"):SetLevel(1)
          UTIL_Remove(hItem)
        end
end


tide_buff_1 = class({})

function tide_buff_1:GetIntrinsicModifierName()
    return "modifier_tide_damage"
end

modifier_tide_damage = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
--  GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions        = function(self) return 
        {MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end,
})

function modifier_tide_damage:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("damage_per_stack")
end

if IsClient() then
    return
end

function modifier_tide_damage:OnCreated()

end

function modifier_tide_damage:OnTakeDamage( params )
    local hUnit = params.unit
    local hAttacker = params.attacker
    local parent = self:GetParent()
    if hAttacker == nil or hAttacker:IsBuilding() then
        return 0
    end
    
    if not parent.damage_cap then
        parent.damage_cap = 0
    end
    
    if hUnit == parent then
        local damage = params.damage
        local ability = self:GetAbility()
        local dmg_proc = ability:GetSpecialValueFor("dmg_proc")
        local parent_maxhealth = parent:GetMaxHealth()
        if damage >= parent_maxhealth then
            damage = parent_maxhealth
        end

        parent.damage_cap = parent.damage_cap + damage
        local stacks = math.floor(parent.damage_cap/dmg_proc)
        if stacks > 0 then 
            parent.damage_cap = parent.damage_cap - stacks*dmg_proc
            local modifier = "modifier_tide_damage"
            local currentStacks = parent:GetModifierStackCount(modifier, ability)
            
            parent:SetModifierStackCount(modifier, ability, (currentStacks + stacks))
            parent:AddNewModifier(parent,ability, "modifier_phased", {duration = 0.01})
--          self:SetStackCount(self:GetStackCount()+stacks)
        end
            
    end
end
