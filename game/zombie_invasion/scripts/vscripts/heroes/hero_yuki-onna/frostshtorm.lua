 LinkLuaModifier( "modifier_froststorm_buff", "heroes/hero_yuki-onna/frostshtorm", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_froststorm_thunker", "heroes/hero_yuki-onna/frostshtorm", LUA_MODIFIER_MOTION_NONE )


 yuki_frostshtorm = {}

function yuki_frostshtorm:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function yuki_frostshtorm:OnSpellStart()
 	local target = self:GetCursorTarget()
 
 	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_froststorm_thunker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

 	EmitSoundOn( 'Hero_Ancient_Apparition.IceVortexCast', caster )

end


 modifier_froststorm_thunker = class({
 	IsHidden 				= function(self) return false end,
 	IsPurgable 				= function(self) return false end,
 	IsDebuff 				= function(self) return false end,
 	IsBuff                  = function(self) return true end,
 	RemoveOnDeath 			= function(self) return false end,
 
 })

function modifier_froststorm_thunker:OnCreated()
	local particle_cast = "particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf"
    
    self.radius_shadow = self:GetAbility():GetSpecialValueFor("radius")
	local caster = self:GetCaster()

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
 

	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 5, Vector( self.radius_shadow, 0, 0 ) )
 	EmitSoundOn("Hero_Ancient_Apparition.IceVortex", self:GetParent())
end
 
function modifier_froststorm_thunker:OnDestroy()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	 	StopSoundOn("Hero_Ancient_Apparition.IceVortex", self:GetParent())

end

function modifier_froststorm_thunker:IsAura()
	return true
end

function modifier_froststorm_thunker:GetModifierAura()
	return "modifier_froststorm_buff"
end

function modifier_froststorm_thunker:GetAuraRadius()
	return self.radius_shadow
end

function modifier_froststorm_thunker:GetAuraDuration()
	return 0.1
end

function modifier_froststorm_thunker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_froststorm_thunker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_froststorm_thunker:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end
 
 modifier_froststorm_buff = class({
 	IsHidden 				= function(self) return false end,
 	IsPurgable 				= function(self) return false end,
 	IsDebuff 				= function(self) return false end,
 	IsBuff                  = function(self) return true end,
 	RemoveOnDeath 			= function(self) return true end,
     DeclareFunctions        = function(self) return 
         {
 			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
         } end,
 
 })

 function modifier_froststorm_buff:GetModifierPreAttack_BonusDamage()
 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
 		return self:GetAbility():GetSpecialValueFor("dmg_reduced")
 	else 
 		return -self:GetAbility():GetSpecialValueFor("dmg_reduced")
 	end
 end