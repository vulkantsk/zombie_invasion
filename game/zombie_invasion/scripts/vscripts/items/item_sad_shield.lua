LinkLuaModifier( "modifier_item_sad_shield", "items/item_sad_shield", LUA_MODIFIER_MOTION_NONE )


item_sad_shield = class({
    GetIntrinsicModifierName = function() return "modifier_item_sad_shield" end
})

modifier_item_sad_shield = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    } end
})

function modifier_item_sad_shield:OnCreated()
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_sad_shield:OnRefresh()
    self:OnCreated()

end

function modifier_item_sad_shield:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_item_sad_shield:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_sad_shield:GetModifierPhysical_ConstantBlock()
    if RollPercentage(self:GetAbility():GetSpecialValueFor("damage_block_chance")) then
        return self:GetAbility():GetSpecialValueFor("damage_block")
    end
end

function modifier_item_sad_shield:GetTexture()
    return "items/stout"
end


