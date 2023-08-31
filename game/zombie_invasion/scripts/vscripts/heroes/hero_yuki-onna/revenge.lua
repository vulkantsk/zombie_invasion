 LinkLuaModifier( "modifier_revenge_buff", "heroes/hero_yuki-onna/revenge", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_revenge_aura", "heroes/hero_yuki-onna/revenge", LUA_MODIFIER_MOTION_NONE )


 yuki_revenge = {}
 
 function yuki_revenge:GetIntrinsicModifierName() 
 	return "modifier_revenge_aura"
 end

 modifier_revenge_aura = class({
 	IsHidden 				= function(self) return true end,
 	IsPurgable 				= function(self) return false end,
 	IsDebuff 				= function(self) return false end,
 	IsBuff                  = function(self) return true end,
 	RemoveOnDeath 			= function(self) return true end,
 
 })

function modifier_revenge_aura:OnCreated()
	local particle_cast = "particles/yuki_voodoo_restoration.vpcf"
    
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
	local caster = self:GetCaster()

	-- Create Particle
	if self.effect_cast then 
 		ParticleManager:DestroyParticle(self.effect_cast, false)
 	end
 	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
end

function modifier_revenge_aura:OnRefresh() 
	self:OnCreated()
end



function modifier_revenge_aura:IsAura()
	return true
end

function modifier_revenge_aura:GetModifierAura()
	return "modifier_revenge_buff"
end

function modifier_revenge_aura:GetAuraRadius()
	return self.radius
end

function modifier_revenge_aura:GetAuraDuration()
	return 0.1
end

 
function modifier_revenge_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_revenge_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_revenge_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

modifier_revenge_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
 
})

function modifier_revenge_buff:OnCreated() 
	local int_think = self:GetAbility():GetSpecialValueFor("int_think")
	self:StartIntervalThink(int_think)
end

function modifier_revenge_buff:OnRefresh() 
	self:OnCreated()
end

function modifier_revenge_buff:OnIntervalThink()
	local base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
 	local damage = self:GetAbility():GetSpecialValueFor("damage_per_int") * self:GetCaster():GetIntellect() + base_damage
 	local heal = self:GetAbility():GetSpecialValueFor("heal")
 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
		DealDamage(self:GetCaster(), self:GetParent(), damage, self:GetAbility():GetAbilityDamageType(), nil, self:GetAbility())
	else 
    	self:GetParent():Heal(heal,self:GetCaster())
 		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), heal, nil)
 	end
end