sky_bolt = class({})



function sky_bolt:OnSpellStart()
    print("hi")
    local caster = self:GetCaster()
	local unit = self:GetCursorTarget()
    --local targets = event.target_entities
	local ability = self
    local effect = "particles/econ/items/skywrath_mage/skywrath_mage_weapon_empyrean/skywrath_mystic_flare_hit_sword_gold.vpcf"
    ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, unit)
    local effect1 = "particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf"
    ParticleManager:CreateParticle(effect1, PATTACH_OVERHEAD_FOLLOW, unit)

    local dmg = ability:GetSpecialValueFor("damage")
    print("P : ", dmg)

    local damageTable = {
    victim = unit,
    attacker = caster,
    damage = dmg,
    damage_type = self:GetAbilityDamageType()
    }
    ApplyDamage(damageTable)
end


