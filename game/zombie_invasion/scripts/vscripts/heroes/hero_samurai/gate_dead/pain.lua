LinkLuaModifier( "modifier_juggernaut_third_gate", "heroes/hero_samurai/gate_dead/pain", LUA_MODIFIER_MOTION_NONE )

juggernaut_third_gate = class({})

function juggernaut_third_gate:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf",
	}, {
	}, context)
end

--------------------------------------------------------------------------------
-- Ability Start

function juggernaut_third_gate:GetIntrinsicModifierName()
	return "modifier_juggernaut_third_gate"
end


modifier_juggernaut_third_gate = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{

     
		
		} end,
})

function modifier_juggernaut_third_gate:OnCreated()
 
	self:StartIntervalThink( 0.01 )
end


function modifier_juggernaut_third_gate:OnIntervalThink()
	 local caster = self:GetCaster()
 
      local ability = self:GetAbility()
          if ability:GetLevel() == 1   then 
    if not caster:HasAbility("juggernaut_omni_slash") then
  	    caster:AddAbility( "juggernaut_omni_slash" ):SetLevel(1)
  	        caster:SwapAbilities("jugger_3", "juggernaut_omni_slash", false, true)
  	    caster:AddAbility( "juggernaut_sixth_gate" )
  	    	caster:RemoveAbility("juggernaut_third_gate")
  	end
 end
 
end
 


function modifier_juggernaut_third_gate:GetEffectName()
	return "particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf"
end

function modifier_juggernaut_third_gate:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

  