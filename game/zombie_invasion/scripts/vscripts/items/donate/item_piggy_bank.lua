LinkLuaModifier("modifier_item_piggy_bank","items/donate/item_piggy_bank.lua", LUA_MODIFIER_MOTION_NONE)
 if item_piggy_bank == nil then
	item_piggy_bank = class({})
 
end
 
 
 
 function item_piggy_bank:GetIntrinsicModifierName()
	return "modifier_item_piggy_bank"
end
 
function item_piggy_bank:OnSpellStart()
    local caster = self:GetCaster()
    
    self:SetCurrentCharges(self:GetCurrentCharges() + 1)
    
    EmitSoundOn("kefteme",caster)
end
  
 
modifier_item_piggy_bank = class({
	IsHidden 		= function(self) return true end,
	IsPurgable 		= function(self) return false end,
	IsDebuff 		= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        } end,
})
 
 function modifier_item_piggy_bank:OnCreated()
    self.attack__bonus = self:GetAbility():GetSpecialValueFor("attack__bonus")     
end

function modifier_item_piggy_bank:GetModifierPreAttack_BonusDamage()
    return self.attack__bonus * self:GetAbility():GetCurrentCharges()
end

  