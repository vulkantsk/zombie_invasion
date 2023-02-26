slark_shadow_dance_lua = class({})
LinkLuaModifier( "modifier_slark_shadow_dance_lua", "heroes/hero_slark/shadow_dance/slark_shadow_dance_lua", LUA_MODIFIER_MOTION_NONE )
 
--------------------------------------------------------------------------------
-- Ability Start
function slark_shadow_dance_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_shadow_dance_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
end

modifier_slark_shadow_dance_lua = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        } end,
    CheckState      = function(self) return 
        {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,          
        } end,
})
 

---------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua:OnCreated( kv )
 
     self.bonus_regen_pct = self:GetAbility():GetSpecialValueFor("bonus_regen_pct")
     self.bonus_bat = self:GetAbility():GetSpecialValueFor("bonus_bat")

	-- generate data
	self.parent = self:GetParent()==self:GetCaster()
 
	if not IsServer() then return end
	self:PlayEffects1()
	self:PlayEffects2()

	self:StartIntervalThink(FrameTime())
end

function modifier_slark_shadow_dance_lua:OnRefresh( kv )
    
    self.bonus_regen_pct = self:GetAbility():GetSpecialValueFor("bonus_regen_pct")
    self.bonus_bat = self:GetAbility():GetSpecialValueFor("bonus_bat")
	-- generate data
	self.parent = self:GetParent()==self:GetCaster()
	 
end

 
function modifier_slark_shadow_dance_lua:GetModifierInvisibilityLevel()
	return 2
end

function modifier_slark_shadow_dance_lua:GetModifierBaseAttackTimeConstant()
	return self.bonus_bat
end



function modifier_slark_shadow_dance_lua:GetModifierHPRegenAmplify_Percentage()  
	return self.bonus_regen_pct
end

function modifier_slark_shadow_dance_lua:OnDestroy( kv )
	if IsServer() then
		local sound_cast = "Hero_Slark.ShadowDance"
		StopSoundOn( sound_cast, self:GetParent() )
	end
end
 
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_slark_shadow_dance_lua:OnIntervalThink()
	ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetOrigin() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_shadow_dance_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_slark_shadow_dance_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_slark_shadow_dance_lua:PlayEffects1()
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

function modifier_slark_shadow_dance_lua:PlayEffects2()
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