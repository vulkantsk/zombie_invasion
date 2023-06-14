LinkLuaModifier("modifier_item_dragon_hand_stats", "items/item_dragon_hand", LUA_MODIFIER_MOTION_NONE)

item_dragon_hand = class({
    GetIntrinsicModifierName = function() return "modifier_item_dragon_hand_stats" end
})

modifier_item_dragon_hand_stats = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    } end
})

function modifier_item_dragon_hand_stats:GetTexture()
	return "item_dragon_hand"
end

function modifier_item_dragon_hand_stats:OnCreated()
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_dragon_hand_stats:OnRefresh()
    self:OnCreated()

end

function modifier_item_dragon_hand_stats:GetModifierBonusStats_Agility()
	return self.bonus_agility 
end

function modifier_item_dragon_hand_stats:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
