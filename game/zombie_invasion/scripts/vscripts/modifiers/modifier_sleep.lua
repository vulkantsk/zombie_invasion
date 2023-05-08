modifier_sleep = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    CheckState      = function(self) return 
        {
            [MODIFIER_STATE_INVULNERABLE] = true, 
            [MODIFIER_STATE_ROOTED] = true, 
            [MODIFIER_STATE_SILENCED] = true, 
            [MODIFIER_STATE_STUNNED] = true, 
            [MODIFIER_STATE_MUTED] = true,           
        } end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_bane/bane_nightmare.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end, 
})
 

 function modifier_sleep:GetTexture()
    return "modifier_son"
end

 function modifier_sleep:OnCreated() 
 
 
 end

 