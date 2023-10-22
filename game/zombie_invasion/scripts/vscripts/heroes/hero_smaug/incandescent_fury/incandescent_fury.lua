LinkLuaModifier( "modifier_incandescent_fury", "heroes/hero_smaug/incandescent_fury/incandescent_fury", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_incandescent_fury_thinker", "heroes/hero_smaug/incandescent_fury/incandescent_fury", LUA_MODIFIER_MOTION_NONE )

incandescent_fury = {}

function incandescent_fury:GetCastRange( vLocation, hTarget )

    return self:GetSpecialValueFor( "cast_range" )
end

function incandescent_fury:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    local dir = point - caster:GetAbsOrigin()
    dir.z = 0
    dir = dir:Normalized()

    local duration = self:GetSpecialValueFor( "duration" )
 

    CreateModifierThinker(
        caster,
        self,
        "modifier_incandescent_fury_thinker",
        {
            duration = duration,
            x = dir.x,
            y = dir.y,
        },
        caster:GetAbsOrigin(),
        caster:GetTeamNumber(),
        false
    )

    EmitSoundOn( "Hero_Jakiro.Macropyre.Cast", caster )
end

modifier_incandescent_fury = {}

function modifier_incandescent_fury:IsHidden()
    return false
end

function modifier_incandescent_fury:IsDebuff()
    return true
end

function modifier_incandescent_fury:IsStunDebuff()
    return false
end

function modifier_incandescent_fury:IsPurgable()
    return false
end

function modifier_incandescent_fury:OnCreated( kv )
    if not IsServer() then return end

    self.damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = kv.damage + self:GetCaster():GetAttackDamage() * (self:GetAbility():GetSpecialValueFor( "pct_dmg" )  / 100),
        damage_type = kv.damage_type,
        ability = self:GetAbility(),
    }

    self:StartIntervalThink( kv.interval )
end

function modifier_incandescent_fury:OnRefresh( kv )
    if not IsServer() then return end
    self.damageTable.damage = kv.damage + self:GetCaster():GetAttackDamage() * (self:GetAbility():GetSpecialValueFor( "pct_dmg"  / 100))
    self.damageTable.damage_type = kv.damage_type
end

function modifier_incandescent_fury:OnIntervalThink()
    ApplyDamage( self.damageTable )
end

function modifier_incandescent_fury:GetEffectName()
    return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_incandescent_fury:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_incandescent_fury_thinker = {}

function modifier_incandescent_fury_thinker:IsHidden()
    return false
end

function modifier_incandescent_fury_thinker:IsDebuff()
    return false
end

function modifier_incandescent_fury_thinker:IsStunDebuff()
    return false
end

function modifier_incandescent_fury_thinker:IsPurgable()
    return false
end

function modifier_incandescent_fury_thinker:OnCreated( kv )
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.radius = self:GetAbility():GetSpecialValueFor( "path_radius" )
    self.duration = self:GetAbility():GetSpecialValueFor( "linger_duration" )
    self.interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )
    self.range = self:GetAbility():GetCastRange( self.parent:GetAbsOrigin(), nil ) + self.caster:GetCastRangeBonus()
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
 

    if not IsServer() then return end

    self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
    self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
    self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
    self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

    local start_range = 234
    self.direction = Vector( kv.x, kv.y, 0 )
    self.startpoint = self.parent:GetAbsOrigin() + self.direction * start_range
    self.endpoint = self.startpoint + self.direction * self.range

    local step = 0
    while step < self.range do
        local loc = self.startpoint + self.direction * step
        GridNav:DestroyTreesAroundPoint( loc, self.radius, true )

        step = step + self.radius
    end

    self:StartIntervalThink( self.interval )

    local duration = self:GetDuration()
    local effect_cast = ParticleManager:CreateParticle(
        "particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre.vpcf",
        PATTACH_WORLDORIGIN,
        self.parent
    )
    ParticleManager:SetParticleControl( effect_cast, 0, self.startpoint )
    ParticleManager:SetParticleControl( effect_cast, 1, self.endpoint )
    ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )

    self:AddParticle(
        effect_cast,
        false,
        false,
        -1,
        false,
        false
    )

    EmitSoundOn( "hero_jakiro.macropyre", self.parent )
end

function modifier_incandescent_fury_thinker:OnDestroy()
    if not IsServer() then return end
    UTIL_Remove( self:GetParent() )
end

function modifier_incandescent_fury_thinker:OnIntervalThink()
    local enemies = FindUnitsInLine(
        self.caster:GetTeamNumber(),
        self.startpoint,
        self.endpoint,
        nil,
        self.radius,
        self.abilityTargetTeam,
        self.abilityTargetType,
        self.abilityTargetFlags
    )

    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(
            self.caster,
            self:GetAbility(),
            "modifier_incandescent_fury",
            {
                duration = self.duration,
                interval = self.interval,
                damage = self.damage * self.interval,
                damage_type = self.abilityDamageType,
            }
        )
    end
end