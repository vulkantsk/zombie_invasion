  
ultimate = ({})

LinkLuaModifier( "modifier_ultimate", "heroes/hero_medusa/ultimate", LUA_MODIFIER_MOTION_NONE )

function modifier_ultimate:GetIntrinsicModifierName()
	return "modifier_ultimate"
end

modifier_ultimate = {}

function modifier_ultimate:IsHidden()
	return true
end

function modifier_ultimate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_ultimate:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
	end
end
