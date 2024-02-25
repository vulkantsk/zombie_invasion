--------------------------------------------------------------------------------
slark_pounce_lua = class({})
LinkLuaModifier( "modifier_slark_pounce_lua", "heroes/hero_slark/pounce/slark_pounce_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_slark_pounce_shadow_thinker", "heroes/hero_slark/pounce/slark_pounce_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_modifier_slark_pounce_shadow_heal", "heroes/hero_slark/pounce/slark_pounce_lua", LUA_MODIFIER_MOTION_BOTH )

LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
 -------------------------------------------------------------------------
 
 

--------------------------------------------------------------------------------
-- Ability Start
function slark_pounce_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- pounce
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_pounce_lua", -- modifier name
		{} -- kv
	)
    
 
	-- play effects
    self:GetCaster():StartGesture( ACT_DOTA_SLARK_POUNCE )
	local sound_cast = "Hero_Slark.Pounce.Cast"
	EmitSoundOn( sound_cast, caster )
end

 
 
--------------------------------------------------------------------------------
modifier_slark_pounce_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_pounce_lua:IsHidden()
	return false
end

function modifier_slark_pounce_lua:IsDebuff()
	return false
end

function modifier_slark_pounce_lua:IsStunDebuff()
	return false
end

function modifier_slark_pounce_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_pounce_lua:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	local speed = self:GetAbility():GetSpecialValueFor( "pounce_speed" )
	local distance = self:GetAbility():GetSpecialValueFor( "pounce_distance" )
	

	self.radius = self:GetAbility():GetSpecialValueFor( "pounce_radius" )
	self.leash_radius = self:GetAbility():GetSpecialValueFor( "leash_radius" )
	self.shadow_duration = self:GetAbility():GetSpecialValueFor( "shadow_duration" )
    
	local duration = distance/speed
	local height = 160

	if not IsServer() then return end

	-- arc
	if self:GetAbility():GetAutoCastState() then
		self.arc = self.parent:AddNewModifier(
			self.parent, -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				speed = speed,
				duration = duration,
				distance = 0,
				height = height,
			} -- kv
		)
	else
		self.arc = self.parent:AddNewModifier(
			self.parent, -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				speed = speed,
				duration = duration,
				distance = distance,
				height = height,
			} -- kv
		)
	end
	self.arc:SetEndCallback(function( interrupted )
		-- destroy this modifier when arc ends
		if self:IsNull() then return end
		self.arc = nil
		self:Destroy()
	end)

	-- set duration
	self:SetDuration( duration, true )

	-- set inactive
	self:GetAbility():SetActivated( false )
 
	-- play effects
	self:PlayEffects()
end

function modifier_slark_pounce_lua:OnRefresh( kv )
end

function modifier_slark_pounce_lua:OnRemoved()
end

function modifier_slark_pounce_lua:OnDestroy()
	if not IsServer() then return end

	-- set active
	self:GetAbility():SetActivated( true )

	-- destroy trees upon land
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), 100, false )
 
	CreateModifierThinker(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_slark_pounce_shadow_thinker", -- modifier name
		{ duration = self.shadow_duration }, -- kv
		self:GetCaster():GetAbsOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
	)
 
	-- destroy arc modifier
	if self.arc and not self.arc:IsNull() then
		self.arc:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_slark_pounce_lua:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end
 
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_pounce_lua:GetEffectName()
	return "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf"
end

function modifier_slark_pounce_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slark_pounce_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
 
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

 

function modifier_slark_pounce_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end
 
--------------------------------------------------------------------------------
modifier_slark_pounce_shadow_thinker = class({})
 
function modifier_slark_pounce_shadow_thinker:IsHidden()
	return false
end

function modifier_slark_pounce_shadow_thinker:IsPurgable()
	return false
end

function modifier_slark_pounce_shadow_thinker:OnCreated()
	local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_ground.vpcf"
    
    self.radius_shadow = self:GetAbility():GetSpecialValueFor("radius_shadow")
	local caster = self:GetCaster()

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
 

	ParticleManager:SetParticleControl( self.effect_cast, 3, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector( self.radius_shadow, 0, 0 ) )
 

	EmitSoundOn( "Hero_Slark.Pounce.Leash", self:GetParent() )	 
end
 
function modifier_slark_pounce_shadow_thinker:OnDestroy()
	StopSoundOn( "Hero_Slark.Pounce.Leash", self:GetParent() )
	ParticleManager:DestroyParticle( self.effect_cast, false )
end

function modifier_slark_pounce_shadow_thinker:IsAura()
	return true
end

function modifier_slark_pounce_shadow_thinker:GetModifierAura()
	return "modifier_modifier_slark_pounce_shadow_heal"
end

function modifier_slark_pounce_shadow_thinker:GetAuraRadius()
	return self.radius_shadow
end

function modifier_slark_pounce_shadow_thinker:GetAuraDuration()
	return 0.1
end

function modifier_slark_pounce_shadow_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_slark_pounce_shadow_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_slark_pounce_shadow_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
 

modifier_modifier_slark_pounce_shadow_heal = modifier_modifier_slark_pounce_shadow_heal or class({})

function modifier_modifier_slark_pounce_shadow_heal:OnCreated()
         self.hp_regen_pct = self:GetAbility():GetSpecialValueFor("hp_regen_pct")
         self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
 
end
 
function modifier_modifier_slark_pounce_shadow_heal:IsHidden() return  false end
function modifier_modifier_slark_pounce_shadow_heal:IsPurgable() return false end
function modifier_modifier_slark_pounce_shadow_heal:IsDebuff() return false end
function modifier_modifier_slark_pounce_shadow_heal:IsPermanent() return true end
function modifier_modifier_slark_pounce_shadow_heal:RemoveOnDeath() return true end
 
function modifier_modifier_slark_pounce_shadow_heal:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,}

	return decFuncs
end

function modifier_modifier_slark_pounce_shadow_heal:GetModifierConstantHealthRegen() return self.hp_regen end

function modifier_modifier_slark_pounce_shadow_heal:GetModifierHealthRegenPercentage() return self.hp_regen_pct end

 