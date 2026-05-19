-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
void_spirit_astral_step_lua = class({})

function void_spirit_astral_step_lua:Precache(context)
	PrecacheAbilityResources({
		"particles/heroes/samurai_astral_step.vpcf",
		"particles/heroes/samurai_astral_step_debuff.vpcf",
		"particles/heroes/samurai_astral_step_impact.vpcf",
	}, {
		"Hero_VoidSpirit.AstralStep.End",
		"Hero_VoidSpirit.AstralStep.Start",
	}, context)
end

LinkLuaModifier( "modifier_generic_charges", "heroes/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_void_spirit_astral_step_lua", "heroes/hero_samurai/spells/modifier_void_spirit_astral_step_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
 
--------------------------------------------------------------------------------
-- Ability Start
function void_spirit_astral_step_lua:OnAbilityPhaseStart()
		if IsServer() then
	    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)  
	end
 	return true
   end
 


function void_spirit_astral_step_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
 
	-- load data   
 	local min_dist = self:GetSpecialValueFor( "min_travel_distance" )
	local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
	local radius = self:GetSpecialValueFor( "radius" )
	local delay = self:GetSpecialValueFor( "pop_damage_delay" )

	-- find destination
	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )
 
	-- teleport
	FindClearSpaceForUnit( caster, target, true )

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
		caster:PerformAttack( enemy, true, true, true, false, true, false, true )

		-- add modifier
 
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_void_spirit_astral_step_lua", -- modifier name
			{ duration = delay } -- kv
		)

		-- play effects
	--	self:PlayEffects2( enemy )
	end

	-- play effects
	self:PlayEffects1( origin, target )
end
    
 
-- Ability Start
 

--------------------------------------------------------------------------------
function void_spirit_astral_step_lua:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/heroes/samurai_astral_step.vpcf"
	local sound_start = "Hero_VoidSpirit.AstralStep.Start"
	local sound_end = "Hero_VoidSpirit.AstralStep.End"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function void_spirit_astral_step_lua:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/heroes/samurai_astral_step_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end