pudge_rot_passive_wave = class({})

function pudge_rot_passive_wave:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

pudge_rot_passive_wave_2 = class({})

function pudge_rot_passive_wave_2:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf",
	}, {
		"Hero_Pudge.Rot",
	}, context)
end

LinkLuaModifier( "modifier_pudge_rot_passive_wave", "abilities/zombie/pudge_rot_passive_wave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_rot_passive_wave_debuff", "abilities/zombie/pudge_rot_passive_wave", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pudge_rot_passive_wave:GetIntrinsicModifierName()
	return "modifier_pudge_rot_passive_wave"
end

function pudge_rot_passive_wave_2:GetIntrinsicModifierName()
	return "modifier_pudge_rot_passive_wave"
end
 
--------------------------------------------------------------------------------

modifier_pudge_rot_passive_wave = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
})


 
--------------------------------------------------------------------------------

function modifier_pudge_rot_passive_wave:IsAura()
	return true
end

function modifier_pudge_rot_passive_wave:GetModifierAura()
	return "modifier_pudge_rot_passive_wave_debuff"
end

function modifier_pudge_rot_passive_wave:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_pudge_rot_passive_wave:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_pudge_rot_passive_wave:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_passive_wave:GetAuraRadius()
	return self.rot_radius
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_passive_wave:OnCreated( kv )
	self.rot_radius = self:GetAbility():GetSpecialValueFor( "rot_radius" )
 
 

	if IsServer() then
		if self:GetParent() == self:GetCaster() then
			EmitSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.rot_radius, 1, self.rot_radius ) )
			self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		end
       
       self:OnIntervalThink()
       self:StartIntervalThink(1)
	end
end


function modifier_pudge_rot_passive_wave:OnIntervalThink()
    if not self:GetParent():IsAlive() then 
		StopSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
		ParticleManager:DestroyParticle(self.nFXIndex, true)
    end
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_passive_wave:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
		ParticleManager:DestroyParticle(self.nFXIndex, true)
	end
end
         
 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


modifier_pudge_rot_passive_wave_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
 
        } end,
})

function modifier_pudge_rot_passive_wave_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.rot_slow
end

function modifier_pudge_rot_passive_wave_debuff:GetModifierHPRegenAmplify_Percentage()  
	return -self.rot_hp_degen
end

function modifier_pudge_rot_passive_wave_debuff:OnCreated()
	self.rot_tick = self:GetAbility():GetSpecialValueFor( "rot_tick" )
	self.rot_slow = self:GetAbility():GetSpecialValueFor( "rot_slow" )
	self.rot_damage = self:GetAbility():GetSpecialValueFor( "rot_damage" )
	self.rot_hp_degen = self:GetAbility():GetSpecialValueFor( "rot_hp_degen" )


	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( nFXIndex, false, false, -1, false, false )

	self:StartIntervalThink( self.rot_tick )
	self:OnIntervalThink()
end

function modifier_pudge_rot_passive_wave_debuff:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self.rot_tick * self.rot_damage

		if self:GetCaster():IsAlive() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = flDamagePerTick,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility()
			}

			ApplyDamage( damage )
		end
	end
end