modifier_invasion_difficulty = {}

function modifier_invasion_difficulty:GetMult()
	local c = self:GetStackCount()

	if c == 1 then
		return 0.5
	elseif c == 2 then
		return 1.0
	end

	return 1.0
end

function modifier_invasion_difficulty:IsHidden()
	return true
end

function modifier_invasion_difficulty:RemoveOnDeath()
	return false
end


function modifier_invasion_difficulty:OnCreated()
 	self:GetParent():CalculateGenericBonuses()
end

 

function modifier_invasion_difficulty:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_invasion_difficulty:GetModifierPreAttack_BonusDamage()
	return math.floor( self:GetParent():GetDamageMin() * self:GetMult() )
end

function modifier_invasion_difficulty:GetModifierSpellAmplify_Percentage()
	return 100 * self:GetMult()
end

function modifier_invasion_difficulty:GetModifierExtraHealthBonus()
    if not self:GetParent():HasAbility("zombie_tombstone") then 
	     return  (  self:GetParent():GetBaseMaxHealth() * self:GetMult() )
	else 
	     return nil       
	end    
end


function modifier_invasion_difficulty:GetModifierPhysicalArmorBonus()
	return math.floor( self:GetParent():GetPhysicalArmorBaseValue() * self:GetMult() )
end

modifier_nothing_dif = {}

function modifier_nothing_dif:IsHidden()
	return true
end