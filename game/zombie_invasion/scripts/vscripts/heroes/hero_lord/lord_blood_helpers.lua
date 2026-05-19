LORD_BLOOD_RAGE_MODIFIER = "modifier_lord_blood_rage"

function GetLordBloodRageModifier(unit)
	if unit == nil or unit:IsNull() then
		return nil
	end
	if unit.FindModifierByName == nil then
		return nil
	end
	return unit:FindModifierByName(LORD_BLOOD_RAGE_MODIFIER)
end

function LordAbilityHasEnoughBlood(ability, costLevel)
	if not IsServer() then
		return true
	end

	local caster = ability and ability:GetCaster()
	local modif = GetLordBloodRageModifier(caster)
	if not modif then
		return false
	end
	local level = costLevel
	if level == nil then
		level = ability:GetLevel()
	end
	if level < 0 then
		level = 0
	end
	return modif:GetStackCount() >= ability:GetHealthCost(level)
end
