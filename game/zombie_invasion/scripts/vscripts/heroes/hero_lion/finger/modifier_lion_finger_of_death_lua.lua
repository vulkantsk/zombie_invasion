modifier_lion_finger_of_death_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
 
function modifier_lion_finger_of_death_lua:OnTooltip()
	return self:GetStackCount()
end

function modifier_lion_finger_of_death_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_lion_finger_of_death_lua:RemoveOnDeath()
	return false
end

function modifier_lion_finger_of_death_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

 

--------------------------------------------------------------------------------
-- Initializations
function modifier_lion_finger_of_death_lua:OnCreated( kv )
	-- references
	     		  -- special value

 self.suka = 0
 		self.damage_myself = self:GetAbility():GetSpecialValueFor( "damage_myself" )
 		self.damage_myself_true =  ( self:GetCaster():GetMaxHealth() * self.damage_myself ) / 100


	if self:GetCaster():HasScepter() then
		self.damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" ) -- special value
				self.damage_per_use = self:GetAbility():GetSpecialValueFor( "damage_per_use" )
	else
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.damage_per_use = self:GetAbility():GetSpecialValueFor( "damage_per_use" ) -- special value
	end 
			self:StartIntervalThink( 0.2 )
  
end

function modifier_lion_finger_of_death_lua:DeclareFunctions( kv )
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_lion_finger_of_death_lua:OnDeath( kv )
	  if  IsServer() then  
		local unit = kv.unit
	local caster = self:GetCaster()

	if unit == self:GetCaster() then
       self.suka = self.suka / 2
       		self:PlayEffects2( lines )

	end

	      self:SetStackCount(self.suka)
        end

      return 0
        end

function modifier_lion_finger_of_death_lua:PlayEffects2( lines )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_cast = "Hero_Nevermore.Shadowraze"    

	-- Create Particles
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
 
	ParticleManager:SetParticleControlForward( effect_cast, 2, self:GetCaster():GetForwardVector() )		-- initial direction
	ParticleManager:ReleaseParticleIndex( effect_cast )


	-- Play Sounds
	EmitSoundOn(sound_cast, self:GetCaster())
end

function modifier_lion_finger_of_death_lua:OnAbilityExecuted( kv )
	if  IsServer() then    

		        local unit = kv.unit
        local parent = self:GetParent()

      if unit ~= parent then
            return
        end

      local justCast = kv.ability:GetAbilityName() == "lion_finger_of_death_lua"
        if not justCast then
            return
        end
 

 
self.suka = self.suka + 1
    
 
      self:SetStackCount(self.suka)
      end

      return 0
end             


   
  

 
 

 

 

function modifier_lion_finger_of_death_lua:OnDestroy( kv )
	if IsServer() then
		-- check if it's still valid target
		if not self:GetParent():IsAlive() then return end
		local nResult = UnitFilter(
			self:GetParent(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			0,
			self:GetCaster():GetTeamNumber()
		)
		if nResult ~= UF_SUCCESS then
			return
		end
 
  

		-- damage
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage + (self:GetCaster():FindModifierByName("modifier_lion_finger_of_death_lua"):GetStackCount() * self.damage_per_use),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)

				local damageTable1 = {
			victim = self:GetCaster(),
			attacker = self:GetCaster(),
			damage = self.damage_myself_true  ,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable1)
 
	end
end