LinkLuaModifier( "modifier_demon_absolute_form", "heroes/hero_demonslayer/demon_absolute_form/demon_absolute_form", LUA_MODIFIER_MOTION_NONE )

demon_absolute_form = class({})

function demon_absolute_form:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf",
		"particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf",
	}, {
		"Hero_Nevermore.RequiemOfSouls",
	}, context)
end


function demon_absolute_form:OnSpellStart() 

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_demon_absolute_form", {duration = 6 } )
    self:Explode( 64 )
end


modifier_demon_absolute_form = class({
        IsHidden                 = function(self) return false end,
        IsPurgable                 = function(self) return false end,
        IsDebuff                 = function(self) return true end,
        IsBuff                  = function(self) return true end,
        RemoveOnDeath             = function(self) return false end,
        CheckState      = function(self) return 
            {
                [MODIFIER_STATE_STUNNED] = true,
             [MODIFIER_STATE_MUTED] = true,  
              [MODIFIER_STATE_SILENCED] = true,            
            } end,
    })

function demon_absolute_form:Explode( lines )
self.damage = self:GetAbilityDamage()
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