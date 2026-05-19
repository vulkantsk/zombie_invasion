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
bo_eat_creeps = class({})

function bo_eat_creeps:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_Pudge.Dismember",
	}, context)
end

 

LinkLuaModifier( "modifier_bo_eat_creeps", "abilities/monsters/bo_eat_creeps", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Cast Filter
function bo_eat_creeps:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function bo_eat_creeps:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "devour_time" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_bo_eat_creeps", -- modifier name
		{ duration = duration } -- kv
	)
 
 
	-- Play effects and no draw
	self:PlayEffects( target )
	target:SetOrigin( target:GetOrigin() + Vector( 0, 0, -200 ) )

	-- kill target
	target:Kill( self, caster )
end

--------------------------------------------------------------------------------
 

--------------------------------------------------------------------------------
function bo_eat_creeps:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	local sound_cast = "Hero_Pudge.Dismember"
 

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
 
end
 
modifier_bo_eat_creeps = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_bo_eat_creeps:IsHidden()
	return false
end

function modifier_bo_eat_creeps:IsDebuff()
	return false
end

function modifier_bo_eat_creeps:IsPurgable()
	return false
end

function modifier_bo_eat_creeps:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bo_eat_creeps:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_bo_eat_creeps:OnCreated( kv )
	-- references
 
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "regen" )
end

function modifier_bo_eat_creeps:OnRefresh( kv )
	
end

function modifier_bo_eat_creeps:OnRemoved()
end
 
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_bo_eat_creeps:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_bo_eat_creeps:GetModifierConstantHealthRegen()
	return self.bonus_regen
end