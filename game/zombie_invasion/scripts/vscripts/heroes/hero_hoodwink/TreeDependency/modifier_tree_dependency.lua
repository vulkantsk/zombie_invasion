 
--------------------------------------------------------------------------------
modifier_tree_dependency = {}

--------------------------------------------------------------------------------
-- Classifications
 

 
 
function modifier_tree_dependency:IsHidden()
	return false
end


 

--------------------------------------------------------------------------------
-- Initializations
function modifier_tree_dependency:OnCreated( kv )
	-- references
 
 	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
 	self.bonus_envasion = self:GetAbility():GetSpecialValueFor( "bonus_envasion" )
	  
 	if IsServer() then 
 			 	local bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
 	 	if self:GetCaster():FindAbilityByName("special_hoodwink"):GetLevel() == 1   then 
  bonus_damage = bonus_damage + self:GetCaster():FindAbilityByName("special_hoodwink"):GetSpecialValueFor( "value" )
            print('talent 1 detected')
       end
          self:SetStackCount(  -bonus_damage )
end
end

function modifier_tree_dependency:OnRefresh( kv )
	-- references
 	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
 	self.bonus_envasion = self:GetAbility():GetSpecialValueFor( "bonus_envasion" )
  			 	local bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
 end
function modifier_tree_dependency:OnRemoved()
end

function modifier_tree_dependency:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_tree_dependency:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

 
function modifier_tree_dependency:GetModifierAttackSpeedBonus_Constant()
 
 	if not self:GetParent():PassivesDisabled() then
		 
	 
		return self.attack_speed
	end
end

function modifier_tree_dependency:GetModifierPreAttack_BonusDamage()
  
 
             return  -self:GetStackCount()
  
 
	 
 
end

function modifier_tree_dependency:GetModifierEvasion_Constant()
 
 	if not self:GetParent():PassivesDisabled() then
		return self.bonus_envasion
	end
end

 