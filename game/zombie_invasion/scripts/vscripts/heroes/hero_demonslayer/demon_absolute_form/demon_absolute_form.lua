LinkLuaModifier( "demon_absolute_form", "heroes/demon_absolute_form/demon_absolute_form", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "demon_absolute_form_scepter", "heroes/demon_absolute_form/demon_absolute_form", LUA_MODIFIER_MOTION_NONE )

demon_absolute_form = class({})

function demon_absolute_form:OnSpellStart() 

    self:GetCater():AddNewModifier(self:GetCater(), self, "modifier_demon_absolute_form", {duration = 6 } )

        local soul_per_line = self:GetSpecialValueFor("requiem_soul_conversion")

    local lines = 0
    local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_ability_necromastery", self:GetCaster() )
    if modifier~=nil then
        lines = math.floor(modifier:GetStackCount() / soul_per_line) 
    end

    self:Explode( lines )

    if self:GetCaster():HasScepter() then
        local explodeDuration = self:GetSpecialValueFor("requiem_radius") / self:GetSpecialValueFor("requiem_line_speed")
        self:GetCaster():AddNewModifier(
            self:GetCaster(),
            self,
            "modifier_ability_requiem_scepter",
            {
                lineDuration = explodeDuration,
                lineNumber = lines,
            }
        )
    end
end

modifier_demon_absolute_form = class({})

function modifier_demon_absolute_form:OnCreated()
    self:StartIntervalThink(2)
end

function modifier_demon_absolute_form:OnIntervalThink()
    self:Explode(100)
end

function modifier_demon_absolute_form:OnAbilityPhaseStart()
    self.effect_precast = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_nevermore/nevermore_wings.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetCaster()
    )   

    EmitSoundOn("Hero_Nevermore.RequiemOfSoulsCast", self:GetCaster())

    return true
end

function modifier_demon_absolute_form:Explode( lines )
    self.damage =  self:GetAbilityDamage()
    self.duration = self:GetSpecialValueFor("requiem_slow_duration")

    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("requiem_radius")
    local line_speed = self:GetSpecialValueFor("requiem_line_speed")
    local initial_angle_deg = self:GetCaster():GetAnglesAsVector().y
    local delta_angle = 360/lines
    for i=0,lines-1 do
        local facing_angle_deg = initial_angle_deg + delta_angle * i
        if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
        local facing_angle = math.rad(facing_angle_deg)
        local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
        local velocity = facing_vector * line_speed

        ProjectileManager:CreateLinearProjectile( {
            Source = caster,
            Ability = self,
            EffectName = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf",
            vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
            fDistance = radius,
            vVelocity = velocity,
            fStartRadius = self:GetSpecialValueFor("requiem_line_width_start"),
            fEndRadius = self:GetSpecialValueFor("requiem_line_width_end"),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            bReplaceExisting = false,
            bProvidesVision = false,
        } )

        local effect_line = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf",
            PATTACH_ABSORIGIN,
            caster
        )
        ParticleManager:SetParticleControl(effect_line, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(effect_line, 1, velocity)
        ParticleManager:SetParticleControl(effect_line, 2, Vector(0, radius / line_speed, 0))
        ParticleManager:ReleaseParticleIndex(effect_line)
    end

    ParticleManager:ReleaseParticleIndex( self.effect_precast )

    local effect_cast = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetCaster()
    )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( lines, 0, 0 ) )
    ParticleManager:SetParticleControlForward( effect_cast, 2, caster:GetForwardVector() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn("Hero_Nevermore.RequiemOfSouls", caster)
end