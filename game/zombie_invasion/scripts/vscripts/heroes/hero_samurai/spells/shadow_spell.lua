juggernaut_shadow = class({})
 

LinkLuaModifier( "modifier_juggernaut_shadow", "heroes/hero_samurai/spells/shadow_spell", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_shadow_jug", "heroes/hero_samurai/spells/modifier_shadow_jug", LUA_MODIFIER_MOTION_NONE )
 
 
--------------------------------------------------------------------------------
-- Ability Start
function juggernaut_shadow:OnSpellStart()
		if self:GetCaster():HasModifier("modifier_phantom_assassin_death_rush") then 
		return nil 
	else
	     self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shadow_jug", { duration =  self:GetSpecialValueFor( "duration" )})
	     self:PlayEffects()
	  end
end
 
function juggernaut_shadow:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_start.vpcf"
	local sound_cast = "Hero_Invoker.GhostWalk"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Passive Modifier
function juggernaut_shadow:GetIntrinsicModifierName()
	return "modifier_juggernaut_shadow"
end

 
 
 modifier_juggernaut_shadow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_shadow:IsHidden()
	return true
end
function modifier_juggernaut_shadow:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

 
--------------------------------------------------------------------------------
-- Initializations
function modifier_juggernaut_shadow:OnCreated( kv )
	-- references
	self.miss = self:GetAbility():GetSpecialValueFor( "miss" ) -- special value
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "speed" ) -- special value
end

function modifier_juggernaut_shadow:OnRefresh( kv )
	-- references
	self.miss = self:GetAbility():GetSpecialValueFor( "miss" ) -- special value
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "speed" ) -- special value
end

function modifier_juggernaut_shadow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_juggernaut_shadow:GetModifierEvasion_Constant( kv )
		if not self:GetParent():PassivesDisabled() then
	 return self.miss
	end
 
end

function modifier_juggernaut_shadow:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():PassivesDisabled() then

			return self.speed
		
	end
end
