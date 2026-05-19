LinkLuaModifier( "modifier_ability_phantom_assassin_stifling_dagger_debuff", "heroes/hero_phantoma_assasin/stifling_dagger/stifling_dagger" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_phantom_assassin_stifling_dagger_target_debuff", "heroes/hero_phantoma_assasin/stifling_dagger/stifling_dagger" ,LUA_MODIFIER_MOTION_NONE )

if ability_phantom_assassin_stifling_dagger == nil then
    ability_phantom_assassin_stifling_dagger = class({})
end

function ability_phantom_assassin_stifling_dagger:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf",
	}, {
		"Hero_PhantomAssassin.Dagger.Cast",
		"Hero_PhantomAssassin.Dagger.Target",
	}, context)
end


--------------------------------------------------------------------------------

function ability_phantom_assassin_stifling_dagger:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_assassin_stifling_dagger_triple")
    local info = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
        bDodgeable = true,
        bProvidesVision = true,
        iMoveSpeed = self:GetSpecialValueFor("dagger_speed"),
        iVisionRadius = 450,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }

    ProjectileManager:CreateTrackingProjectile( info )
    EmitSoundOn("Hero_PhantomAssassin.Dagger.Cast", caster)


    if talent:GetLevel() == 1  then
        local units = FindUnitsInRadius(
            caster:GetTeam(),
            caster:GetAbsOrigin(),
            nil,
            self:GetCastRange(caster:GetAbsOrigin(),caster) * 2,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            self:GetAbilityTargetFlags() + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
            FIND_CLOSEST,
            false
        )
 
     for k,unit in pairs(units) do 
        if unit == target then 
            table.remove(units, k)
 
        else
 
        end
     end
      for i=1, 2 do 

      local random_unit = units[ RandomInt( 1, #units ) ] 

          for k,unit in pairs(units) do 
            if unit == random_unit then 
                table.remove(units,k)
            else 

            end 
          end
 
      local dag_units = {
        Target = random_unit,
        Source = caster,
        Ability = self,
        EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
        bDodgeable = true,
        bProvidesVision = true,
        iMoveSpeed = self:GetSpecialValueFor("dagger_speed"),
        iVisionRadius = 450,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }
    
    if random_unit then 
        ProjectileManager:CreateTrackingProjectile( dag_units )
    end
    end
    end
 
end

function ability_phantom_assassin_stifling_dagger:OnProjectileHit(Target, Location)
       local spell = self:GetCaster():FindAbilityByName("ability_phantom_assassin_stifling_dagger")
  
    if Target ~= nil and not Target:IsInvulnerable() then

        if Target:TriggerSpellAbsorb(self) then return end

        EmitSoundOn("Hero_PhantomAssassin.Dagger.Target", Target)
        local oldForward =  self:GetCaster():GetForwardVector()
        local pos = self:GetCaster():GetAbsOrigin()
        local point = Target:GetAbsOrigin() + (self:GetCaster():GetAbsOrigin() - Target:GetAbsOrigin()):Normalized() * 100
        local forward = (Target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_phantom_assassin_stifling_dagger_debuff", {})

        if not Target:IsMagicImmune() then
            local duration = spell:GetSpecialValueFor("duration")
            Target:AddNewModifier(self:GetCaster(), self, "modifier_ability_phantom_assassin_stifling_dagger_target_debuff", {Duration=duration})
        end
        self:GetCaster():SetForwardVector(forward)
        self:GetCaster():SetAbsOrigin(point)
        self:GetCaster():PerformAttack(Target, true, true, true, false, false, false, true)
        self:GetCaster():SetAbsOrigin(pos)
        self:GetCaster():SetForwardVector(oldForward)
        self:GetCaster():RemoveModifierByName("modifier_ability_phantom_assassin_stifling_dagger_debuff")
        AddFOWViewer(self:GetCaster():GetTeamNumber(), Target:GetAbsOrigin(), 450, 3.34, false)

        if self:GetCaster():HasAbility("ability_phantom_assassin_togle_knife") then
        local spell_2 = self:GetCaster():FindAbilityByName("ability_phantom_assassin_togle_knife")
        local chance = spell_2:GetSpecialValueFor("chanche_dager")
        local int = spell_2:GetSpecialValueFor("interval")

        local random_knife = RandomInt(1,100)
        
        if random_knife <= chance and Target:IsAlive() then 

            local dager_unit_2 = {               
            Target = Target,
            Source = self:GetCaster(),
            Ability = spell,
            EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
            bDodgeable = true,
            bProvidesVision = true,
            iMoveSpeed = spell:GetSpecialValueFor("dagger_speed"),
            iVisionRadius = 450,
            iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
           }    

            Timers:CreateTimer(int, function()  
                 if self:GetCaster():HasAbility("ability_phantom_assassin_togle_knife") and Target:IsAlive() then 
                     ProjectileManager:CreateTrackingProjectile( dager_unit_2 )
                 end
            end)

        end

        end
   
    end
    return true
end

--------------------------------------------------------------------------------


modifier_ability_phantom_assassin_stifling_dagger_debuff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
            MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_ability_phantom_assassin_stifling_dagger_debuff:OnCreated()
    local spell = self:GetCaster():FindAbilityByName("ability_phantom_assassin_stifling_dagger")
    self.damage_reduce = spell:GetSpecialValueFor("attack_factor")
    self.base_damage = spell:GetSpecialValueFor("base_damage")
end

function modifier_ability_phantom_assassin_stifling_dagger_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_ability_phantom_assassin_stifling_dagger_debuff:GetModifierDamageOutgoing_Percentage() return self.damage_reduce end
function modifier_ability_phantom_assassin_stifling_dagger_debuff:GetModifierProcAttack_BonusDamage_Physical() return self.base_damage end


--------------------------------------------------------------------------------


modifier_ability_phantom_assassin_stifling_dagger_target_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
        }
    end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})


--------------------------------------------------------------------------------

function modifier_ability_phantom_assassin_stifling_dagger_target_debuff:OnCreated()
    local spell = self:GetCaster():FindAbilityByName("ability_phantom_assassin_stifling_dagger")
    self.move_slow = spell:GetSpecialValueFor("move_slow")
end

function modifier_ability_phantom_assassin_stifling_dagger_target_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_ability_phantom_assassin_stifling_dagger_target_debuff:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end