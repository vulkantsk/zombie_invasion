false_promise_custom = class({})



function false_promise_custom:OnSpellStart()
    print("hi")
    local caster = self:GetCaster()
	local unit = self:GetCursorTarget()
    --local targets = event.target_entities
	local ability = self
    local effect = "particles/units/heroes/hero_oracle/oracle_purifyingflames_head.vpcf"
    ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, unit)
    local effect1 = "particles/units/heroes/hero_oracle/oracle_purifyingflames_flash_elec.vpcf"
    ParticleManager:CreateParticle(effect1, PATTACH_OVERHEAD_FOLLOW, unit)

    local intint = ability:GetSpecialValueFor("bonus_int_damage")
    local min_dmg = ability:GetSpecialValueFor("min_damage") + intint * caster:GetIntellect(true) 
    local max_dmg = ability:GetSpecialValueFor("max_damage") + intint * caster:GetIntellect(true) 
    local dmg = RandomInt(min_dmg, max_dmg)

    
    --local damage_bonus = ability:GetSpecialValueFor("bonus_int_damage") * caster:GetIntellect()
    --local damage = dmg + damage_bonus 
    --print("A : ",damage_bonus)



    local damageTable = {
    victim = unit,
    attacker = caster,
    damage = dmg,
    damage_type = self:GetAbilityDamageType()
    }
    ApplyDamage(damageTable)
end


