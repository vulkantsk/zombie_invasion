 LinkLuaModifier( "modifier_challenge_debuff", "heroes/hero_yuki-onna/challenge", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_challenge_buff", "heroes/hero_yuki-onna/challenge", LUA_MODIFIER_MOTION_NONE )
 

yuki_challenge = {}

 function yuki_challenge:OnSpellStart()
 	local target = self:GetCursorTarget()
 
	target:AddNewModifier( self:GetCaster(), self, "modifier_challenge_debuff", { duration = self:GetSpecialValueFor('duration') } )
end
 
modifier_challenge_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_PROPERTY_DISABLE_HEALING,
        } end,
     CheckState      = function(self) return 
         {
 		[MODIFIER_STATE_MUTED] = true,  
  		[MODIFIER_STATE_SILENCED] = true,
  		[MODIFIER_STATE_STUNNED] = true,
  		[MODIFIER_STATE_ROOTED] = true,
  		[MODIFIER_STATE_DISARMED] = true,


         } end,        
    GetEffectName = function() return "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf" end,

})
 
 
function modifier_challenge_debuff:GetDisableHealing()
	return 1
end
 
function modifier_challenge_debuff:OnCreated() 
	self.parent = self:GetParent()
	if not self.parent.yuki_challenge then 
		self.parent.yuki_challenge = 100
	end
	self.main = self:GetParent():GetPrimaryAttribute() == 3 and self.parent:GetPrimaryStatValue()/3 or self.parent:GetPrimaryStatValue()
	self.interval = self:GetAbility():GetSpecialValueFor('interval')
	self.dmg_per_atr = self:GetAbility():GetSpecialValueFor('dmg_per_atr')
	self.full_damage = (self.dmg_per_atr * self.parent:GetPrimaryStatValue()) * (self.parent.yuki_challenge/100)
	
	self:StartIntervalThink(self.interval)
	 EmitSoundOn( 'Hero_Winter_Wyvern.ColdEmbrace', self.parent )

end 
 
function modifier_challenge_debuff:OnRefresh() 
	self:OnCreated()
end

function modifier_challenge_debuff:OnIntervalThink() 
	local interval_dur = self.interval / self:GetAbility():GetSpecialValueFor("duration")
	local damage = self.full_damage * interval_dur
	DealDamage(self:GetCaster(), self:GetParent(), damage, DAMAGE_TYPE_PURE, self:GetAbility():GetAbilityTargetFlags(), self:GetAbility())
end

function modifier_challenge_debuff:OnDestroy() 
	StopSoundOn( 'Hero_Winter_Wyvern.ColdEmbrace', self.parent )
	if not self.parent:IsAlive() then 
		self.parent.yuki_challenge = self.parent.yuki_challenge - self:GetAbility():GetSpecialValueFor("dmg_reduce")
	 return 
	end
	self.parent.yuki_challenge = self.parent.yuki_challenge + self:GetAbility():GetSpecialValueFor("dmg_incr")
	if self.parent:HasModifier("modifier_challenge_buff") then 
		local modif = self.parent:FindModifierByName("modifier_challenge_buff")
		modif:SetStackCount(modif:GetStackCount() + 1)
	else
		local modif = self.parent:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_challenge_buff", {} )
		modif:SetStackCount(1)
	end

end

modifier_challenge_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        } end,
})

function modifier_challenge_buff:GetModifierBonusStats_Strength()
	if self:GetParent():GetPrimaryAttribute() == 0  or self:GetParent():GetPrimaryAttribute() == 3 then  
	return self:GetAbility():GetSpecialValueFor("bonus_main") * self:GetStackCount()
	end
end

function modifier_challenge_buff:GetModifierBonusStats_Agility()
		if self:GetParent():GetPrimaryAttribute() == 1 or self:GetParent():GetPrimaryAttribute() == 3 then  
	return self:GetAbility():GetSpecialValueFor("bonus_main") * self:GetStackCount()
end
end
function modifier_challenge_buff:GetModifierBonusStats_Intellect()
	if self:GetParent():GetPrimaryAttribute() == 2 or self:GetParent():GetPrimaryAttribute() == 3 then  
	return self:GetAbility():GetSpecialValueFor("bonus_main") * self:GetStackCount()
end
end
function modifier_challenge_buff:GetModifierBonusStats_Strength()
	if self:GetCaster():HasScepter() then
	
			return self:GetAbility():GetSpecialValueFor("main_pct") * self:GetStackCount()

	end
end

function modifier_challenge_buff:GetModifierBonusStats_Agility()
	if self:GetCaster():HasScepter() then

			return self:GetAbility():GetSpecialValueFor("main_pct") * self:GetStackCount()

	end
end
function modifier_challenge_buff:GetModifierBonusStats_Intellect()
	if self:GetCaster():HasScepter() then

			return self:GetAbility():GetSpecialValueFor("main_pct") * self:GetStackCount()
		
	end
end
