LinkLuaModifier( "modifier_ability_seer_punch", "heroes/hero_dark_seer/seer_punch/seer_punch" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua" ,LUA_MODIFIER_MOTION_NONE )


if ability_seer_punch == nil then
    ability_seer_punch = class({})
end

--------------------------------------------------------------------------------
function ability_seer_punch:GetAOERadius()
 
        return self:GetSpecialValueFor( "punch_radius" )
     

     
end
 
function ability_seer_punch:OnAbilityPhaseStart()
    if IsServer() then
            local caster = self:GetCaster()
        self.particle_fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_punch_glove_attack.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(self.particle_fx2, 1, caster:GetAbsOrigin())

    end
    return true
end

function ability_seer_punch:OnAbilityPhaseInterrupted()
    if IsServer() then
       ParticleManager:DestroyParticle( self.particle_fx2, true)
    end
      return true
end

 

function ability_seer_punch:OnSpellStart()
        local target = self:GetCursorTarget()
            local target_loc    =   self:GetCursorPosition()
            local search = self:GetSpecialValueFor("punch_radius")
    local caster = self:GetCaster()
 
    local damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetHealth()
 
        enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target_loc, -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            search, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
 
 

    self.particle_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_attack_normal_punch.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(self.particle_fx, 1, caster:GetAbsOrigin())
 
 
    for _,enemy in pairs(enemies) do
        -- delay
                 local dist = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()

        local distance = 150 - (150 / 150 * dist)
        if distance <= 0 then
            distance = 1
        end

        local knockbackProperties =
        {
            center_x = caster:GetAbsOrigin().x,
            center_y = caster:GetAbsOrigin().y,
            center_z = caster:GetAbsOrigin().z,
            duration = self:GetDuration(),
            knockback_duration = self:GetDuration(),
            knockback_distance = distance,
            knockback_height = 0,
            should_stun = true
        }

        enemy:AddNewModifier( caster, self, "modifier_knockback", knockbackProperties )

        DealDamage(self:GetCaster(), enemy, damage, self:GetAbilityDamageType(), nil, self)
        
    end
 
 

    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ability.Assassinate", caster)
 
end

 

--------------------------------------------------------------------------------


modifier_ability_seer_punch = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_seer_punch:IsHidden()
    return false
end

function modifier_ability_seer_punch:IsDebuff()
    return true
end

function modifier_ability_seer_punch:IsStunDebuff()
    return true
end

function modifier_ability_seer_punch:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_seer_punch:OnCreated( kv )
    if not IsServer() then return end

    -- set direction and speed
    local center = Vector( kv.x, kv.y, 0 )
    self.direction = center - self:GetParent():GetOrigin()
    self.speed = self.direction:Length2D()/self:GetDuration()

    self.direction.z = 0
    self.direction = self.direction:Normalized()

    -- apply motion
    if not self:ApplyHorizontalMotionController() then
        self:Destroy()
    end
end

function modifier_ability_seer_punch:OnRefresh( kv )
    self:OnCreated( kv )
end

 

function modifier_ability_seer_punch:OnDestroy()
    if not IsServer() then return end
    self:GetParent():RemoveHorizontalMotionController( self )
 
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ability_seer_punch:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_ability_seer_punch:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ability_seer_punch:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_ability_seer_punch:UpdateHorizontalMotion( me, dt )
    local target = me:GetOrigin() + self.direction * self.speed * dt
    me:SetOrigin( target )
end

function modifier_ability_seer_punch:OnHorizontalMotionInterrupted()
    self:Destroy()
end