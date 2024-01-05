LinkLuaModifier( "modifier_armor_revenge_passive", "heroes/hero_dragon_knight/armor_revenge/armor_revenge" ,LUA_MODIFIER_MOTION_NONE )

armor_revenge = class({

    GetIntrinsicModifierName = function() return "modifier_armor_revenge_passive" end
})


modifier_armor_revenge_passive = class({})

function modifier_armor_revenge_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_armor_revenge_passive:OnCreated()
    self.damage_bonus = self:GetAbility():GetSpecialValueFor( "damage_bonus" )
    self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
end 

function modifier_armor_revenge_passive:OnRefresh()
    self:OnCreated()
end 

function modifier_armor_revenge_passive:GetModifierPreAttack_BonusDamage()
    return self.damage_bonus * self:GetCaster():GetPhysicalArmorValue(false)
end

function modifier_armor_revenge_passive:GetModifierPhysicalArmorBonus()
    return self.armor_bonus
end