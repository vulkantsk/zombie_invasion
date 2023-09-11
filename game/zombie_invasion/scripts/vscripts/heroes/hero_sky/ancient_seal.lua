if ancient_seal == nil then
    ancient_seal = class({})
end

--------------------------------------------------------------------------------

function ancient_seal:ApplyStaticField(target)
    local caster = self:GetCaster()
    if not caster:PassivesDisabled() then
        local damage = target:GetHealth() / 100 * self:GetSpecialValueFor("damage_health_pct")

        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
            ability = self
        })
    end
end