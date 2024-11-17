ability_ion_shell = {}

LinkLuaModifier( "modifier_ability_ion_shell", "heroes/hero_dark_seer/ion_shell/ion_shell", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_ion_shell_unit", "heroes/hero_dark_seer/ion_shell/ion_shell", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_ion_shell_hero", "heroes/hero_dark_seer/ion_shell/ion_shell", LUA_MODIFIER_MOTION_NONE )
function ability_ion_shell:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "duration" )

    if target == self:GetCaster() then 
	target:AddNewModifier(
		caster,
		self,
		"modifier_ability_ion_shell",
		{ duration = duration }
	)
elseif target:IsHero() then 
 	target:AddNewModifier(
		caster,
		self,
		"modifier_ability_ion_shell_hero",
		{ duration = duration }
	)

else  
		target:AddNewModifier(
		caster,
		self,
		"modifier_ability_ion_shell_unit",
		{ duration = duration }
	)
end
end

modifier_ability_ion_shell = {}

function modifier_ability_ion_shell:DeclareFunctions()
	local funcs = {
            MODIFIER_PROPERTY_HEALTH_BONUS,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_ability_ion_shell:IsHidden()
	return false
end

function modifier_ability_ion_shell:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_ability_ion_shell:IsPurgable()
	return true
end

function modifier_ability_ion_shell:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.team = self.caster:GetTeamNumber()

	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	local tick = self:GetAbility():GetSpecialValueFor( "tick_interval" )

	if not IsServer() then
		return
	end

	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	self.damageTable = {
		attacker = self:GetCaster(),
		damage = (damage+self:GetCaster():GetAttackDamage())*tick,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(),
	}

	self:StartIntervalThink( tick )
	self:OnIntervalThink()

	self:PlayEffects1()
end

function modifier_ability_ion_shell:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_ion_shell:OnDestroy()
	if not IsServer() then
		return
	end
	if IsServer() then
		if self:GetAbility():GetAutoCastState() then
		
			self:GetParent():CastAbilityOnTarget(self:GetParent(), self:GetAbility(), self.caster:GetPlayerOwnerID())
		end
	end

	StopSoundOn( "Hero_Dark_Seer.Ion_Shield_lp", self.parent )
	EmitSoundOn( "Hero_Dark_Seer.Ion_Shield_end", self.parent )
end

function modifier_ability_ion_shell:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self.team,
		self.parent:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		self.abilityTargetType,
		self.abilityTargetFlags,
		0,
		false
	)
 

	for _,enemy in pairs(enemies) do
		if enemy ~= self.parent then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

			self:PlayEffects2( enemy )
		end
	end
end

function modifier_ability_ion_shell:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_ability_ion_shell:GetModifierConstantHealthRegen()
	return self.bonus_regen
end

function modifier_ability_ion_shell:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_ability_ion_shell:PlayEffects1()

	local hull1 = 40
	local hull2 = 40

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_POINT_FOLLOW, self.parent )
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

function modifier_ability_ion_shell:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"

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

modifier_ability_ion_shell_unit = {}

function modifier_ability_ion_shell_unit:DeclareFunctions()
	local funcs = {
            MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_ability_ion_shell_unit:IsHidden()
	return false
end

function modifier_ability_ion_shell_unit:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_ability_ion_shell_unit:IsPurgable()
	return true
end

function modifier_ability_ion_shell_unit:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.team = self.caster:GetTeamNumber()
    	 
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	local tick = self:GetAbility():GetSpecialValueFor( "tick_interval" )
 
 	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	self.damageTable = {
		attacker = self:GetCaster(),
		damage = damage*tick,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(),
	}

	if not IsServer() then
		return
	end
		self:OnIntervalThink()
	self:StartIntervalThink( tick )
	self:PlayEffects1()
end

function modifier_ability_ion_shell_unit:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_ion_shell_unit:OnDestroy()
	if not IsServer() then
		return
	end

	StopSoundOn( "Hero_Dark_Seer.Ion_Shield_lp", self.parent )
	EmitSoundOn( "Hero_Dark_Seer.Ion_Shield_end", self.parent )
end

function modifier_ability_ion_shell_unit:GetModifierExtraHealthBonus()
	return self.bonus_health
end

function modifier_ability_ion_shell_unit:GetModifierConstantHealthRegen()
	return self.bonus_regen
end

function modifier_ability_ion_shell_unit:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end


function modifier_ability_ion_shell_unit:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self.team,
		self.parent:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		self.abilityTargetType,
		self.abilityTargetFlags,
		0,
		false
	)
 

	for _,enemy in pairs(enemies) do
		if enemy ~= self.parent then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

			self:PlayEffects2( enemy )
		end
	end
end

function modifier_ability_ion_shell_unit:PlayEffects1()

	local hull1 = 40
	local hull2 = 40

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_POINT_FOLLOW, self.parent )
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

function modifier_ability_ion_shell_unit:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"

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

modifier_ability_ion_shell_hero = {}

function modifier_ability_ion_shell_hero:DeclareFunctions()
	local funcs = {
            MODIFIER_PROPERTY_HEALTH_BONUS,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_ability_ion_shell_hero:IsHidden()
	return false
end

function modifier_ability_ion_shell_hero:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_ability_ion_shell_hero:IsPurgable()
	return true
end
 
 
 
 

function modifier_ability_ion_shell_hero:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.team = self.parent:GetTeamNumber()
    	 

	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	local tick = self:GetAbility():GetSpecialValueFor( "tick_interval" )
 

	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	self.damageTable = {
		attacker = self:GetCaster(),
		damage = damage*tick,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(),
	}

	if not IsServer() then
		return
	end
	self:StartIntervalThink( tick )
		self:OnIntervalThink()
	self:PlayEffects1()
end

function modifier_ability_ion_shell_hero:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_ion_shell_hero:OnDestroy()
	if not IsServer() then
		return
	end

	StopSoundOn( "Hero_Dark_Seer.Ion_Shield_lp", self.parent )
	EmitSoundOn( "Hero_Dark_Seer.Ion_Shield_end", self.parent )
end

function modifier_ability_ion_shell_hero:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_ability_ion_shell_hero:GetModifierConstantHealthRegen()
	return self.bonus_regen
end

function modifier_ability_ion_shell_hero:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_ability_ion_shell_hero:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self.team,
		self.parent:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		self.abilityTargetType,
		self.abilityTargetFlags,
		0,
		false
	)
 

	for _,enemy in pairs(enemies) do
		if enemy ~= self.parent then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

			self:PlayEffects2( enemy )
		end
	end
end


function modifier_ability_ion_shell_hero:PlayEffects1()

	local hull1 = 40
	local hull2 = 40

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_POINT_FOLLOW, self.parent )
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

function modifier_ability_ion_shell_hero:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"

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