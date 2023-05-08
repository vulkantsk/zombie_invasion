modifier_powelvolya = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
     DeclareFunctions        = function(self) return 
         {
            MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
         } end, 
    GetEffectName           = function(self) return "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal_buff_model.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end, 
})
 
  function modifier_powelvolya:GetTexture()
    return "modifier_son"
end


 function modifier_powelvolya:GetModifierBaseAttack_BonusDamage() 
    return 20000
end

function modifier_powelvolya:GetModifierPhysicalArmorBonus() 
    return 200000
end


 function modifier_powelvolya:GetModifierAttackSpeedBonus_Constant() 
    return 700
end