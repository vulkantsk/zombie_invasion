LinkLuaModifier("modifier_enigma", "items/book_of_heroes/heroes/item_npc_dota_hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_enigma_stats", "heroes/book_of_heroes/heroes/item_npc_dota_hero_enigma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_debuff", "heroes/book_of_heroes/heroes/item_npc_dota_hero_enigma", LUA_MODIFIER_MOTION_NONE )
item_npc_dota_hero_enigma = class({})

function item_npc_dota_hero_enigma:OnSpellStart()
		local caster = self:GetCaster()
		local hItem = self

        if not caster:HasAbility("enigma_buff_1") then 
          caster:AddAbility("enigma_buff_1"):SetLevel(1)
          caster:RemoveItem(hItem)
        end
end



enigma_buff_1 = class({})

function enigma_buff_1:GetIntrinsicModifierName()
    return "modifier_enigma"
end


modifier_enigma = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetEffectName           = function(self) return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions        = function(self) return 
            {
            MODIFIER_EVENT_ON_DEATH,
            MODIFIER_PROPERTY_TOOLTIP,
            MODIFIER_EVENT_ON_ATTACK_LANDED,
            } end,
})


function modifier_enigma:OnCreated( data )
    kill = 0
end

function modifier_enigma:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

     if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("enigma_debuff")

        target:AddNewModifier(caster, ability, "modifier_enigma_debuff", {duration = duration})
     end
end

function modifier_enigma:OnDeath( data )
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local damage = ability:GetSpecialValueFor( "eidolon_dmg_tooltip" ) + (self:GetCaster():GetIntellect() + self:GetCaster():GetAgility())
    local health = ability:GetSpecialValueFor( "eidolon_hp_tooltip" ) + self:GetCaster():GetStrength()
    local attack = ability:GetSpecialValueFor( "eidolon_attack_tooltip" ) + self:GetCaster():GetAttackSpeed()
    local killer = data.attacker
    local killed_unit = data.unit


    if killed_unit:HasModifier("modifier_enigma_debuff") then
        kill = kill + 1
        if kill == 10 then
            local unit = CreateUnitByName( "npc_classic_eidolon_strong", pos, true, caster, caster, caster:GetTeamNumber() )
            unit:AddNewModifier( caster, self, "modifier_enigma_stats", {} )
            unit:SetOwner( caster )
            unit:SetControllableByPlayer( caster:GetPlayerID(), true )
            FindClearSpaceForUnit( unit, pos, true )
            unit:SetMaximumAttackSpeed(health)
            unit:SetBaseMaxHealth(health)
            unit:SetBaseDamageMin(damage)    
            unit:SetBaseDamageMax(damage)    
            kill = kill - 10
        end
    end
end

modifier_enigma_debuff = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions  = function(self) return {

    }end,
})


function modifier_enigma_debuff:OnCreated(data)
    local ability = self:GetAbility()

end

modifier_enigma_stats = {}

function modifier_enigma_stats:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_enigma_stats:GetModifierExtraHealthBonus()
    return self:GetCaster():GetStrength() * 2
end

function modifier_enigma_stats:GetModifierAttackSpeedBonus_Constant()
    return self:GetCaster():GetAgility() * 2
end

function modifier_enigma_stats:GetModifierPreAttack_BonusDamage()
    return self:GetCaster():GetIntellect() * 2
end
 