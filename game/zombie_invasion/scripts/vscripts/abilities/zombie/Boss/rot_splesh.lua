LinkLuaModifier( "modifier_rot_splash", "abilities/zombie/Boss/rot_splesh", LUA_MODIFIER_MOTION_NONE )
rot_splesh = class({})

function rot_splesh:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
	}, {
		"Hero_Alchemist.AcidSpray",
		"Hero_Pudge.Rot",
	}, context)
end

 

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function rot_splesh:OnSpellStart()
 
 	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
 
	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_rot_splash", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

end 

function rot_splesh:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_rot_splash = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_rot_splash:IsHidden()
	return false
end

function modifier_rot_splash:IsDebuff()
	return true
end

function modifier_rot_splash:IsStunDebuff()
	return false
end

function modifier_rot_splash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rot_splash:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.move_speed  = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

 	self.sound_cast = "Hero_Pudge.Rot"
	-- ApplyDamage(damageTable)
	EmitSoundOn( self.sound_cast, self:GetParent() )
	-- Start interval
	self:StartIntervalThink( interval )
 
		self:OnIntervalThink()
	-- precache effects
 

	-- Play effects
	self:PlayEffects()
end

function modifier_rot_splash:OnRefresh( kv )
	
end

function modifier_rot_splash:OnRemoved()
end

function modifier_rot_splash:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end
  StopSoundOn(self.sound_cast, self:GetParent())
	UTIL_Remove( self:GetParent() )
end

 


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rot_splash:OnIntervalThink()
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
 print(#enemies)
		-- play effects
 
	end
end

function modifier_rot_splash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_rot_splash:GetModifierMoveSpeedBonus_Percentage()
	return -(self.move_speed)
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_rot_splash:IsAura()
	return self.thinker
end

function modifier_rot_splash:GetModifierAura()
	return "modifier_rot_splash"
end

function modifier_rot_splash:GetAuraRadius()
	return self.radius
end

function modifier_rot_splash:GetAuraDuration()
	return 0.5
end

function modifier_rot_splash:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_rot_splash:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_rot_splash:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
 
function modifier_rot_splash:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pudge/pudge_rot.vpcf"
	local sound_cast = "Hero_Alchemist.AcidSpray"

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

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end