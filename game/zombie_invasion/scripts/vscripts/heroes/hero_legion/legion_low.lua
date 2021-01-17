legion_low = class({})

function legion_low:GetIntrinsicModifierName()
	return "modifier_legoin_low"
end
 




LinkLuaModifier("modifier_legoin_low", "heroes/hero_legion/legion_low", LUA_MODIFIER_MOTION_NONE)

legion_low = class({})

function legion_low:GetIntrinsicModifierName()
	return "modifier_legoin_low"
end

modifier_legoin_low = class({})

function modifier_legoin_low:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

    }
    return funcs
end

function modifier_legoin_low:IsHidden()
    return true
end

function modifier_legoin_low:IsPurgable()
    return false
end 

function modifier_legoin_low:RemoveOnDeath()
    return true
end

 

function modifier_legoin_low:OnIntervalThink()
  	local counter =  100 - ( self:GetCaster():GetHealth() / ( self:GetCaster():GetMaxHealth()/100 ) )
  			self:SetStackCount( counter )
end

function modifier_legoin_low:OnCreated(kv)
 	self.armor = self:GetAbility():GetSpecialValueFor( "bonuss_armor" )
    self.magic = self:GetAbility():GetSpecialValueFor( "bonuss_magic" )    
 	    self:StartIntervalThink(0.2)
 
end

 

function modifier_legoin_low:OnRefresh( kv )
	self:OnCreated()
end    

function modifier_legoin_low:GetModifierPhysicalArmorBonus()
		if not self:GetParent():PassivesDisabled() then
    return self:GetStackCount()  *  self.armor
    	end
 
end

function modifier_legoin_low:GetModifierMagicalResistanceBonus()
        if not self:GetParent():PassivesDisabled() then
    return self:GetStackCount()  *  self.magic
        end
 
end