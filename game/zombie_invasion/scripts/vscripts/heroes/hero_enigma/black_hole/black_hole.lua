ability_black_hole = {}

LinkLuaModifier( "modifier_ability_black_hole_thinker", "heroes/hero_enigma/black_hole/black_hole", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_black_hole_debuff", "heroes/hero_enigma/black_hole/black_hole", LUA_MODIFIER_MOTION_HORIZONTAL )

function ability_black_hole:GetAOERadius()
	return self:GetSpecialValueFor( "far_radius" )
end

function ability_black_hole:OnOwnerDied()
	if IsServer() then
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

    if self:GetCaster():FindAbilityByName("special_bonus_unique_enigma_black_hole_dead"):GetLevel() == 1 then 
	     self.thinker_dead = CreateModifierThinker(
		     caster,
		     self,
		     "modifier_ability_black_hole_thinker",
		     { duration = duration },
		     self:GetCaster():GetAbsOrigin(),
		     caster:GetTeamNumber(),
		     false
	     )
	    self.thinker_dead = self.thinker_dead:FindModifierByName("modifier_ability_black_hole_thinker")
    end
    end
end

function ability_black_hole:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

	self.thinker = CreateModifierThinker(
		caster,
		self,
		"modifier_ability_black_hole_thinker",
		{ duration = duration },
		point,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_ability_black_hole_thinker")
end

function ability_black_hole:OnChannelFinish( bInterrupted )
	if self.thinker and not self.thinker:IsNull() then
		self.thinker:Destroy()
	end
end

modifier_ability_black_hole_debuff = {}

function modifier_ability_black_hole_debuff:IsHidden()
	return false
end

function modifier_ability_black_hole_debuff:IsDebuff()
	return true
end

function modifier_ability_black_hole_debuff:IsStunDebuff()
	return true
end

function modifier_ability_black_hole_debuff:IsPurgable()
	return true
end

function modifier_ability_black_hole_debuff:OnCreated( kv )
	self.rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	self.pull_speed = self:GetAbility():GetSpecialValueFor( "pull_speed" )
	self.rotate_speed = self:GetAbility():GetSpecialValueFor( "pull_rotate_speed" )

	if IsServer() then
		self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_ability_black_hole_debuff:OnRefresh( kv )
	
end

function modifier_ability_black_hole_debuff:OnRemoved()
end

function modifier_ability_black_hole_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_ability_black_hole_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_ability_black_hole_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_ability_black_hole_debuff:GetOverrideAnimationRate()
	return self.rate
end

function modifier_ability_black_hole_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_ability_black_hole_debuff:UpdateHorizontalMotion( me, dt )
	local target = self:GetParent():GetOrigin()-self.center
	target.z = 0

	local targetL = target:Length2D()-self.pull_speed*dt

	local targetN = target:Normalized()
	local deg = math.atan2( targetN.y, targetN.x )
	local targetN = Vector( math.cos(deg+self.rotate_speed*dt), math.sin(deg+self.rotate_speed*dt), 0 );

	self:GetParent():SetOrigin( self.center + targetN * targetL )


end

function modifier_ability_black_hole_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

modifier_ability_black_hole_thinker = {}

function modifier_ability_black_hole_thinker:IsHidden()
	return false
end

function modifier_ability_black_hole_thinker:IsPurgable()
	return false
end

function modifier_ability_black_hole_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "far_radius" )
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5)
	self.tick = 0

	if IsServer() then
 
 
		local damage = self:GetAbility():GetSpecialValueFor( "near_damage" )  
         local spell_amp = self:GetCaster():GetSpellAmplification(false)

        
 
 
 		self.damageTable = {
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
		}
 
		self.damageTableDead = {
			attacker = self:GetCaster(),
			damage = damage * (spell_amp + 1),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
		}
          
		self:StartIntervalThink( self.interval )

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )

		self:AddParticle(
			effect_cast,
			false,
			false,
			-1,
			false,
			false
		)

		EmitSoundOn( "Hero_Enigma.Black_Hole", self:GetParent() )
	end
end


function modifier_ability_black_hole_thinker:OnDestroy()
 
	if IsServer() then
		 
		if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
			self:OnIntervalThink()
		end
	 
	StopSoundOn( "Hero_Enigma.Black_Hole", self:GetParent() )
	EmitSoundOn( "Hero_Enigma.Black_Hole.Stop", self:GetParent() )
		UTIL_Remove( self:GetParent() )
	end
 
 
end

function modifier_ability_black_hole_thinker:OnIntervalThink()
	local pulse = self:GetCaster():FindAbilityByName("ability_midnight_pulse") 
    local pulse_max = pulse:GetSpecialValueFor("damage_percent")
    local pulse_base = pulse:GetSpecialValueFor("damage_base")
    local black_base = self:GetAbility():GetSpecialValueFor( "near_damage" )

         local spell_amp = self:GetCaster():GetSpellAmplification(false)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		if self:GetCaster():IsAlive() then 
		     self.damageTable.victim = enemy
		     if self:GetCaster():HasShard() then 
		          self.damageTable.damage = black_base + ( enemy:GetMaxHealth()*  pulse_max/100 ) + pulse_base
		     end
		      ApplyDamage( self.damageTable )
		else 
		     self.damageTableDead.victim = enemy
	          if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then 
		          self.damageTableDead.damage = ( enemy:GetMaxHealth()*  pulse_max/100 ) +  ((black_base + pulse_base) * (spell_amp + 1) )
		     end
		      ApplyDamage( self.damageTableDead )
		end
	end

	self.tick = self.tick + 1
end

function modifier_ability_black_hole_thinker:IsAura()
	return true
end

function modifier_ability_black_hole_thinker:GetModifierAura()
	return "modifier_ability_black_hole_debuff"
end

function modifier_ability_black_hole_thinker:GetAuraRadius()
	return self.radius
end

function modifier_ability_black_hole_thinker:GetAuraDuration()
	return 0.1
end

function modifier_ability_black_hole_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_black_hole_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_black_hole_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end