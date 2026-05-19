thunder_smash = class({})

function thunder_smash:Precache(context)
	PrecacheAbilityResources({
		"particles/thunder_smash.vpcf",
	}, {
		"Hero_invoker.emp.cast",
		"Hero_invoker.emp.discharge",
	}, context)
end

LinkLuaModifier('modifier_thunder_smash_debuff', 'heroes/hero_dragon_knight/thunder_smash/thunder_smash', LUA_MODIFIER_MOTION_NONE)

function thunder_smash:OnSpellStart()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("radius")
    local duration_creeps = self:GetSpecialValueFor("duration_creeps")
    local duration = self:GetSpecialValueFor("duration")
    local damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetAttackDamage() * 3
    local movement_slow = self:GetSpecialValueFor("movement_slow")
    local attack_speed_slow = self:GetSpecialValueFor("attack_speed_slow")

    local clap_particle = ParticleManager:CreateParticle("particles/thunder_smash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(clap_particle, 1, Vector(radius,radius,radius))
    ParticleManager:ReleaseParticleIndex(clap_particle)
    
    local units =  FindUnitsInRadius(caster:GetTeamNumber(),
    caster:GetAbsOrigin(), 
    nil, 
    radius, 
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
    FIND_ANY_ORDER, 
    false)

    self:GetCaster():EmitSound("Hero_invoker.emp.discharge")

    for k,v in pairs(units) do 

        ApplyDamage({
            victim = v,
            attacker = caster,
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self,
        })
        v:EmitSound("Hero_invoker.emp.cast")
        v:AddNewModifier(caster, self, 'modifier_thunder_smash_debuff', {
            duration = v:IsCreep() and duration_creeps or duration,
            reduction_movespeed = -movement_slow,
            reduction_attackspeed = -attack_speed_slow,
        })

    end 
end


modifier_thunder_smash_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end,
    GetModifierMoveSpeedBonus_Percentage = function(self) return self.reduction_movespeed end,
    GetModifierAttackSpeedBonus_Constant = function(self) return self.reduction_attackspeed end,
})

function modifier_thunder_smash_debuff:OnCreated(data)
    self.reduction_movespeed = data.reduction_movespeed
    self.reduction_attackspeed = data.reduction_attackspeed
end 