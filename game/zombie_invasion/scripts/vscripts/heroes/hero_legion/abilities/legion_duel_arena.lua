LinkLuaModifier( "modifier_legion_duel_arena_thinker", "heroes/hero_legion/abilities/legion_duel_arena" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_legion_duel_arena", "heroes/hero_legion/abilities/legion_duel_arena" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_legion_duel_arena_debuff", "heroes/hero_legion/abilities/legion_duel_arena" ,LUA_MODIFIER_MOTION_NONE )

legion_duel_arena = class({})

function legion_duel_arena:GetIntrinsicModifierName()
    return 'modifier_legion_duel_arena'
end 
 
--------------------------------------------------------------------------------

function legion_duel_arena:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")

    AddFOWViewer(caster:GetTeamNumber(), point, radius, 10, true)

    CreateModifierThinker(caster, self, "modifier_legion_duel_arena_thinker", {duration=duration}, point, caster:GetTeamNumber(), false)
    caster:AddNewModifier(caster, self, "modifier_legion_duel_arena", {duration=duration})
end

function legion_duel_arena:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------


modifier_legion_duel_arena_thinker = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})


--------------------------------------------------------------------------------

function modifier_legion_duel_arena_thinker:IsAura()
    return true
end

function modifier_legion_duel_arena_thinker:GetModifierAura()
    return "modifier_legion_duel_arena_debuff"
end

function modifier_legion_duel_arena_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_legion_duel_arena_thinker:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_legion_duel_arena_thinker:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_legion_duel_arena_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_legion_duel_arena_thinker:OnCreated(kv)
    local caster = self:GetCaster()
    local point = self:GetParent():GetAbsOrigin()
    local radius = self:GetAbility():GetSpecialValueFor("radius")

    self.field_particle = ParticleManager:CreateParticle("particles/legion_duel.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl( self.field_particle, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( self.field_particle, 7, self:GetParent():GetOrigin() )

end
function modifier_legion_duel_arena_thinker:OnDestroy()
    ParticleManager:DestroyParticle(self.field_particle, true)
    ParticleManager:ReleaseParticleIndex(self.field_particle)
end
 
--------------------------------------------------------------------------------


modifier_legion_duel_arena_debuff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_legion_duel_arena_debuff:OnCreated(kv)
    self.activate = false

    self:StartIntervalThink(0.03)
end

function modifier_legion_duel_arena_debuff:OnIntervalThink()
    local thinker = self:GetAuraOwner()
    if not thinker then self.activate = false return end
    local target = self:GetParent()
    local ability = self:GetAbility()
    local radius = ability:GetSpecialValueFor("radius")
    local caster = self:GetCaster()

    local distance = (target:GetAbsOrigin() - thinker:GetAbsOrigin()):Length2D()
    local distance_from_border = distance - radius
    
    local target_angle = target:GetAnglesAsVector().y
    
    local origin_difference =  thinker:GetAbsOrigin() - target:GetAbsOrigin()
    local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
    
    origin_difference_radian = origin_difference_radian * 180
    local angle_from_center = origin_difference_radian / math.pi

    angle_from_center = angle_from_center + 180.0
 
    ExecuteOrderFromTable({
        UnitIndex = target:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
        TargetIndex = caster:entindex()
    })

    if distance_from_border <= 0 and math.abs(distance_from_border) <= 30 and (math.abs(target_angle - angle_from_center)<90 or math.abs(target_angle - angle_from_center)>270) then
        self.activate = true
        target:InterruptMotionControllers(true)
    elseif distance_from_border > 0 and math.abs(distance_from_border) <= 30 and (math.abs(target_angle - angle_from_center)>90) then
        self.activate = true
        target:InterruptMotionControllers(true)
    else
        self.activate = false
    end
end

function modifier_legion_duel_arena_debuff:GetModifierMoveSpeed_Absolute()
    if self.activate == true then
        return 0.1
    end
    return 
end
 
modifier_legion_duel_arena = class({
    IsHidden                 = function(self) return false end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_EVENT_ON_DEATH,
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

        } end,
})

function modifier_legion_duel_arena:OnDeath(data)
    local killer = data.attacker
    local killed_unit = data.unit
    if killed_unit:HasModifier("modifier_legion_duel_arena_debuff") then 
        self:IncrementStackCount()
    end
  
end
function modifier_legion_duel_arena:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_legion_duel_arena:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("stats_per_kill") * self:GetStackCount()
end

function modifier_legion_duel_arena:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("stats_per_kill") * self:GetStackCount()
end


function modifier_legion_duel_arena:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("stats_per_kill") * self:GetStackCount()
end



