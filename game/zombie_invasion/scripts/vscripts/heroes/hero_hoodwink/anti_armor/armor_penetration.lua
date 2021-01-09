LinkLuaModifier("modifier_hoodwink_anti_armor", "heroes/hero_hoodwink/anti_armor/armor_penetration", LUA_MODIFIER_MOTION_NONE)


hoodwink_anti_armor = class({})

function hoodwink_anti_armor:GetIntrinsicModifierName()
    return "modifier_hoodwink_anti_armor"
end

modifier_hoodwink_anti_armor = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {           
            MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,
})

function modifier_hoodwink_anti_armor:OnAttackLanded( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.target
        local Attacker = params.attacker
        local Ability = params.inflictor
        local flDamage = params.original_damage
        

        if Attacker ~= nil and Attacker == parent and Target ~= nil and not Target:IsBuilding() and Ability == nil then
            local ability = self:GetAbility()
--            local pure_dmg_pct = ability:GetSpecialValueFor("pure_dmg_pct")
            local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
            if RollPercentage(trigger_chance) then
                local damage =  flDamage * 100 / 100 
                DealDamage(Attacker, Target, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATIONA, ability)                    
            end

        end
    end
    return 0
end