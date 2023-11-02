LinkLuaModifier("modifier_item_quest_cm_shield", "items/item_quest_cm_shield", LUA_MODIFIER_MOTION_NONE)

item_quest_cm_shield = class({
    GetIntrinsicModifierName = function() return "modifier_item_quest_cm_shield" end
})

modifier_item_quest_cm_shield = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    } end
})

function modifier_item_quest_cm_shield:GetTexture()
	return "items/pie_magic"
end

function modifier_item_quest_cm_shield:OnCreated()
	self.health_reduction = self:GetAbility():GetSpecialValueFor("health_reduction")
    self.bonus_shield = self:GetAbility():GetSpecialValueFor("bonus_shield")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
    self.dmg_amp = self:GetAbility():GetSpecialValueFor("dmg_amp")
    self.stat_int = self:GetAbility():GetSpecialValueFor("stat_int")
    self.chance_miss = self:GetAbility():GetSpecialValueFor("chance_miss")
end

function modifier_item_quest_cm_shield:OnRefresh()
    self:OnCreated()

end

function modifier_item_quest_cm_shield:GetModifierIncomingDamage_Percentage(params)
 
if params.unit == self:GetParent() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS  then return end

    if RandomInt(0, 100)<self.chance_miss then
            
            return -100
        end

    return
end

function modifier_item_quest_cm_shield:GetModifierMagical_ConstantBlock()
	return self.bonus_shield 
end

function modifier_item_quest_cm_shield:GetModifierExtraHealthPercentage()
    return self.health_reduction
end

function modifier_item_quest_cm_shield:GetModifierHPRegenAmplify_Percentage()
    return self.bonus_heal_amp
end

function modifier_item_quest_cm_shield:GetModifierSpellAmplify_Percentage()
    return self.dmg_amp
end

function modifier_item_quest_cm_shield:GetModifierBonusStats_Intellect()
    return self.stat_int
end