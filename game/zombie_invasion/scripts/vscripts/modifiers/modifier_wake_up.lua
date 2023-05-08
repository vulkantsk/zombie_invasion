modifier_wake_up = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {

        } end,
 
})
 

 function modifier_wake_up:OnCreated() 
 
 	self:StartIntervalThink(0.25)
 
 end

 function modifier_wake_up:OnIntervalThink() 
	 local caster = self:GetParent()
	 DealDamage(caster, caster, self:GetParent():GetMaxHealth() * 0.2, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NONE, nil)
 end