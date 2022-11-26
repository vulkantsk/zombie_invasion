LinkLuaModifier( "modifier_ability_sniper_assassinate", "heroes/hero_sniper/assassinate/assassinate" ,LUA_MODIFIER_MOTION_NONE )

if ability_sniper_assassinate == nil then
    ability_sniper_assassinate = class({})
end

--------------------------------------------------------------------------------
function ability_sniper_assassinate:GetAOERadius()
 
        return self:GetSpecialValueFor( "splash_radius" )
     

     
end
 

function ability_sniper_assassinate:OnAbilityPhaseStart()
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()


    local cast_response = {"sniper_snip_ability_assass_02", "sniper_snip_ability_assass_06", "sniper_snip_ability_assass_07", "sniper_snip_ability_assass_08"}

 
    local search = self:GetSpecialValueFor("splash_radius")

    -- find targets
    local targets = {}
 
        targets = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            search, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
 

    for _,enemy in pairs(targets) do
        -- delay
        enemy:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_ability_sniper_assassinate", -- modifier name
            { duration=4 } -- kv
        )

        -- effects
 
    end

 
    EmitSoundOn(cast_response[math.random(1, #cast_response)], self:GetCaster())

    EmitSoundOnClient("Ability.AssassinateLoad", self:GetCaster():GetPlayerOwner())
    return true
end

function ability_sniper_assassinate:OnAbilityPhaseInterrupted()
        local target = self:GetCursorTarget()
            local search = self:GetSpecialValueFor("splash_radius")
    local caster = self:GetCaster()
        local targets = {}
 
        targets = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            -1, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
 

    for _,enemy in pairs(targets) do
        -- delay
        if enemy:HasModifier("modifier_ability_sniper_assassinate") then 
            enemy:RemoveModifierByName("modifier_ability_sniper_assassinate")
        end 
    end
 
end

function ability_sniper_assassinate:OnSpellStart()
        local target = self:GetCursorTarget()
            local search = self:GetSpecialValueFor("splash_radius")
    local caster = self:GetCaster()
        local targets = {}
 
        targets = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            -1, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
 

    for _,enemy in pairs(targets) do
        -- delay
                if enemy:HasModifier("modifier_ability_sniper_assassinate") then 
   
    local info = {
        Target = enemy,
        Source = caster,
        Ability = self,
        EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
        bDodgeable = true,
        bProvidesVision = false,
        iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }
        ProjectileManager:CreateTrackingProjectile( info )
        EmitSoundOn("Hero_Sniper.AssassinateProjectile", enemy)

        end
    end

 
 

    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ability.Assassinate", caster)
 
end

function ability_sniper_assassinate:OnProjectileHit(Target, Location)
    if Target ~= nil and not Target:IsInvulnerable() then
    local caster = self:GetCaster()
        Target:RemoveModifierByName("modifier_ability_sniper_assassinate")

        if Target:TriggerSpellAbsorb(self) then return end

        EmitSoundOn("Hero_Sniper.AssassinateDamage", Target)
        local str_dmg = self:GetSpecialValueFor("damage")/100
        local damage = caster:GetAverageTrueAttackDamage(caster) * str_dmg  
        ApplyDamage({
            victim = Target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        })

        Target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration=0.01})

        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_assassinate_impact_sparks.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
        ParticleManager:SetParticleControlEnt(fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 1, Target, PATTACH_POINT_FOLLOW, "attach_hitloc", Target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx)

        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_assassinate_endpoint.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
        ParticleManager:SetParticleControlEnt(fx, 1, Target, PATTACH_POINT_FOLLOW, "attach_hitloc", Target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx)
    end
    return true
end

--------------------------------------------------------------------------------


modifier_ability_sniper_assassinate = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    CheckState              = function(self)
        return {
            [MODIFIER_STATE_PROVIDES_VISION] = true,
            [MODIFIER_STATE_INVISIBLE] = false
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_ability_sniper_assassinate:OnCreated()
    self.fx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
    ParticleManager:SetParticleControl(self.fx, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(self.fx, false, false, -1, false, true)
end