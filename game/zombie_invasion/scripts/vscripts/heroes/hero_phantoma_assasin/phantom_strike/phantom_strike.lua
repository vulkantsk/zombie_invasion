LinkLuaModifier( "modifier_ability_phantom_assassin_phantom_strike", "heroes/hero_phantoma_assasin/phantom_strike/phantom_strike" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_strike_illusion", "heroes/hero_phantoma_assasin/phantom_strike/phantom_strike" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_strike", "heroes/hero_phantoma_assasin/phantom_strike/phantom_strike" ,LUA_MODIFIER_MOTION_NONE )

if ability_phantom_assassin_phantom_strike == nil then
    ability_phantom_assassin_phantom_strike = class({})
end

function ability_phantom_assassin_phantom_strike:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_lifesteal.vpcf",
		"particles/status_fx/status_effect_terrorblade_reflection.vpcf",
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf",
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf",
		"particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf",
	}, {
	}, context)
end


--------------------------------------------------------------------------------

function ability_phantom_assassin_phantom_strike:CastFilterResultTarget(target)
    if target == self:GetCaster() then
        return UF_FAIL_CUSTOM
    else
        return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
    end
end

function ability_phantom_assassin_phantom_strike:GetCustomCastErrorTarget(target)
    if target == self:GetCaster() then
        return "#dota_hud_error_cant_cast_on_self"
    end
end

function ability_phantom_assassin_phantom_strike:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if target:TriggerSpellAbsorb(self) then return end

    local duration = self:GetSpecialValueFor("duration")

    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_PhantomAssassin.Strike.Start", caster)

    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:ReleaseParticleIndex(fx)

    local point = target:GetAbsOrigin() + (caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized() * 50
    FindClearSpaceForUnit(caster, point, false)

    if target:GetTeamNumber() ~= caster:GetTeamNumber() then
        caster:AddNewModifier(caster, self, "modifier_ability_phantom_assassin_phantom_strike", {duration=duration})
    end

    EmitSoundOnLocationWithCaster(point, "Hero_PhantomAssassin.Strike.End", caster)

    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(fx, 0, point)
    ParticleManager:ReleaseParticleIndex(fx)

    if caster:HasScepter() and  target:GetTeamNumber() ~= caster:GetTeamNumber() then 
        target:AddNewModifier(caster,self,"modifier_ability_strike", {duration = duration})
    end

    ExecuteOrderFromTable({
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
        TargetIndex = target:entindex(),
        Queue = false,
    })
end

--------------------------------------------------------------------------------


modifier_ability_phantom_assassin_phantom_strike = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_ability_phantom_assassin_phantom_strike:OnCreated()
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.lifesteal = self:GetAbility():GetSpecialValueFor("bonus_lifesteal")
end

function modifier_ability_phantom_assassin_phantom_strike:OnRefresh()
    self:OnCreated()
end

function modifier_ability_phantom_assassin_phantom_strike:GetModifierAttackSpeedBonus_Constant() return self.bonus_attack_speed end


function modifier_ability_phantom_assassin_phantom_strike:GetModifierProcAttack_Feedback( params )
    if IsServer() then
        -- filter
        local pass = false
        if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
            if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
                pass = true
            end
        end

        -- logic
        if pass then
            -- save attack record
            self.attack_record = params.record
        end
    end
end

function modifier_ability_phantom_assassin_phantom_strike:OnTakeDamage( params )
    if IsServer() then
        -- filter
        local pass = false
        if self.attack_record and params.record == self.attack_record then
            pass = true
            self.attack_record = nil
        end

        -- logic
        if pass then
            -- get heal value
            local heal = params.damage * self.lifesteal/100
            self:GetParent():Heal( heal, self:GetAbility() )
            self:PlayEffects( self:GetParent() )
        end
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_phantom_assassin_phantom_strike:PlayEffects( target )
    -- get resource
    local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"

    -- play effects
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_ability_strike_illusion = {}

function modifier_ability_strike_illusion:IsHidden()
    return true
end

function modifier_ability_strike_illusion:IsDebuff()
    return false
end

function modifier_ability_strike_illusion:IsPurgable()
    return false
end

function modifier_ability_strike_illusion:OnCreated( kv )

 
    if not IsServer() then return end
end

function modifier_ability_strike_illusion:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }

    return funcs
end

function modifier_ability_strike_illusion:GetModifierMoveSpeed_Absolute()
    return 550
end

function modifier_ability_strike_illusion:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    }
end

function modifier_ability_strike_illusion:GetStatusEffectName()
    return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_ability_strike_illusion:StatusEffectPriority()
    return 100000
end

modifier_ability_strike = {}

function modifier_ability_strike:IsHidden()
    return false
end

function modifier_ability_strike:IsDebuff()
    return true
end

function modifier_ability_strike:IsStunDebuff()
    return false
end

function modifier_ability_strike:IsPurgable()
    return true
end

function modifier_ability_strike:OnCreated( kv )
 
    if not IsServer() then return end
self.outgoing = self:GetAbility():GetSpecialValueFor( "illusion_outgoing_damage" )
    self.distance = 72
    local duration = self:GetAbility():GetSpecialValueFor("duration")

 
    local illusions = CreateIllusions(
        self:GetCaster(),
        self:GetCaster(),
        {
            outgoing_damage = self.outgoing,
            duration = duration,
        },
        1,
        self.distance,
        false,
        true
    )
    local illusion = illusions[1]

    illusion:AddNewModifier(
        self:GetCaster(),
        self:GetAbility(),
        "modifier_ability_strike_illusion",
        { duration = duration }
    )

    self:GetAbility():SetContextThink( self:GetAbility():GetAbilityName(), function()
        local order = {
            UnitIndex = illusion:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = self:GetParent():entindex(),
        }
        ExecuteOrderFromTable( order )
    end, FrameTime())

    self.illusions = self.illusions or {}
    self.illusions[ illusion ] = true

    self:StartIntervalThink( 0.1 )
end

function modifier_ability_strike:OnRefresh( kv )
    self:OnCreated( kv )    
end

function modifier_ability_strike:OnDestroy()
    if not IsServer() then return end

    for illusion,_ in pairs( self.illusions ) do
        if not illusion:IsNull() then
            illusion:ForceKill( false )
        end
    end
end

 
function modifier_ability_strike:OnIntervalThink()
    local parent = self:GetParent()
    local origin = parent:GetOrigin()
    local seen = self:GetCaster():CanEntityBeSeenByMyTeam( parent )

    if not seen then
        for illusion,_ in pairs( self.illusions ) do
            if not illusion:IsNull() and (illusion:GetOrigin()-origin):Length2D()>self.distance/2 then
                illusion:MoveToPosition( origin )
            end
        end
    else
        for illusion,_ in pairs( self.illusions ) do
            if not illusion:IsNull() and illusion:GetAggroTarget()~=parent then
                local order = {
                    UnitIndex = illusion:entindex(),
                    OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                    TargetIndex = parent:entindex(),
                }
                ExecuteOrderFromTable( order )
            end
        end
    end
end

function modifier_ability_strike:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_ability_strike:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end