LinkLuaModifier( "modifier_ring_of_corrosive", "heroes/hero_blood_hunter/ring_of_corrosive/ring_of_corrosive", LUA_MODIFIER_MOTION_NONE )

ring_of_corrosive = class({})

function ring_of_corrosive:OnSpellStart()
 
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
 
	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ring_of_corrosive", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

end 

function ring_of_corrosive:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_ring_of_corrosive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ring_of_corrosive:IsHidden()
	return false
end

function modifier_ring_of_corrosive:IsDebuff()
	return true
end

function modifier_ring_of_corrosive:IsStunDebuff()
	return false
end

function modifier_ring_of_corrosive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ring_of_corrosive:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.hp_degen  = self:GetAbility():GetSpecialValueFor( "hp_degen" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
  
	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

 	self.sound_cast = "Hero_Warlock.Upheaval"
	-- ApplyDamage(damageTable)
	EmitSoundOn( self.sound_cast, self:GetParent() )
	-- Start interval
	self:StartIntervalThink( interval )
 
		self:OnIntervalThink()
	-- precache effects
 

	-- Play effects
	self:PlayEffects()
end

function modifier_ring_of_corrosive:OnRefresh( kv )
	
end

function modifier_ring_of_corrosive:OnRemoved()
end

function modifier_ring_of_corrosive:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end
  StopSoundOn(self.sound_cast, self:GetParent())
	UTIL_Remove( self:GetParent() )
end

 


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ring_of_corrosive:OnIntervalThink()
	-- find enemies 
	--[[]]
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	 
	for _,enemy in pairs(enemies) do
		-- damage
	-- precache damage
 local damage_tick = ((self.damage * (self:GetParent():GetBaseDamageMax() * 3)) * self:GetAbility():GetSpecialValueFor( "tick_rate" ))
	local damageTable = {
		victim = enemy,
		attacker = self:GetCaster(),
		damage = damage_tick,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
 
	 
		ApplyDamage(  damageTable )
 
		-- play effects
 
	end
end
 

function modifier_ring_of_corrosive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_ring_of_corrosive:GetModifierHPRegenAmplify_Percentage()  
	return -self.hp_degen
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ring_of_corrosive:IsAura()
	return self.thinker
end

function modifier_ring_of_corrosive:GetModifierAura()
	return "modifier_ring_of_corrosive"
end

function modifier_ring_of_corrosive:GetAuraRadius()
	return self.radius
end

function modifier_ring_of_corrosive:GetAuraDuration()
	return 0.5
end

function modifier_ring_of_corrosive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ring_of_corrosive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ring_of_corrosive:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
 
function modifier_ring_of_corrosive:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring_lv.vpcf"
 

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	local particle_cast2 = "particles/units/heroes/hero_bloodseeker/bloodseeker_spell_bloodbath_bubbles_.vpcf"
 

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
 
end