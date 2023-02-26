slark_shadow_dance_boss = class({})
LinkLuaModifier( "modifier_slark_shadow_dance_boss", "abilities/monsters/slark_shadow_dance_boss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_shadow_dance_boss_passive", "abilities/monsters/slark_shadow_dance_boss", LUA_MODIFIER_MOTION_NONE )

 
 
--------------------------------------------------------------------------------
-- Ability Start
function slark_shadow_dance_boss:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_shadow_dance_boss", -- modifier name
		{ duration = bDuration } -- kv
	)
end
 
modifier_slark_shadow_dance_boss = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    GetPriority             = function(self) return MODIFIER_PRIORITY_HIGH end,    
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
    CheckState      = function(self) return 
        {          
            [MODIFIER_STATE_INVISIBLE] = true, 
            [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true, 
        } end,
})
 
 
--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_boss:OnCreated( kv )
	-- references
 
	-- generate data
	self.parent = self:GetParent()==self:GetCaster()
	self.scepter = self.parent and self:GetCaster():HasScepter()

	if not IsServer() then return end
	self:PlayEffects1()
	self:PlayEffects2()

	self:StartIntervalThink(FrameTime())
end

function modifier_slark_shadow_dance_boss:OnRefresh( kv )
	-- references
 
	
	-- generate data
	self.parent = self:GetParent()==self:GetCaster()
	self.scepter = self.parent and self:GetCaster():HasScepter()
end

function modifier_slark_shadow_dance_boss:OnDestroy( kv )
	if IsServer() then
		local sound_cast = "Hero_Slark.ShadowDance"
		StopSoundOn( sound_cast, self:GetParent() )
	end
end
 
function slark_shadow_dance_boss:GetModifierInvisibilityLevel()
	return 2
end
 
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_slark_shadow_dance_boss:OnIntervalThink()
	ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetOrigin() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_shadow_dance_boss:GetStatusEffectName()
	return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_slark_shadow_dance_boss:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_slark_shadow_dance_boss:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
	local sound_cast = "Hero_Slark.ShadowDance"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent, parent:GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		parent,
		PATTACH_POINT_FOLLOW,
		"attach_eyeR",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		parent,
		PATTACH_POINT_FOLLOW,
		"attach_eyeL",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	EmitSoundOn( sound_cast, parent )
	-- self.effect_cast = effect_cast
end

function modifier_slark_shadow_dance_boss:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self.effect_cast = effect_cast
end