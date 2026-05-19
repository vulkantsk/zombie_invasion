damage_collection = class({})

function damage_collection:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf",
	}, {
		"Hero_Centaur.Stampede.Cast",
	}, context)
end

LinkLuaModifier( "modifier_damage_collection", "heroes/hero_dragon_knight/damage_collection/damage_collection", LUA_MODIFIER_MOTION_NONE )


function damage_collection:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()


		local duration = self:GetSpecialValueFor("duration")


	-- unit groups
	self.hitEnemies = {}

	-- Find Units in Radius
	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,ally in pairs(allies) do
		-- Add modifier
		ally:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_damage_collection", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- Play effects
	self:PlayEffects()
end

function damage_collection:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf"
	local sound_cast = "Hero_Centaur.Stampede.Cast"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

modifier_damage_collection = class({})


function modifier_damage_collection:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_damage_collection:OnCreated()
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end 

function modifier_damage_collection:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage + self:GetCaster():GetPhysicalArmorValue(false)
end

