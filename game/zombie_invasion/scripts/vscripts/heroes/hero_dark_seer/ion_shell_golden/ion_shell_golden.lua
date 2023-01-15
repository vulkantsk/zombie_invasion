ability_ion_shell_golden = {}

LinkLuaModifier( "modifier_ability_ion_shell_golden", "heroes/hero_dark_seer/ion_shell_golden/ion_shell_golden", LUA_MODIFIER_MOTION_NONE )
 
function ability_ion_shell_golden:GetIntrinsicModifierName()
     return "modifier_ability_ion_shell_golden"
end
 
modifier_ability_ion_shell_golden = {}

function modifier_ability_ion_shell_golden:DeclareFunctions()
	local funcs = {
            MODIFIER_PROPERTY_HEALTH_BONUS,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end

function modifier_ability_ion_shell_golden:IsHidden()
	return false
end

function modifier_ability_ion_shell_golden:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_ability_ion_shell_golden:IsPurgable()
	return true
end

function modifier_ability_ion_shell_golden:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.team = self.caster:GetTeamNumber()

	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	local tick = self:GetAbility():GetSpecialValueFor( "tick_interval" )

	if not IsServer() then
		return
	end

	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
 

	self.damageTable = {
		attacker = self:GetCaster(),
		damage = damage*tick,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(),
	}

	self:StartIntervalThink( tick )
	self:OnIntervalThink()

	self:PlayEffects1()
end

function modifier_ability_ion_shell_golden:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_ion_shell_golden:OnDestroy()
	if not IsServer() then
		return
	end

	StopSoundOn( "Hero_Dark_Seer.Ion_Shield_lp", self.parent )
	EmitSoundOn( "Hero_Dark_Seer.Ion_Shield_end", self.parent )
end

function modifier_ability_ion_shell_golden:OnIntervalThink()
if not self:GetParent():PassivesDisabled() then 
	local enemies = FindUnitsInRadius(
		self.team,
		self.parent:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		0,
		false
	)

if self:GetCaster():HasModifier("modifier_ability_ion_shell") then 
	self:GetCaster():RemoveModifierByName("modifier_ability_ion_shell")
end

	for _,enemy in pairs(enemies) do
		if enemy ~= self.parent then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

			self:PlayEffects2( enemy )
		end
	end
end
end

function modifier_ability_ion_shell_golden:GetModifierHealthBonus()
	if not self:GetParent():PassivesDisabled() then
	    return self.bonus_health
    end
end

function modifier_ability_ion_shell_golden:GetModifierConstantHealthRegen()
     if not self:GetParent():PassivesDisabled() then
	    return self.bonus_regen
     end
end

function modifier_ability_ion_shell_golden:PlayEffects1()

	local hull1 = 40
	local hull2 = 40

	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_golden.vpcf", PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( hull1, hull2, 0 ) )

	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false 
	)

	EmitSoundOn( "Hero_Dark_Seer.Ion_Shield_Start", self.parent )
	EmitSoundOn( "Hero_Dark_Seer.Ion_Shield_lp", self.parent )
end

function modifier_ability_ion_shell_golden:PlayEffects2( target )
	local particle_cast = "particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_dmg_golden.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

 