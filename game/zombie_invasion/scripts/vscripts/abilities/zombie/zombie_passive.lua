 
LinkLuaModifier( "modifier_zombie_passive_fire", "abilities/zombie/zombie_passive.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_passive_day_or_night", "abilities/zombie/zombie_passive.lua", LUA_MODIFIER_MOTION_NONE )

zombie_passive = class({})

function zombie_passive:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf",
	}, {
	}, context)
end


 

function zombie_passive:GetIntrinsicModifierName()
 
	return "modifier_zombie_passive_day_or_night"
 
end

 
 

modifier_zombie_passive_day_or_night = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})


function modifier_zombie_passive_day_or_night:OnCreated()
	if IsServer() then

		local ability = self:GetAbility()
 
		self:StartIntervalThink(1)
	end
end

 

function modifier_zombie_passive_day_or_night:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
 	if GameRules:IsDaytime() then 
 		caster:AddNewModifier(caster, ability, "modifier_zombie_passive_fire", {})
 	else 
  		if caster:HasModifier("modifier_zombie_passive_fire") then 
  			caster:RemoveModifierByName("modifier_zombie_passive_fire")
  		end
  end
end

 
 
 
 
--------------------------------------------------------------------------------

 

modifier_zombie_passive_fire = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})


function modifier_zombie_passive_fire:OnCreated()
	if IsServer() then
 
		local ability = self:GetAbility()
 
		self:StartIntervalThink(0.5)
	end
end

function modifier_zombie_passive_fire:GetTexture()
     return "omniknight_purification"
end

function modifier_zombie_passive_fire:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local dps =  ability:GetSpecialValueFor("dps")
	if parent:GetHealthPercent() <= 50 then
 	     UTIL_Remove(parent)
 	else
 		DealDamage (caster, parent, caster:GetMaxHealth() * (dps/100), DAMAGE_TYPE_PURE, nil, ability)
 	end

 
 
end

function modifier_zombie_passive_fire:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

 


