modifier_lion_finger_of_death_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lion_finger_of_death_lua:IsHidden()
	return false
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
	if self:GetCaster():HasScepter() then
		self.damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" ) -- special value
	else
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.damage_per_use = self:GetAbility():GetSpecialValueFor( "damage_per_use" ) -- special value
	end 
  
end

function modifier_lion_finger_of_death_lua:DeclareFunctions( kv )
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
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
 
	end
end