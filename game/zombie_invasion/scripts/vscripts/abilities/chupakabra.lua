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
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
        } end,
})
 
function modifier_chupik:OnCreated()
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
    self.movespeedlimit = self:GetAbility():GetSpecialValueFor("movespeedlimit")
end

function modifier_chupik:OnRefresh()
   
    self:OnCreated()
end

function modifier_chupik:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor * self:GetParent():GetStrength()
end
function modifier_chupik:GetModifierMoveSpeedBonus_Constant() 
    return self.bonus_movespeed
end
function modifier_chupik:GetModifierIgnoreMovespeedLimit() 
    return self.movespeedlimit + self.bonus_movespeed + self:GetParent():GetAgility()
end