LinkLuaModifier( "modifier_warlock_splesh", "abilities/zombie/Boss/warlock_splesh", LUA_MODIFIER_MOTION_NONE )
warlock_splesh = class({})
 

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function warlock_splesh:OnSpellStart()
 
 	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
 
	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_warlock_splesh", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

end 

function warlock_splesh:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_warlock_splesh = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_warlock_splesh:IsHidden()
	return false
end

function modifier_warlock_splesh:IsDebuff()
	return true
end

function modifier_warlock_splesh:IsStunDebuff()
	return false
end

function modifier_warlock_splesh:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_warlock_splesh:OnCreated( kv )
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

function modifier_warlock_splesh:OnRefresh( kv )
	
end

function modifier_warlock_splesh:OnRemoved()
end

function modifier_warlock_splesh:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end
  StopSoundOn(self.sound_cast, self:GetParent())
	UTIL_Remove( self:GetParent() )
end

 


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_warlock_splesh:OnIntervalThink()
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
 local damage_tick = self.damage * self:GetAbility():GetSpecialValueFor( "tick_rate" )
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
 

function modifier_warlock_splesh:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_warlock_splesh:GetModifierHPRegenAmplify_Percentage()  
	return -self.hp_degen
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_warlock_splesh:IsAura()
	return self.thinker
end

function modifier_warlock_splesh:GetModifierAura()
	return "modifier_warlock_splesh"
end

function modifier_warlock_splesh:GetAuraRadius()
	return self.radius
end

function modifier_warlock_splesh:GetAuraDuration()
	return 0.5
end

function modifier_warlock_splesh:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_warlock_splesh:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_warlock_splesh:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
 
function modifier_warlock_splesh:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_warlock/warlock_upheaval.vpcf"
 

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
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