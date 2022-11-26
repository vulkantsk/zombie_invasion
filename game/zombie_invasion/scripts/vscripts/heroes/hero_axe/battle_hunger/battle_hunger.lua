ability_battle_hunger = class({})

function ability_battle_hunger:OnAbilityPhaseStart()
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_battle_hunger_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

	return true
end

-- original Dota Imba
-- https://github.com/EarthSalamander42/dota_imba/blob/master/game/dota_addons/dota_imba_reborn/scripts/vscripts/components/abilities/heroes/hero_axe.lua
--

LinkLuaModifier('modifier_imba_battle_hunger_debuff_dot', 'heroes/hero_axe/battle_hunger/battle_hunger', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_imba_battle_hunger_buff_dot', 'heroes/hero_axe/battle_hunger/battle_hunger', LUA_MODIFIER_MOTION_NONE)
 
function ability_battle_hunger:CastFilterResultTarget(target, caster)
    --    print(self:GetCaster():FindAbilityByName("special_axe_battle_ally"):GetLevel())
      if self:GetCaster():FindAbilityByName("special_axe_battle_ally"):GetLevel() ~= 1 then 
        if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
            return UF_FAIL_CUSTOM
        end
      end
 
    return UF_SUCCESS   
end

function ability_battle_hunger:GetCustomCastErrorTarget(target, caster)
       if self:GetCaster():FindAbilityByName("special_axe_battle_ally"):GetLevel() ~= 1 then 
        if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
            return "#dota_hud_error_bad_target"
        end
 
       end
 
    return UF_SUCCESS   
end


function ability_battle_hunger:OnSpellStart()
	local caster                    =       self:GetCaster()
	local target                    =       self:GetCursorTarget()
	local ability                   =       self
  
 
	caster:EmitSound("axe_axe_ability_battlehunger_0"..RandomInt(1,3))
    if target:GetTeamNumber() ~= caster:GetTeamNumber() then
        if target:TriggerSpellAbsorb(ability) then
            return nil
        end
    end
    target:EmitSound("Hero_Axe.Battle_Hunger")

	local duration = self:GetSpecialValueFor("duration") * (1 - self:GetCursorTarget():GetStatusResistance())

    if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
         self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, 'modifier_imba_battle_hunger_debuff_dot', {
        duration = duration,
    })
    else 
        self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, 'modifier_imba_battle_hunger_buff_dot', {
        duration = self:GetSpecialValueFor("duration"),
    })
    end
end
 

modifier_imba_battle_hunger_debuff_dot = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    DeclareFunctions        = function(self) return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    } end,
     

    GetEffectName           = function(self) return 'particles/units/heroes/hero_axe/axe_battle_hunger.vpcf' end,
    GetEffectAttachType     = function(self) return PATTACH_OVERHEAD_FOLLOW end,
})

function modifier_imba_battle_hunger_debuff_dot:OnRefresh()
    self:OnCreated()
end

function modifier_imba_battle_hunger_debuff_dot:OnCreated()
    self.damage_reduction = self:GetAbility():GetSpecialValueFor('damage_reduction')
    self.damage = self:GetAbility():GetSpecialValueFor('damage_per_second')

    self:StartIntervalThink(1)
end

function modifier_imba_battle_hunger_debuff_dot:GetModifierDamageOutgoing_Percentage( params )
    return -self.damage_reduction
end
 

function modifier_imba_battle_hunger_debuff_dot:OnIntervalThink()
    if IsClient() then return end

    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
    })
end

modifier_imba_battle_hunger_buff_dot = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    DeclareFunctions        = function(self) return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    } end,
 

    GetEffectName           = function(self) return 'particles/units/heroes/hero_axe/axe_battle_hunger.vpcf' end,
    GetEffectAttachType     = function(self) return PATTACH_OVERHEAD_FOLLOW end,
})

function modifier_imba_battle_hunger_buff_dot:OnRefresh()
    self:OnCreated()
end

function modifier_imba_battle_hunger_buff_dot:OnCreated()
    self.damage_reduction = self:GetAbility():GetSpecialValueFor('damage_reduction')
    self.damage = self:GetAbility():GetSpecialValueFor('damage_per_second')

    self:StartIntervalThink(1)
end

function modifier_imba_battle_hunger_buff_dot:GetModifierDamageOutgoing_Percentage( params )
    return self.damage_reduction
end
 

function modifier_imba_battle_hunger_buff_dot:OnIntervalThink()
    if IsClient() then return end

    self:GetParent():Heal(self.damage,self:GetCaster())
 SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.damage, nil)
end