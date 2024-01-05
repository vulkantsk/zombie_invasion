full_armor_stand = class({})
LinkLuaModifier( "modifier_full_armor_stand", "heroes/hero_dragon_knight/full_armor_stand/full_armor_stand", LUA_MODIFIER_MOTION_NONE )


function full_armor_stand:OnSpellStart()
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
			"modifier_full_armor_stand", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- Play effects
	self:PlayEffects()
end

function full_armor_stand:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/events/frostivus/frostivus_tree_cast_ability.vpcf"
	local sound_cast = "n_creep_Thunderlizard_Big.Stomp"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

modifier_full_armor_stand = class({})

function modifier_full_armor_stand:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_full_armor_stand:OnCreated()
    self.resist_damage = self:GetAbility():GetSpecialValueFor( "resist_damage" )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end 

function modifier_full_armor_stand:GetModifierIncomingDamage_Percentage()
    return self.resist_damage
end

function modifier_full_armor_stand:GetModifierDamageOutgoing_Percentage()
    return self.damage
end

