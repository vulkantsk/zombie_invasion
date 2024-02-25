LinkLuaModifier( "modifier_phantom_assassin_blur_lua", "heroes/hero_phantoma_assasin/blur/blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_phantom_assassin_blur_smoke", "heroes/hero_phantoma_assasin/blur/blur" ,LUA_MODIFIER_MOTION_NONE )

if ability_phantom_assassin_blur == nil then
    ability_phantom_assassin_blur = class({})
end

function ability_phantom_assassin_blur:GetIntrinsicModifierName()
    return "modifier_phantom_assassin_blur_lua"
end


--------------------------------------------------------------------------------

function ability_phantom_assassin_blur:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    caster:Purge(false, true, false, false, false)
 
    EmitSoundOn("Hero_PhantomAssassin.Blur", caster)
     
    caster:AddNewModifier(caster, self, "modifier_ability_phantom_assassin_blur_smoke", {duration=duration})
 
end

--------------------------------------------------------------------------------


modifier_ability_phantom_assassin_blur_smoke = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetPriority             = function(self) return MODIFIER_PRIORITY_SUPER_ULTRA end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    CheckState              = function(self)
        return {
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        }
    end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        }
    end,
})


--------------------------------------------------------------------------------
 
function modifier_ability_phantom_assassin_blur_smoke:OnCreated()
    self.bonus_agility_base = self:GetAbility():GetSpecialValueFor("bonus_agility_base")
    self.bouns_agility_stack = self:GetAbility():GetSpecialValueFor("bouns_agility_stack")
    self.chance_miss = self:GetAbility():GetSpecialValueFor("chance_miss")
  
end

function modifier_ability_phantom_assassin_blur_smoke:GetModifierIncomingDamage_Percentage(params)
 
if params.unit == self:GetParent() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS  then return end
 
    local roll = RandomInt(1, 100)
    if RollPseudoRandomPercentage(self.chance_miss, 1, self:GetCaster())  then
        return -100
    end

    return
end

function modifier_ability_phantom_assassin_blur_smoke:GetModifierBonusStats_Agility()
    return self.bonus_agility_base 
end

function modifier_ability_phantom_assassin_blur_smoke:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS  then
 
        end
    end
end
 
function modifier_ability_phantom_assassin_blur_smoke:OnDestroy()
    EmitSoundOn("Hero_PhantomAssassin.Blur.Break", self:GetParent())
end

 
modifier_phantom_assassin_blur_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_assassin_blur_lua:IsHidden()
    -- dynamic
    -- if IsServer() then
        return not (self.blurOn and (not self:GetParent():PassivesDisabled()))
    -- end
end

function modifier_phantom_assassin_blur_lua:IsDebuff()
    return false
end

function modifier_phantom_assassin_blur_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_phantom_assassin_blur_lua:OnCreated( kv )
    -- references
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.interval = 0.5

    self.blurOn = true

    -- Start interval
    self:StartIntervalThink( self.interval )
    self:OnIntervalThink()
end

function modifier_phantom_assassin_blur_lua:OnRefresh( kv )
    -- references
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_phantom_assassin_blur_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_phantom_assassin_blur_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }

    return funcs
end

function modifier_phantom_assassin_blur_lua:GetModifierEvasion_Constant()
    if not self:GetParent():PassivesDisabled() then
        return self.bonus_evasion
    end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_phantom_assassin_blur_lua:CheckState()
    local state = {
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = (self.blurOn and (not self:GetParent():PassivesDisabled())),
    }

    return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_phantom_assassin_blur_lua:OnIntervalThink()
    if IsServer() then
        -- Hero search flag based on detecting or undetecting
        local flag = 0
        if self.blurOn then
            flag = DOTA_UNIT_TARGET_FLAG_NO_INVIS
        else
            flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
        end

        -- Find Enemy Heroes in Radius
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),   -- int, your team number
            self:GetParent():GetOrigin(),   -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            self.radius,    -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO,  -- int, type filter
            flag,   -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )

        -- Flip if detected
        if (self.blurOn) == (#enemies>0) then
            self.blurOn = (not self.blurOn)
        end
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_phantom_assassin_blur_lua:GetEffectName()
    return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf"
end

function modifier_phantom_assassin_blur_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end