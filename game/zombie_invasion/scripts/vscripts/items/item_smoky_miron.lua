item_smoky_miron = class({})
LinkLuaModifier( "modifier_item_smoky_miron", "items/item_smoky_miron", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_smoky_miron_movespeed_buff", "items/item_smoky_miron", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_smoky_miron_passive", "items/item_smoky_miron", LUA_MODIFIER_MOTION_NONE )

 function item_smoky_miron:GetIntrinsicModifierName()
    return "modifier_item_smoky_miron_passive"
end
function item_smoky_miron:Precache( context )
    PrecacheResource( "soundfile", "sounds/weapons/hero/brewmaster/drunken_haze_cast.vsnd", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_splash.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_self_attack.vpcf", context )
end

function item_smoky_miron:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")

    -- logic
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), -- int, your team number
        caster:GetOrigin(), -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_BOTH,    -- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        0,  -- int, flag filter
        0,  -- int, order filter
        false   -- bool, can grow cache
    )
    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_item_smoky_miron", -- modifier name
            { duration = duration } -- kv
        )
    end

    self:PlayEffects( radius )
end

function item_smoky_miron:PlayEffects( radius )
    local particle_cast = "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_splash.vpcf"


    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        "",
        Vector(0,0,0), -- unknown   
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_item_smoky_miron = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf" end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
            MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        }
    end,
})


function modifier_item_smoky_miron:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
    self:StartIntervalThink(1)
    self:OnIntervalThink()
    
end

function modifier_item_smoky_miron:GetModifierIncomingDamage_Percentage()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return -self.damage_pct
    else
        return self.damage_pct
    end
end

function modifier_item_smoky_miron:GetModifierDamageOutgoing_Percentage()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return self.damage_pct
    else
        return -self.damage_pct
    end
end

function modifier_item_smoky_miron:OnIntervalThink()
    if IsServer() then
        self:GetParent():AddNewModifier(
            self:GetParent(), -- player source
            self:GetAbility(),
            "modifier_item_smoky_miron_movespeed_buff", -- modifier name
            { duration = 0.45 } -- kv
        )
        local damageTable = {
        victim = self:GetParent(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        attacker = self:GetCaster(),
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)
    end
end

modifier_item_smoky_miron_movespeed_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        }
    end,
})


function modifier_item_smoky_miron_movespeed_buff:OnCreated()
        self.ms_t_pct = self:GetAbility():GetSpecialValueFor("ms_t_pct")

        self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_self_attack.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_POINT, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(self.fx, false, false, -1, false, false)
    if IsServer() then 
        self:GetParent():EmitSound("Hero_BrewMaster.CinderBrew.SelfAttack")
    end
end

function modifier_item_smoky_miron_movespeed_buff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return self.ms_t_pct
    end
end

 modifier_item_smoky_miron_passive = modifier_item_smoky_miron_passive or class({})

-- Modifier properties

function modifier_item_smoky_miron_passive:IsHidden()        return true end
function modifier_item_smoky_miron_passive:IsPurgable()      return false end
function modifier_item_smoky_miron_passive:RemoveOnDeath()   return true end
--function modifier_rom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Various stat bonuses
function modifier_item_smoky_miron_passive:DeclareFunctions()
    return {
 
      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
      MODIFIER_PROPERTY_EVASION_CONSTANT,
      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
      MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
 
    }
end

function modifier_item_smoky_miron_passive:OnCreated()
    self.ability    = self:GetAbility()

        self.agi             =   self.ability:GetSpecialValueFor("agi")
        self.evasion             =   self.ability:GetSpecialValueFor("evasion")
        self.damage_pre_attack             =   self.ability:GetSpecialValueFor("damage_pre_attack")
        self.armor_bonus             =   self.ability:GetSpecialValueFor("armor_bonus")
 
end


-- Stats
function modifier_item_smoky_miron_passive:GetModifierBonusStats_Agility() return self.agi end

function modifier_item_smoky_miron_passive:GetModifierEvasion_Constant() return self.evasion end

function modifier_item_smoky_miron_passive:GetModifierPreAttack_BonusDamage() return self.damage_pre_attack end

function modifier_item_smoky_miron_passive:GetModifierPhysicalArmorBonus() return self.armor_bonus end