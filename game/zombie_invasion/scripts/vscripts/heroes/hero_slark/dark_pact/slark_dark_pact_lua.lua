slark_dark_pact_lua = class({})
LinkLuaModifier( "modifier_slark_dark_pact_lua", "heroes/hero_slark/dark_pact/slark_dark_pact_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_dark_pact_lua_scepter", "heroes/hero_slark/dark_pact/slark_dark_pact_lua", LUA_MODIFIER_MOTION_NONE )

-- Passive Modifier
function slark_dark_pact_lua:GetIntrinsicModifierName()
	return "modifier_slark_dark_pact_lua_scepter"
end
 
--------------------------------------------------------------------------------
-- Ability Start
function slark_dark_pact_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_dark_pact_lua", -- modifier name
		{} -- kv
	)
 
end

modifier_slark_dark_pact_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_dark_pact_lua:IsHidden()
	return true
end

function modifier_slark_dark_pact_lua:IsDebuff()
	return false
end

function modifier_slark_dark_pact_lua:IsPurgable()
	return false
end

function modifier_slark_dark_pact_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_dark_pact_lua:OnCreated( kv )
	-- references
	self.delay_time = self:GetAbility():GetSpecialValueFor( "delay" )
	self.pulse_duration = self:GetAbility():GetSpecialValueFor( "pulse_duration" )
	self.total_pulses = self:GetAbility():GetSpecialValueFor( "total_pulses" )
	self.total_damage = self:GetAbility():GetSpecialValueFor( "total_damage" ) + ( self:GetAbility():GetSpecialValueFor( "damage_agility" ) * self:GetCaster():GetAgility() )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.self_damage_pct = self:GetAbility():GetSpecialValueFor( "self_damage_pct" )/100

	-- generate data
	self.delay = true
	self.count = 0
	self.damage = self.total_damage/self.total_pulses

	-- Start interval
	if IsServer() then
		-- Precache damageTable	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- begin delay
		self:StartIntervalThink( self.delay_time )

		-- play effects
		self:PlayEffects1()
	end
end

function modifier_slark_dark_pact_lua:OnRefresh( kv )
	-- references
	self.delay_time = self:GetAbility():GetSpecialValueFor( "delay" )
	self.pulse_duration = self:GetAbility():GetSpecialValueFor( "pulse_duration" )
	self.total_pulses = self:GetAbility():GetSpecialValueFor( "total_pulses" )
	self.total_damage = self:GetAbility():GetSpecialValueFor( "total_damage" ) + ( self:GetAbility():GetSpecialValueFor( "damage_agility" ) * self:GetCaster():GetAgility() )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.self_damage_pct = self:GetAbility():GetSpecialValueFor( "self_damage_pct" )/100
 
	-- generate data
	self.delay = true
	self.count = 0
	self.damage = self.total_damage/self.total_pulses

	-- Start interval
	if IsServer() then
		-- Precache damageTable	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- begin delay
		self:StartIntervalThink( self.delay_time )

		-- play effects
		self:PlayEffects1()
	end
end

function modifier_slark_dark_pact_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_slark_dark_pact_lua:OnIntervalThink()
	if self.delay then
		self.delay = false
		-- start pulse
		self:StartIntervalThink( self.pulse_duration/self.total_pulses )

		-- play effects
		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
		self:PlayEffects2()
	else
		-- Find Units in Radius
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			self:GetAbility():GetAbilityTargetFlags(),	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- aoe damage
		self.damageTable.damage = self.damage
		self.damageTable.damage_flags = 0
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end

		-- Purge
		self:GetParent():Purge( false, true, false, true, true )

		-- self damage
		self.damageTable.damage = self.damage*self.self_damage_pct
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		self.damageTable.victim = self:GetParent()
		ApplyDamage( self.damageTable )

		-- Counter
		self.count = self.count + 1
		if self.count>=self.total_pulses then
			self:StartIntervalThink( -1 )
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_dark_pact_lua:PlayEffects1()
	local particle_cast
	local sound_cast = "Hero_Slark.DarkPact.PreCast"

    if self:GetCaster():HasModifier("modifier_special_effect_slark_skin") then 
          particle_cast = "particles/econ/items/slark/slark_head_immortal/slark_head_immortal_start.vpcf"
    else 
         particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf"
    end

	-- play particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitoc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetParent() )
end

function modifier_slark_dark_pact_lua:PlayEffects2()
	local sound_cast = "Hero_Slark.DarkPact.Cast"
	local particle_cast 

    if self:GetCaster():HasModifier("modifier_special_effect_slark_skin") then 
          particle_cast = "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf"
    else 
         particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf"
    end
	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

modifier_slark_dark_pact_lua_scepter = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,

})

function modifier_slark_dark_pact_lua_scepter:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("chance_scepter")
	self.damage_scepter = self:GetAbility():GetSpecialValueFor("damage_scepter")/100
	-- body
end
function modifier_slark_dark_pact_lua_scepter:TickPack()
 
    local damage = self:GetAbility():GetSpecialValueFor( "total_damage" ) + ( self:GetAbility():GetSpecialValueFor( "damage_agility" ) * self:GetCaster():GetAgility() )
		-- Find Units in Radius
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			self:GetAbility():GetAbilityTargetFlags(),	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = damage*self.damage_scepter,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.

		}

		-- aoe damage
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end
        
        self:PlayEffects2()
end

function modifier_slark_dark_pact_lua_scepter:OnAttackLanded(keys)
	if not self:GetCaster():HasScepter() then 
        return 
	end
    local target = keys.target
    if self:GetCaster() == keys.attacker and not target:IsBuilding() then
    	if RollPseudoRandomPercentage(self.chance, 1, self:GetCaster()) then 
              self:TickPack()
        end
    end
end

function modifier_slark_dark_pact_lua_scepter:PlayEffects2()
	local sound_cast = "Hero_Slark.DarkPact.Cast"
	local particle_cast

    if self:GetCaster():HasModifier("modifier_special_effect_slark_skin") then 
          particle_cast = "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf"
    else 
         particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf"
    end

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

 

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
