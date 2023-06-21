ability_reincarnation = {}

LinkLuaModifier( "modifier_ability_reincarnation", "abilities/quest/phoenix/reincarnation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_reincarnation_debuff", "abilities/quest/phoenix/reincarnation", LUA_MODIFIER_MOTION_NONE )

function ability_reincarnation:GetIntrinsicModifierName()
    return "modifier_ability_reincarnation"
end


modifier_ability_reincarnation = {}

function modifier_ability_reincarnation:IsHidden()
    return true
end

function modifier_ability_reincarnation:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_REINCARNATION
    }
end

function modifier_ability_reincarnation:ReincarnateTime( params )
    if IsServer() then
        if self:GetAbility():IsFullyCastable() then
            self:Reincarnate()

            return self:GetAbility():GetSpecialValueFor( "reincarnate_time" )
        end

        return 0
    end
end

function modifier_ability_reincarnation:Reincarnate()
    self:GetAbility():UseResources( true, false, true )

 

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( self:GetAbility():GetSpecialValueFor( "reincarnate_time" ), 0, 0 ) )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( "Hero_SkeletonKing.Reincarnate", self:GetParent() )
end
 