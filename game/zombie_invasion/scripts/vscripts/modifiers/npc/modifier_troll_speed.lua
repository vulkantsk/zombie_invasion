modifier_troll_speed = class({})

--------------------------------------------------------------------------------

function modifier_troll_speed:IsDebuff()
	return false
end

function modifier_troll_speed:IsStunDebuff()
	return false
end

function modifier_troll_speed:IsPurgable()
	return false
end

function modifier_troll_speed:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_troll_speed:OnCreated(data)
		  
      																								
    
   GameRules:GetGameModeEntity():SetMaximumAttackSpeed(2000) 
  
end
 