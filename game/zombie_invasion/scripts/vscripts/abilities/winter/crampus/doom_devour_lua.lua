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
doom_devour_lua = class({})

function doom_devour_lua:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_DoomBringer.Devour",
		"Hero_DoomBringer.DevourCast",
	}, context)
end

doom_devour_lua_slot1 = class({})

function doom_devour_lua_slot1:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_DoomBringer.Devour",
		"Hero_DoomBringer.DevourCast",
	}, context)
end

doom_devour_lua_slot2 = class({})

function doom_devour_lua_slot2:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_DoomBringer.Devour",
		"Hero_DoomBringer.DevourCast",
	}, context)
end


LinkLuaModifier( "modifier_doom_devour_lua", "abilities/winter/crampus/modifier_doom_devour_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Cast Filter
function doom_devour_lua:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,  
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function doom_devour_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "devour_time" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_doom_devour_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- check if target has abilities
 

	-- absorb abilities if autocast is on and target has abilities
 


	-- Play effects and no draw
	self:PlayEffects( target )
	target:SetOrigin( target:GetOrigin() + Vector( 0, 0, -200 ) )

	-- kill target
	target:Kill( self, caster )
end

 

--------------------------------------------------------------------------------
function doom_devour_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	local sound_cast = "Hero_DoomBringer.Devour"
	local sound_target = "Hero_DoomBringer.DevourCast"

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
	EmitSoundOn( sound_target, target )
end

 