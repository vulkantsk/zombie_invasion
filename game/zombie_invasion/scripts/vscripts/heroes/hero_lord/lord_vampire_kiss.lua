LinkLuaModifier("modifier_lord_vampire_kiss_buff", "heroes/hero_lord/lord_vampire_kiss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_vampire_kiss = class({})

function lord_vampire_kiss:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_lifesteal.vpcf",
		"particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf",
		"particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg_stroke_tgt.vpcf",
		"particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf",
	}, {
		"blood_rage",
		"vamp_kiss",
	}, context)
end

 
 function lord_vampire_kiss:CastFilterResultTarget(hTarget)

        if not (self:GetCaster():HasModifier("modifier_lord_blood_rage")) then
            return UF_FAIL_CUSTOM
        end

        if self:GetCaster():HasModifier("modifier_lord_blood_rage") then
            local modif = self:GetCaster():FindModifierByName("modifier_lord_blood_rage")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return UF_FAIL_CUSTOM
            end
        end
        return UF_SUCCESS
end


function lord_vampire_kiss:GetCustomCastErrorTarget(hTarget)

        if not (self:GetCaster():HasModifier("modifier_lord_blood_rage")) then
            return "#dota_hud_error_havent_charges"
        end

        if self:GetCaster():HasModifier("modifier_lord_blood_rage") then
            local modif = self:GetCaster():FindModifierByName("modifier_lord_blood_rage")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return "#dota_hud_error_havent_charges"
            end
        end
        return UF_SUCCESS
end

function lord_vampire_kiss:OnSpellStart()
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local healthCost = self:GetHealthCost(self:GetLevel())

    local modif = caster:FindModifierByName("modifier_lord_blood_rage")

    if target:GetTeamNumber() == caster:GetTeamNumber() then 
        target:AddNewModifier(caster, self, "modifier_lord_vampire_kiss_buff", {})
    else 
        local damage = (self:GetSpecialValueFor("damage_percent")/100) * target:GetHealth()
        ApplyDamage({
                victim = target,
                attacker = caster,
                damage = damage,
                damage_type = self:GetAbilityDamageType() ,
                ability = self,
        })
    end

    modif:SetStackCount(modif:GetStackCount() - healthCost)
    EmitSoundOn("vamp_kiss", target)
    local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg_stroke_tgt.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
 

    ParticleManager:SetParticleControl( self.effect_cast, 0, target:GetAbsOrigin() )

 
 
end


modifier_lord_vampire_kiss_buff = class({
    IsHidden                 = function(self) return false end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,
})

function modifier_lord_vampire_kiss_buff:OnCreated()
    self.lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_resist = self:GetAbility():GetSpecialValueFor("bonus_resist")
    self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_ms")
end


function modifier_lord_vampire_kiss_buff:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor
end

function modifier_lord_vampire_kiss_buff:GetModifierPreAttack_BonusDamage() 
    return self.bonus_damage
end

function modifier_lord_vampire_kiss_buff:GetModifierIncomingDamage_Percentage()
    return -self.bonus_resist
end

function modifier_lord_vampire_kiss_buff:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_ms
end

  
function modifier_lord_vampire_kiss_buff:OnTakeDamage( keys )
    if  keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        -- Spell lifesteal handler
 
        if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
            -- Heal and fire the particle           
            self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
            ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
         
            keys.attacker:Heal(keys.damage * self.lifesteal_pct * 0.01, keys.attacker)
        end
    end
end

  