LinkLuaModifier("modifier_sacrifice_revenge", "heroes/hero_blood_hunter/sacrifice_revenge/sacrifice_revenge", 0)
LinkLuaModifier("modifier_sacrifice_revenge_buff", "heroes/hero_blood_hunter/sacrifice_revenge/sacrifice_revenge", 0)
LinkLuaModifier( "modifier_bloodrage_buff", "heroes/hero_blood_hunter/bloodrage/bloodrage", LUA_MODIFIER_MOTION_NONE )

sacrifice_revenge = class({})

function sacrifice_revenge:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf",
		"particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold.vpcf",
		"particles/generic_gameplay/generic_lifesteal.vpcf",
		"particles/units/heroes/hero_ursa/ursa_enrage_buff_2.vpcf",
	}, {
		"hero_bloodseeker.bloodRage",
		"hero_bloodseeker.rupture",
	}, context)
end


function sacrifice_revenge:CastFilterResult()
        if not (self:GetCaster():HasModifier("modifier_bloodrage_buff")) then
            return UF_FAIL_CUSTOM
        end

        if self:GetCaster():HasModifier("modifier_bloodrage_buff") then
            local modif = self:GetCaster():FindModifierByName("modifier_bloodrage_buff")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return UF_FAIL_CUSTOM
            end
        end
        return UF_SUCCESS
end
  

function sacrifice_revenge:GetCustomCastError()
        if not (self:GetCaster():HasModifier("modifier_bloodrage_buff")) then
            return "#dota_hud_error_havent_charges"
        end

        if self:GetCaster():HasModifier("modifier_bloodrage_buff") then
            local modif = self:GetCaster():FindModifierByName("modifier_bloodrage_buff")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return "#dota_hud_error_havent_charges"
            end
        end
        return UF_SUCCESS
end

function sacrifice_revenge:OnSpellStart()
    local caster = self:GetCaster()
    local healthCost = self:GetHealthCost(self:GetLevel())

    local modif = caster:FindModifierByName("modifier_bloodrage_buff")
    modif:SetStackCount(modif:GetStackCount() - healthCost)   
    self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(),self,'modifier_sacrifice_revenge',{duration = self:GetSpecialValueFor('transformation_time')})

    EmitSoundOn("hero_bloodseeker.rupture", target)
end

modifier_sacrifice_revenge = class({
    IsHidden = function() return true end,
    GetEffectName           = function(self) return "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN end,
})


if IsServer() then
    function modifier_sacrifice_revenge:OnCreated()
        if self:GetParent():GetUnitName() == "npc_dota_hero_bloodseeker" then
            self:GetParent():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
        end
    end

    function modifier_sacrifice_revenge:OnDestroy()
        local caster = self:GetCaster()
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_sacrifice_revenge_buff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
    end
end


modifier_sacrifice_revenge_buff = class({
    IsHidden                = function() return false end,
    IsPurgable              = function() return false end,
    IsDebuff                = function() return false end,
    IsBuff                  = function() return true end,
    AllowIllusionDuplicate  = function() return true end,
    DeclareFunctions        = function() return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,

    } end,
    GetEffectName = function() return "particles/units/heroes/hero_ursa/ursa_enrage_buff_2.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    StatusEffectPriority = function() return 10 end,
    HeroEffectPriority = function() return 10 end,
})

function modifier_sacrifice_revenge_buff:OnCreated()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.base_attack_time = self:GetAbility():GetSpecialValueFor("base_attack_time")
    self.pure_damage = self:GetAbility():GetSpecialValueFor("pure_damage")
    
end

function modifier_sacrifice_revenge_buff:OnDestroy()
    if IsServer() then
        if self:GetParent():GetUnitName() == "npc_dota_hero_bloodseeker" then
            self:GetParent():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
        end
    end
end

function modifier_sacrifice_revenge_buff:GetModifierPhysicalArmorBonus()
    return self:GetParent():GetPhysicalArmorBaseValue() * 2
end


function modifier_sacrifice_revenge_buff:GetModifierProcAttack_BonusDamage_Pure()
    return self:GetParent():GetAttackDamage() * (self.pure_damage / 100)
end


function modifier_sacrifice_revenge_buff:GetModifierBaseAttackTimeConstant()
    return self.base_attack_time
end