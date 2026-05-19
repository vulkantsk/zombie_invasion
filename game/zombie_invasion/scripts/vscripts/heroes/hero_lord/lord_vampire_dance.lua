require("heroes/hero_lord/lord_blood_helpers")

LinkLuaModifier("modifier_lord_vampire_dance", "heroes/hero_lord/lord_vampire_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_vampire_dance_before", "heroes/hero_lord/lord_vampire_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_vampire_dance_atr", "heroes/hero_lord/lord_vampire_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_vampire_dance_passive", "heroes/hero_lord/lord_vampire_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_vampire_dance = class({})

function lord_vampire_dance:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_lifesteal.vpcf",
		"particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf",
		"particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf",
	}, {
		"Hero_Juggernaut.BladeDance",
		"blood_rage",
		"dance",
	}, context)
end


function lord_vampire_dance:GetIntrinsicModifierName()
    return "modifier_lord_vampire_dance_passive"
end

function lord_vampire_dance:CastFilterResultTarget()
	if not LordAbilityHasEnoughBlood(self, self:GetLevel() - 1) then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function lord_vampire_dance:GetCustomCastErrorTarget()
	if not LordAbilityHasEnoughBlood(self, self:GetLevel() - 1) then
		return "#dota_hud_error_havent_charges"
	end
end 
  
function lord_vampire_dance:OnSpellStart()
    self.target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local healthCost = self:GetHealthCost(self:GetLevel() - 1)
    local modif = GetLordBloodRageModifier(caster)

    PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "alucard_begin", {})
    caster:AddNewModifier(caster,self,"modifier_lord_vampire_dance_before", {duration = 16})
    if modif then
        modif:SetStackCount(modif:GetStackCount() - healthCost)
    end
    EmitSoundOn("dance" , caster)
end


 modifier_lord_vampire_dance_before = class({
     IsHidden                 = function(self) return true end,
     IsPurgable                 = function(self) return false end,
     IsDebuff                 = function(self) return false end,
     IsBuff                  = function(self) return true end,
     RemoveOnDeath             = function(self) return false end,
         DeclareFunctions        = function(self) return 
        {
     MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
                                MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
                    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
                    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,

        } end,
      CheckState      = function(self) return 
         {
            [MODIFIER_STATE_STUNNED] = true, 

         } end,
 })
 
 

function modifier_lord_vampire_dance_before:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_lord_vampire_dance_before:GetAbsoluteNoDamageMagical()
    return 1
end


function modifier_lord_vampire_dance_before:GetAbsoluteNoDamagePhysical()
    return 1
end
 
function modifier_lord_vampire_dance_before:OnDestroy()
        self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_lord_vampire_dance", {duration = self:GetAbility():GetSpecialValueFor("duration")})
        self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_lord_vampire_dance_atr", {duration = 20})

end


 modifier_lord_vampire_dance = class({
     IsHidden                 = function(self) return false end,
     IsPurgable                 = function(self) return false end,
     IsDebuff                 = function(self) return false end,
     IsBuff                  = function(self) return true end,
     RemoveOnDeath             = function(self) return false end,
             DeclareFunctions        = function(self) return 
        {
     MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

        } end,
     CheckState      = function(self) return 
        {
          [MODIFIER_STATE_INVULNERABLE] = true,
        } end,
 })
 
function modifier_lord_vampire_dance:GetModifierPreAttack_BonusDamage()
    return 1000000
end

function modifier_lord_vampire_dance:OnCreated()
    local caster = self:GetCaster()
    local target = self:GetAbility().target
    local pos = target:GetAbsOrigin()
    local ability = self:GetAbility()
    self.origin = caster:GetAbsOrigin()
    caster:AddNoDraw()

    local random_pos = pos + Vector(RandomInt(-200,200),RandomInt(-200,200),0)
    caster:SetAbsOrigin(random_pos)
    caster:PerformAttack(target, true, true, true, true, true, false, false)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "alucard_camera", {})

    self:StartIntervalThink(ability:GetSpecialValueFor("interval"))
end

function modifier_lord_vampire_dance:OnRemoved()
    local caster = self:GetCaster()
    caster:Stop()
    caster:RemoveNoDraw()
    caster:SetAbsOrigin(self.origin)
    PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "camera_comback", {})
end


function modifier_lord_vampire_dance:OnIntervalThink()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local ability = self:GetAbility()
    local radius = ability:GetSpecialValueFor("radius")
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local enemy_count = 0
    for _,unit in ipairs(units) do
        enemy_count = enemy_count + 1
    end

    if enemy_count <= 0 then
        caster:RemoveModifierByName("modifier_lord_vampire_dance")
    end
    local random = RandomInt(1, enemy_count)
    local target = units[random]
    local target_pos = target:GetAbsOrigin()
    local random_pos = target_pos + Vector(RandomInt(-200,200),RandomInt(-200,200),0)
    caster:SetAbsOrigin(random_pos)
        ScreenShake( self:GetParent():GetOrigin(), 10000.0, 13000.0, 3, 20000.0, 0, true )
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "alucard_yaw", {})

    caster:PerformAttack(target, true, true, true, true, true, false, false)
end
 


 

modifier_lord_vampire_dance_passive = class({
    IsHidden                 = function(self) return true end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return false end,
     DeclareFunctions        = function(self) return 
         {
             MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
            MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
         } end,
})


function modifier_lord_vampire_dance_passive:GetModifierPreAttack_CriticalStrike( params )
        if GameRules:IsDaytime() then return end

        if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
            return
        end

        -- Throw dice
        if RandomInt(0, 100)< self:GetAbility():GetSpecialValueFor("crit_chance") then
            self.record = params.record
            return self:GetAbility():GetSpecialValueFor("crit_pct")
        end
end
function modifier_lord_vampire_dance_passive:GetModifierProcAttack_Feedback( params )
    if GameRules:IsDaytime() then return end
        if self.record and self.record == params.record then
            self.record = nil

            -- Play effects
            local sound_cast = "Hero_Juggernaut.BladeDance"
            EmitSoundOn( sound_cast, params.target )
        end
end


modifier_lord_vampire_dance_atr = class({
    IsHidden                 = function(self) return false end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        } end,
})

function modifier_lord_vampire_dance_atr:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_stat")
end 

function modifier_lord_vampire_dance_atr:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_stat")
end 

function modifier_lord_vampire_dance_atr:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_stat")
end 