LinkLuaModifier("modifier_item_dragon_boots_stats", "items/item_dragon_boots", LUA_MODIFIER_MOTION_NONE)

item_dragon_boots = class({
    GetIntrinsicModifierName = function() return "modifier_item_dragon_boots_stats" end
})

modifier_item_dragon_boots_stats = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_EVASION_CONSTANT
    } end
})

function modifier_item_dragon_boots_stats:GetTexture()
	return "item_dragon_boots"
end

function modifier_item_dragon_boots_stats:OnCreated()
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_item_dragon_boots_stats:OnRefresh()
    self:OnCreated()

end

function modifier_item_dragon_boots_stats:GetModifierBonusStats_Agility()
	return self.bonus_agility 
end

function modifier_item_dragon_boots_stats:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_dragon_boots_stats:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_item_dragon_boots_stats:GetModifierMoveSpeedBonus_Percentage()
    return self.bonus_move_speed
end

function modifier_item_dragon_boots_stats:GetModifierEvasion_Constant()
    return self.bonus_evasion
end
