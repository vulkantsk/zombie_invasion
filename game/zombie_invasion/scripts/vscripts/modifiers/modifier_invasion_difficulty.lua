modifier_invasion_difficulty = {}

function modifier_invasion_difficulty:GetMult()
	local c = self:GetStackCount()

	if c == 1 then
		return 0.2
	elseif c == 2 then
		return 0.5
	end

	return 0.2
end

function modifier_invasion_difficulty:IsHidden()
	return true
end

function modifier_invasion_difficulty:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_invasion_difficulty:GetModifierPreAttack_BonusDamage()
	return math.floor( self:GetParent():GetDamageMin() * self:GetMult() )
end

function modifier_invasion_difficulty:GetModifierSpellAmplify_Percentage()
	return math.floor( self:GetMult() * 100 )
end

function modifier_invasion_difficulty:GetModifierMagicalResistanceBonus()
	return math.floor( self:GetParent():GetBaseMagicalResistanceValue() * self:GetMult() )
end

function modifier_invasion_difficulty:GetModifierPhysicalArmorBonus()
	return math.floor( self:GetParent():GetPhysicalArmorBaseValue() * self:GetMult() )
end