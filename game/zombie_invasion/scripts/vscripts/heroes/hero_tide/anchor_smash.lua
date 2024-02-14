LinkLuaModifier( "modifier_anchor_smash_passive", "heroes/hero_tide/anchor_smash" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_anchor_smash_passive_reduction", "heroes/hero_tide/anchor_smash" ,LUA_MODIFIER_MOTION_NONE )

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

function modifier_anchor_smash_passive:OnCreated()
    self.smash_damage = self:GetAbility():GetSpecialValueFor("smash_damage")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
end 

function modifier_anchor_smash_passive:OnRefresh()
    self.smash_damage = self:GetAbility():GetSpecialValueFor("smash_damage")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
end 

function modifier_anchor_smash_passive:GetModifierProcAttack_Feedback()

    if RollPercentage(self.chance) then
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
        victim = enemy,
        attacker = self:GetParent(),
        damage = self.smash_damage + self:GetCaster():GetAttackDamage() + (self:GetCaster():GetStrength() * (70 / 100)),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
        })

        enemy:AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_anchor_smash_passive_reduction', {
        duration = self:GetAbility():GetSpecialValueFor("duration"),
        })
        end
 
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())

            EmitSoundOn("Hero_Tidehunter.AnchorSmash", self:GetParent())
        end

    end

    modifier_anchor_smash_passive_reduction = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_anchor_smash_passive_reduction:OnCreated()
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")

    if IsServer() then
        self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(self.fx, false, false, -1, false, false)
    end
end

function modifier_anchor_smash_passive_reduction:OnRefresh()
    self:OnCreated()
end

function modifier_anchor_smash_passive_reduction:GetModifierPhysicalArmorBonus() return self.armor_reduction end