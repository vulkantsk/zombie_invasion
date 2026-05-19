LinkLuaModifier( "modifier_juggernaut_gate_dead", "heroes/hero_samurai/gate_dead", LUA_MODIFIER_MOTION_NONE )

juggernaut_hell_samurai = class({})

function juggernaut_hell_samurai:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf",
	}, {
	}, context)
end

--------------------------------------------------------------------------------
-- Ability Start

function juggernaut_hell_samurai:GetIntrinsicModifierName()
	return "modifier_juggernaut_gate_dead"
end


modifier_juggernaut_gate_dead = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{

            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
           	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
           	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		
		} end,
})

function modifier_juggernaut_gate_dead:OnCreated()
 
	self:StartIntervalThink( 0.2 )
end


function modifier_juggernaut_gate_dead:OnIntervalThink()
	 local caster = self:GetCaster()
	  local sucka = 0
      local ability = self:GetAbility()
          if ability:GetLevel() == 1   then 
    if not caster:HasAbility("gyrocopter_call_down") then
  	    caster:AddAbility( "gyrocopter_call_down" )
  	end
 end
    if ability:GetLevel() == 2 then 
    if not caster:HasAbility("gyrocopter_flak_cannon") then
  	    caster:AddAbility( "gyrocopter_flak_cannon" )
  	end
     

     caster:SetOriginalModel("models/items/warlock/golem/puppet_summoner_golem/puppet_summoner_golem.vmdl")    
     caster:SetModel("models/items/warlock/golem/puppet_summoner_golem/puppet_summoner_golem.vmdl")  
     caster:SetModelScale(0.7) 
 end
end

function modifier_juggernaut_gate_dead:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_juggernaut_gate_dead:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end
function modifier_juggernaut_gate_dead:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end


function modifier_juggernaut_gate_dead:GetEffectName()
	return "particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf"
end

function modifier_juggernaut_gate_dead:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

  