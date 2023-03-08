LinkLuaModifier("modifier_sf_demonic", "heroes/hero_sf/sf_demonic/sf_demonic", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------
------------------------------------------------------------

sf_demonic = class({})

function sf_demonic:GetIntrinsicModifierName()
	return "modifier_sf_demonic"
end

------------------------------------------------------------
------------------------------------------------------------
modifier_sf_demonic = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,} end,
})

function modifier_sf_demonic:OnCreated()
    self.dmg_proc = self:GetAbility():GetSpecialValueFor("dmg_proc")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	self.damage_count = 0
end


function modifier_sf_demonic:OnRefresh()
    self.dmg_proc = self:GetAbility():GetSpecialValueFor("dmg_proc")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_sf_demonic:GetModifierBonusStats_Strength()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("str_per_stack")
end

function modifier_sf_demonic:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_sf_demonic:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_sf_demonic:OnTakeDamage( params )
	if params.unit == self:GetParent() and self:GetAbility():IsCooldownReady() then
        local target = params.attacker
        local unit = params.unit
        self.damage_count = self.damage_count + params.damage
             
        if self.damage_count >= self.dmg_proc then 
          	self.damage_count = 0

            self:SetStackCount(self:GetStackCount() + 1)
        	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))   
        end
 
    end
end