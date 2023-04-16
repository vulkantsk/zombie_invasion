LinkLuaModifier( "modifier_ability_hellstep", "heroes/hero_sargatanas/hellstep.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_hellstep_thinker", "heroes/hero_sargatanas/hellstep.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_overheating", "heroes/hero_sargatanas/modifier_overheating.lua" ,LUA_MODIFIER_MOTION_NONE )

if ability_hellstep== nil then
    ability_hellstep = class({})
end

--------------------------------------------------------------------------------

function ability_hellstep:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function ability_hellstep:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local projectile_speed = self:GetSpecialValueFor("projectile_speed")

    local vector = point-caster:GetOrigin()

    local projectile_distance = vector:Length2D()
    local projectile_direction = vector
    projectile_direction.z = 0
    projectile_direction = projectile_direction:Normalized()

    GridNav:DestroyTreesAroundPoint(point, self:GetSpecialValueFor("radius"), true)

    local info = {
        Ability = self,
        EffectName = "",
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = projectile_distance,
        fStartRadius = 0,
        fEndRadius = 0,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        bDeleteOnHit = false,
        vVelocity = projectile_direction * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber(),
    }

    ProjectileManager:CreateLinearProjectile( info )
end

function ability_hellstep:OnProjectileHit(Target, Location)
    if Target then return false end

    local duration = self:GetSpecialValueFor("duration")

    CreateModifierThinker(self:GetCaster(), self, "modifier_ability_hellstep_thinker", {duration = duration}, Location, self:GetCaster():GetTeamNumber(), false)

end

--------------------------------------------------------------------------------


modifier_ability_hellstep_thinker = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

 --------------------------------------------------------------------------------

function modifier_ability_hellstep_thinker:IsAura()
    return true
end

function modifier_ability_hellstep_thinker:GetModifierAura()
    return "modifier_ability_hellstep"
end

function modifier_ability_hellstep_thinker:GetAuraRadius()
    return self.radius
end

function modifier_ability_hellstep_thinker:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ability_hellstep_thinker:GetAuraDuration()    
    return 0.5
end

function modifier_ability_hellstep_thinker:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_hellstep_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_ability_hellstep_thinker:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")

    if IsServer() then
        EmitSoundOn("Hero_DragonKnight.BreathFire", self:GetParent())

        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(fx, 1, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(fx, 2, Vector(self.radius,0,0))
 
        self:AddParticle(fx, false, false, 0, false, false)
 
    end
end
 
function modifier_ability_hellstep_thinker:OnDestroy()
   --         ParticleManager:DestroyParticle( self.fx, true )

end

--------------------------------------------------------------------------------


modifier_ability_hellstep = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
        DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

        } end,
    CheckState              = function(self)
        return {
            [MODIFIER_STATE_PASSIVES_DISABLED] = true
        }
    end,
    GetAttributes             = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    GetEffectName           = function(self) return "particles/generic_gameplay/generic_break.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_OVERHEAD_FOLLOW end,
})
 
 

--------------------------------------------------------------------------------

function modifier_ability_hellstep:OnCreated()
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

    self.min_damage = self:GetAbility():GetSpecialValueFor("min_damage")
    self.max_damage = self:GetAbility():GetSpecialValueFor("max_damage")
    self.max_duration = self:GetAbility():GetSpecialValueFor("max_duration")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.damage_mid_per_tick = (self.max_damage - self.min_damage) / (self.duration / 0.4)
    self.damage_per_tick = 0.05*math.ceil(100*self.damage_mid_per_tick)
    self.stack_overhell = self:GetAbility():GetSpecialValueFor("stack_overhell")
    self.ticks = 1

    self.time_old = GameRules:GetGameTime()

    if IsServer() then
        self:StartIntervalThink(0.5)

        self.fx = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_ambient_fireball_lava.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
        self:AddParticle(self.fx, false, false, -1, false, false)
    end
end
 
 function modifier_ability_hellstep:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
        return self.bonus_attack_speed
    end
end

function modifier_ability_hellstep:GetModifierPreAttack_BonusDamage()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
        return self.bonus_damage
    end
end
function modifier_ability_hellstep:OnIntervalThink()
    local time_now = GameRules:GetGameTime()

    if math.floor(time_now - self.time_old) <= self.max_duration then
        self.ticks = self.ticks + 1
    end

    local damage = self.damage_per_tick * self.ticks

    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage * self:GetParent():DamageHell(),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility()
    })

    if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
        self:GetParent():ModifierStackInc("modifier_overheating", self.stack_overhell,8,self.stack_overhell,self:GetAbility())
    end
    EmitSoundOn("Hero_Viper.NetherToxin.Damage", self:GetParent())
end
 