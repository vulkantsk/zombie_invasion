shield_crush = class({
     GetIntrinsicModifierName = function() return "modifier_shield_crush_buff" end
})

function shield_crush:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_stunned.vpcf",
		"particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf",
		"particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
	}, {
		"Hero_DragonKnight.DragonTail.Cast",
		"Hero_DragonKnight.DragonTail.Target",
	}, context)
end


LinkLuaModifier( "modifier_shield_crush", "heroes/hero_dragon_knight/shield_crush/shield_crush", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shield_crush_buff", "heroes/hero_dragon_knight/shield_crush/shield_crush", LUA_MODIFIER_MOTION_NONE )

function shield_crush:GetCastRange( vLocation, hTarget )
   
        return self.BaseClass.GetCastRange( self, vLocation, hTarget )

end

function shield_crush:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if not modifier then
        if target:TriggerSpellAbsorb( self ) then return end

        self:Hit( target, false )

        EmitSoundOn( "Hero_DragonKnight.DragonTail.Cast", caster )

        return
    end
    


    local info = {
        Target = target,
        Source = caster,
        Ability = self,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
        EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
        iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
        bDodgeable = true,
        }
    ProjectileManager:CreateTrackingProjectile(info)
end

function shield_crush:Hit( target, dragonform )
    local caster = self:GetCaster()

    if target:TriggerSpellAbsorb( self ) then return end

    local damage = self:GetSpecialValueFor( "damage" ) + (self:GetSpecialValueFor( "pct_damage" ) * self:GetCaster():GetPhysicalArmorValue(false))
    local duration = self:GetSpecialValueFor( "stun_duration" )

    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self,
    }

    ApplyDamage(damageTable)

    target:AddNewModifier(
        caster,
        self,
        "modifier_shield_crush",
        { duration = duration }
    )

    self:PlayEffects( target, dragonform )
    EmitSoundOn( "Hero_DragonKnight.DragonTail.Target", target )
end

function shield_crush:OnProjectileHit( target, location )
    if not target then return end

    self:Hit( target, true )
end

function shield_crush:PlayEffects( target, dragonform )
    local vec = target:GetOrigin()-self:GetCaster():GetOrigin()
    local attach = "attach_attack1"
    if dragonform then
        attach = "attach_attack2"
    end

    local effect_cast = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:SetParticleControl( effect_cast, 3, vec )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        2,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        attach,
        Vector(0,0,0),
        true 
    )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        4,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0),
        true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_shield_crush_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions        = function(self) return 
            {
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
            } end,
})

function modifier_shield_crush_buff:OnCreated()
    self.damage_resistance = self:GetAbility():GetSpecialValueFor("damage_resistance")
    
end

function modifier_shield_crush_buff:OnRefresh()
    self:OnCreated()
end 

function modifier_shield_crush_buff:GetModifierIncomingDamage_Percentage()
    return -self.damage_resistance
end


modifier_shield_crush = class({})


function modifier_shield_crush:IsDebuff()
    return true
end

function modifier_shield_crush:IsStunDebuff()
    return true
end

function modifier_shield_crush:IsPurgable()
    return true
end

function modifier_shield_crush:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_shield_crush:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_shield_crush:GetOverrideAnimation( params )
    return ACT_DOTA_DISABLED
end

function modifier_shield_crush:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_shield_crush:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end