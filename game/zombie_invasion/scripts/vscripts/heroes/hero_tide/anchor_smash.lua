LinkLuaModifier( "modifier_anchor_smash_passive", "heroes/hero_tide/anchor_smash" ,LUA_MODIFIER_MOTION_NONE )


anchor_smash_passive = class({

    GetIntrinsicModifierName = function() return "modifier_anchor_smash_passive" end
})

modifier_anchor_smash_passive = class({})

function modifier_anchor_smash_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_anchor_smash_passive:GetModifierProcAttack_Feedback()

    if RollPercentage(20) then
        local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(), -- int, your team number
        self:GetParent():GetOrigin(), -- point, center point
        nil, -- handle, cacheUnit. (not known)
        self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
        0, -- int, order filter
        false -- bool, can grow cache
        )
        for _,enemy in pairs(enemies) do
        ApplyDamage( {
        enemy = target,
        attacker = self:GetParent(),
        bonus_damage = self.bonus_damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self:GetAbility(), --Optional.
        })
        end
    end

end