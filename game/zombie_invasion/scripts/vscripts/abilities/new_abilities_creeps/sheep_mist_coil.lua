ability_mist_coil = class({})

function ability_mist_coil:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
	}, {
		"Hero_Abaddon.DeathCoil.Cast",
		"Hero_Abaddon.DeathCoil.Target",
	}, context)
end


function ability_mist_coil:CastFilterResultTarget(hTarget)
    if hTarget == self:GetCaster() then
        return UF_FAIL_CUSTOM
    end

    return UF_SUCCESS
end

function ability_mist_coil:GetCustomCastErrorTarget()
    return 'dota_hud_error_cant_cast_on_self'
end

function ability_mist_coil:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    caster:EmitSound('Hero_Abaddon.DeathCoil.Cast')
    
    ApplyDamage({
        victim = caster,
        attacker = caster,
        damage = self:GetSpecialValueFor('self_damage'),
        damage_type = self:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
        ability = self,
    })

    ProjectileManager:CreateTrackingProjectile({
        Target = target,
        Source = caster,
        Ability = self, 
        EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
        iMoveSpeed = self:GetSpecialValueFor('missile_speed'),
        vSourceLoc= caster:GetAbsOrigin(),
        bDodgeable = false,
    })
end

function ability_mist_coil:OnProjectileHit(hTarget, vLocation)
    if not hTarget then return end
    if hTarget:IsNull() then return end
    if not IsServer() then return end

    if hTarget:IsAlive() then
        hTarget:EmitSound('Hero_Abaddon.DeathCoil.Target')

        if hTarget:GetTeam() ~= self:GetCaster():GetTeam() then 
            if not self:GetCaster():IsNull() then
                ApplyDamage({
                    victim = hTarget,
                    attacker = self:GetCaster(),
                    damage = self:GetSpecialValueFor('target_damage'),
                    damage_type = self:GetAbilityDamageType(),
                    damage_flags = DOTA_DAMAGE_FLAG_NONE,
                    ability = self,
                })
            end
            return true
        end

        if not self:GetCaster():IsNull() then
            hTarget:Heal(self:GetSpecialValueFor('heal_amount'), self)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hTarget, self:GetSpecialValueFor('heal_amount'), nil)
        end
    end
end