LinkLuaModifier( modifier_ability_drow_ranger_multishot, heroesdrow_rangermultishot ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( modifier_ability_drow_ranger_multishot_hidden, heroesdrow_rangermultishot ,LUA_MODIFIER_MOTION_NONE )

if ability_drow_ranger_multishot == nil then
    ability_drow_ranger_multishot = class({})
end

--------------------------------------------------------------------------------

function ability_drow_ranger_multishotOnSpellStart()
    local caster = selfGetCaster()
    self.dir = (selfGetCursorPosition() - casterGetAbsOrigin())Normalized()
    self.arrow_damage_pct = selfGetSpecialValueFor(arrow_damage_pct)
    self.arrow_slow_duration = selfGetSpecialValueFor(arrow_slow_duration)

    casterAddNewModifier(caster, self, modifier_ability_drow_ranger_multishot, {duration=selfGetChannelTime()})
end

function ability_drow_ranger_multishotOnChannelFinish(bInterrupted)
    selfGetCaster()RemoveModifierByName(modifier_ability_drow_ranger_multishot)
    StopSoundOn(Hero_DrowRanger.Multishot.Channel, selfGetCaster())
end

function ability_drow_ranger_multishotOnProjectileHit(Target, Location)
    if Target ~= nil and not TargetIsInvulnerable() then
        if not TargetHasModifier(modifier_ability_drow_ranger_multishot_hidden) then
            TargetAddNewModifier(selfGetCaster(), self, modifier_ability_drow_ranger_multishot_hidden, {duration=0.1})

            local abil = selfGetCaster()FindAbilityByName(ability_drow_ranger_frost_arrows)
            if abil and abilIsTrained() and not TargetIsMagicImmune() then
                TargetAddNewModifier(selfGetCaster(), abil, modifier_ability_drow_ranger_frost_arrows_slow, {duration=self.arrow_slow_duration})
            end
            local damage = ((self:GetCaster()GetBaseDamageMax() + self:GetCaster()GetBaseDamageMin())  2)  100  self.arrow_damage_pct
            ApplyDamage({
                victim = Target,
                attacker = selfGetCaster(),
                damage = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = self
            })

            EmitSoundOn(Hero_DrowRanger.ProjectileImpact, Target)

            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------


modifier_ability_drow_ranger_multishot = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})


--------------------------------------------------------------------------------

if IsServer() then
function modifier_ability_drow_ranger_multishotOnCreated(kv)
    self.arrow_width = self:GetAbility()GetSpecialValueFor(arrow_width)
    self.arrow_speed = selfGetAbility()GetSpecialValueFor(arrow_speed)
    self.arrow_range_multiplier = selfGetAbility()GetSpecialValueFor(arrow_range_multiplier)
    self.arrow_angle = selfGetAbility()GetSpecialValueFor(arrow_angle)
    self.direction = selfGetAbility().dir
    self.caster_origin = selfGetCaster()GetAbsOrigin()
    self.start_angle = -20

    self.count = 0
    EmitSoundOn(Hero_DrowRanger.Multishot.Channel, selfGetCaster())

    selfStartIntervalThink(0.1)
end

function modifier_ability_drow_ranger_multishotOnIntervalThink()
    local caster = selfGetCaster()
    local abil = casterFindAbilityByName(ability_drow_ranger_frost_arrows)
    local sound = abilIsTrained() and Hero_DrowRanger.Multishot.FrostArrows or Hero_DrowRanger.Multishot.Attack
    EmitSoundOn(sound, caster)
    local distance = casterScript_GetAttackRange()  self.arrow_range_multiplier
    local Qangle = QAngle(0,self.start_angle,0)
    local endpos = RotatePosition(Vector(0,0,0), Qangle, self.direction)
    local direction = endpos

    local proj = abilIsTrained() and particlesunitsheroeshero_drowdrow_multishot_proj_linear_proj.vpcf or particlesunitsheroeshero_drowdrow_base_attack_linear_proj.vpcf
    local info = {
        Ability = selfGetAbility(),
        EffectName = proj,
        vSpawnOrigin = casterGetAttachmentOrigin(casterScriptLookupAttachment(attach_attack1)),
        fDistance = distance,
        fStartRadius = self.arrow_width,
        fEndRadius = self.arrow_width,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        fExpireTime = GameRulesGetGameTime() + 10.0,
        bDeleteOnHit = true,
        vVelocity = direction  self.arrow_speed,
        bProvidesVision = true,
        iVisionRadius = 100,
        iVisionTeamNumber = casterGetTeamNumber()
    }

    ProjectileManagerCreateLinearProjectile( info )
    self.start_angle = self.start_angle + (self.arrow_angle  5)

    self.count = self.count + 1
    if self.count = 4 then
        self.start_angle = -20
        self.count = 0
        selfStartIntervalThink(0.50)
    else
        selfStartIntervalThink(0.033)
    end
end
end

--------------------------------------------------------------------------------


modifier_ability_drow_ranger_multishot_hidden = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})