tech_speed = class({})

LinkLuaModifier("modifier_tech_speed", "heroes/hero_tech/tech_speed", LUA_MODIFIER_MOTION_NONE)

function tech_speed:GetIntrinsicModifierName()
	return "modifier_tech_speed"
end

modifier_tech_speed = class({})

function modifier_tech_speed:IsHidden() return true end
function modifier_tech_speed:IsDebuff() return false end
function modifier_tech_speed:IsPurgable() return false end
function modifier_tech_speed:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_tech_speed:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_tech_speed:OnRefresh()
	self.parent = self:GetParent()
	self.locked_attack_speed = self:GetAbility():GetSpecialValueFor("locked_attack_speed")
	self.pct_damage_per_attack_speed = self:GetAbility():GetSpecialValueFor("pct_damage_per_attack_speed")
	self.bat_mult = self.locked_attack_speed * 0.01
end

function modifier_tech_speed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_tech_speed:GetModifierFixedAttackRate()
	return self.parent:GetBaseAttackTime() / self.bat_mult
end

function modifier_tech_speed:GetModifierPreAttack_BonusDamage()
	local attack_speed = self.parent:GetIncreasedAttackSpeed()
	local bonus_damage = (attack_speed * self.pct_damage_per_attack_speed * 100) - (700 * self.pct_damage_per_attack_speed)

	return math.max(bonus_damage, 0)
end

function modifier_tech_speed:GetModifierAttackSpeedBonus_Constant()
	return 700
end