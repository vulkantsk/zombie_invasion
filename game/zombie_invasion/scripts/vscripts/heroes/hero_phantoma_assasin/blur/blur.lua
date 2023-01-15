 
LinkLuaModifier( "modifier_ability_phantom_assassin_blur_smoke", "heroes/hero_phantoma_assasin/blur/blur" ,LUA_MODIFIER_MOTION_NONE )

if ability_phantom_assassin_blur == nil then
    ability_phantom_assassin_blur = class({})
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

 