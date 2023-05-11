LinkLuaModifier( "modifier_chupik", "abilities/chupakabra", LUA_MODIFIER_MOTION_NONE )

 

chupakabra = class({})

function chupakabra:GetIntrinsicModifierName()
    return "modifier_chupik"
end

modifier_chupik = class({
    IsHidden                 = function(self) return true end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        } end,
})
 
function modifier_chupik:OnCreated()
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_chupik:OnRefresh()
   
    self:OnCreated()
end

function modifier_chupik:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor * self:GetParent():GetStrength()
end