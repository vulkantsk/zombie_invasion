innate_giant_strikes = class({})

LinkLuaModifier("modifier_innate_giant_strikes", "heroes/hero_troll/giant_strikes/giant_strikes", LUA_MODIFIER_MOTION_NONE)

function innate_giant_strikes:GetIntrinsicModifierName()
	return "modifier_innate_giant_strikes"
end

modifier_innate_giant_strikes = class({})

function modifier_innate_giant_strikes:IsHidden() return true end
function modifier_innate_giant_strikes:IsDebuff() return false end
function modifier_innate_giant_strikes:IsPurgable() return false end
function modifier_innate_giant_strikes:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_giant_strikes:OnCreated()
	self:OnRefresh()
end

function modifier_innate_giant_strikes:OnRefresh()
	self.parent = self:GetParent()
	local ability = self:GetAbility()
	self.locked_attack_speed = ability:GetSpecialValueFor("locked_attack_speed")
	self.pct_damage_per_attack_speed = ability:GetSpecialValueFor("pct_damage_per_attack_speed")
	self.attack_speed_cap = ability:GetSpecialValueFor("attack_speed_cap") / 100 
	self.bat_mult = self.locked_attack_speed * 0.01
end

function modifier_innate_giant_strikes:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_innate_giant_strikes:GetModifierFixedAttackRate()
	return self.parent:GetBaseAttackTime() / self.bat_mult
end

function modifier_innate_giant_strikes:GetModifierDamageOutgoing_Percentage()
	local attack_speed = math.min(self.parent:GetIncreasedAttackSpeed(false), self.attack_speed_cap)
	local bonus_damage = attack_speed * self.pct_damage_per_attack_speed * 100
	return math.max(bonus_damage, 0)
end
