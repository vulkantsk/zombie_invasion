LinkLuaModifier( "modifier_alchemist_good_deal", "heroes/hero_alchemist/totem/alchemist_good_deal", LUA_MODIFIER_MOTION_NONE )

alchemist_good_deal = class({})

function alchemist_good_deal:GetIntrinsicModifierName()
	return "modifier_alchemist_good_deal"
end

modifier_alchemist_good_deal = {}

function modifier_alchemist_good_deal:IsHidden()
	return true
end

function modifier_alchemist_good_deal:IsPurgable()
	return false
end

function modifier_alchemist_good_deal:RemoveOnDeath()
	return false
end

function modifier_alchemist_good_deal:OnCreated()
    self.damage_gold = self:GetAbility():GetSpecialValueFor("damage_gold")/100

	self:OnIntervalThink()
	 self:StartIntervalThink(1.0)
end

function modifier_alchemist_good_deal:OnRefresh( kv )
	-- references
	self:OnCreated()
 
 end

function modifier_alchemist_good_deal:OnIntervalThink()
    local caster = self:GetCaster()
    local gold = caster:GetGold()

     self:SetStackCount(gold)
end

function modifier_alchemist_good_deal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
	}
end

function modifier_alchemist_good_deal:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.damage_gold
end