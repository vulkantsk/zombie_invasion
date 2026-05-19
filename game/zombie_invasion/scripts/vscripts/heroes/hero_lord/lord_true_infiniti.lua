require("heroes/hero_lord/lord_blood_helpers")

LinkLuaModifier("modifier_lord_true_infiniti", "heroes/hero_lord/lord_true_infiniti", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_true_infiniti = class({})

function lord_true_infiniti:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_lifesteal.vpcf",
		"particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf",
		"particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf",
		"particles/units/heroes/hero_grimstroke/grimstroke_sfm_ink_swell_reveal.vpcf",
	}, {
		"blood_rage",
		"infinity_vamp",
	}, context)
end


function lord_true_infiniti:GetIntrinsicModifierName()
	return "modifier_lord_true_infiniti"
end


modifier_lord_true_infiniti = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_PROPERTY_MIN_HEALTH,
            MODIFIER_EVENT_ON_TAKEDAMAGE,

        } end,
})

function modifier_lord_true_infiniti:RefreshBloodRage()
    self.modif = GetLordBloodRageModifier(self:GetParent())
end

function modifier_lord_true_infiniti:OnCreated()
    self:RefreshBloodRage()
    local ability = self:GetAbility()
    local level = math.max(ability:GetLevel() - 1, 0)
    self.pay = ability:GetHealthCost(level)
end
 


function modifier_lord_true_infiniti:OnRefresh()
    self:OnCreated()
end 
 
function modifier_lord_true_infiniti:GetMinHealth()
    if not self.modif or self.modif:IsNull() then
        self:RefreshBloodRage()
    end
    if self.modif and self:GetAbility():IsCooldownReady() and self.modif:GetStackCount() >= self.pay then
        return 1
    end
end

function modifier_lord_true_infiniti:OnTakeDamage( keys )
    if keys.unit ~= self:GetCaster() then
        return
    end

    if not self.modif or self.modif:IsNull() then
        self:RefreshBloodRage()
    end
    if not self.modif then
        return
    end

    if self:GetAbility():IsCooldownReady() and self.modif:GetStackCount() >= self.pay and self:GetCaster():GetHealth() <= 1  then 
        local caster = self:GetCaster()
        local ability = self:GetAbility()
 
         caster:SetHealth(caster:GetMaxHealth())
        caster:SetMana(caster:GetMaxMana())
        self:GetCaster():Purge( false, true, false, true, true )
        ability:UseResources(true, true, true,true)
                self.modif:SetStackCount(self.modif:GetStackCount() - self.pay)

    local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_sfm_ink_swell_reveal.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
        EmitSoundOn("infinity_vamp", caster)


    ParticleManager:SetParticleControl( self.effect_cast, 0, caster:GetAbsOrigin() )
 

 
   
    end
end
