luna_night_buff = class({})

function luna_night_buff:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf",
	}, {
		"Hero_Luna.LucentBeam.Cast",
		"Hero_Luna.LucentBeam.Target",
	}, context)
end


LinkLuaModifier( "modifier_luna_night_buff", "heroes/hero_luna/luna_night_buff/luna_night_buff", LUA_MODIFIER_MOTION_NONE )

function luna_night_buff:OnSpellStart()

  	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetCastRange(self:GetCaster():GetAbsOrigin(),self:GetCaster())
		local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		print("P:",units)
		  	if IsServer() then
		for _, ally in pairs(units) do
			ally:AddNewModifier(self:GetCaster(), self, "modifier_luna_night_buff", {duration = duration})
            self:PlayEffects2( ally )
		end
	end
 end

end

function luna_night_buff:PlayEffects2( target )
	local particle_cast = "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	local effect_cast = assert(loadfile("heroes/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		6,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end

modifier_luna_night_buff = class({})


function modifier_luna_night_buff:IsHidden()
	return false
end

function modifier_luna_night_buff:IsDebuff()
	return false
end

function modifier_luna_night_buff:IsStunDebuff()
	return false
end

function modifier_luna_night_buff:IsPurgable()
	return false
end

function modifier_luna_night_buff:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.spell_damage = self:GetAbility():GetSpecialValueFor( "spell_damage" )

	if not IsServer() then
		return
	end

 
end

function modifier_luna_night_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_luna_night_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_luna_night_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_luna_night_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_luna_night_buff:GetModifierSpellAmplify_Percentage()
	return self.spell_damage
end


 
 