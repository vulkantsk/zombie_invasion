 function DurationTarget( keys )
    local target = keys.target
    local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration_talent", (ability:GetLevel()) - 1)
    local dur = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel()) - 1)
    local modifier = keys.modifier
    local talent = keys.talent
    if caster:FindAbilityByName(talent):GetLevel() == 1 then
        ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration})
    else
        ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = dur})
    end
end