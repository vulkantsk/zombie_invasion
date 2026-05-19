ancient_seal = class({})

function ancient_seal:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf",
	}, {
	}, context)
end

LinkLuaModifier( "modifier_ancient_seal_passive", "heroes/hero_sky/ancient_seal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ancient_seal_debuff", "heroes/hero_sky/ancient_seal", LUA_MODIFIER_MOTION_NONE )

function ancient_seal:GetIntrinsicModifierName()
    return 'modifier_ancient_seal_passive'
end


modifier_ancient_seal_passive = class({
    IsHidden    = function() return true end,
    IsPermanent     = function(self) return true end,

    DeclareFunctions    = function(self)
        return {
            MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
            MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        }
    end,
    GetModifierPercentageCooldown = function(self) return self.reductionCooldown end,
})

function modifier_ancient_seal_passive:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.reductionCooldown = self.ability:GetSpecialValueFor('cooldown_reduction')
    self.radius = self.ability:GetSpecialValueFor('radius')
    self.duration = self.ability:GetSpecialValueFor('duration')
end

function modifier_ancient_seal_passive:OnRefresh()
    self:OnCreated()
end

function modifier_ancient_seal_passive:OnAbilityFullyCast(keys)
    if keys.ability and keys.unit == self.parent and not self.parent:PassivesDisabled() and not keys.ability:IsItem() then

        local enemies = FindUnitsInRadius(
            keys.unit:GetTeamNumber(),  -- int, your team number
            keys.unit:GetOrigin(),  -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            self.radius,    -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_NONE, -- int, flag filter
            FIND_ANY_ORDER, -- int, order filter
            false   -- bool, can grow cache
        )

        for k,v in pairs(enemies) do 
            v:AddStackModifier({
                ability = self.ability,
                modifier = 'modifier_ancient_seal_debuff',
                updateStack = true,
                duration = self.duration,
                caster = keys.unit,
            })
        end 

    end
end


modifier_ancient_seal_debuff = class({
    DeclareFunctions    = function(self)
        return {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        }
    end,
    GetModifierPhysicalArmorBonus = function(self) return self.armor * self:GetStackCount() end,
})

function modifier_ancient_seal_debuff:OnCreated()
    self.armor = -self:GetAbility():GetSpecialValueFor('armor_reduction')

    self.nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.nfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.nfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

function modifier_ancient_seal_debuff:OnDestroy() 
    if self.nfx then 
        ParticleManager:DestroyParticle(self.nfx, false)
        ParticleManager:ReleaseParticleIndex(self.nfx)
    end 
end

function modifier_ancient_seal_debuff:OnRefresh()
    self.armor = -self:GetAbility():GetSpecialValueFor('armor_reduction')
end