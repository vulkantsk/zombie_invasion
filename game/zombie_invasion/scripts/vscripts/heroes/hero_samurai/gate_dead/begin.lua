LinkLuaModifier( "modifier_juggernaut_first_gate", "heroes/hero_samurai/gate_dead/begin", LUA_MODIFIER_MOTION_NONE )

juggernaut_first_gate = class({})

function juggernaut_first_gate:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf",
	}, {
	}, context)
end

--------------------------------------------------------------------------------
-- Ability Start

function juggernaut_first_gate:GetIntrinsicModifierName()
	return "modifier_juggernaut_first_gate"
end


modifier_juggernaut_first_gate = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{

 
		} end,
})

function modifier_juggernaut_first_gate:OnCreated()
 	 local caster = self:GetCaster()
 
      local ability = self:GetAbility()
  			   
  	    caster:AddAbility( "juggernaut_blade_fury_lua" )
  	    caster:FindAbilityByName("juggernaut_blade_fury_lua"):SetLevel(1)
  	    caster:SwapAbilities("jugger", "juggernaut_blade_fury_lua", false, true)
 		 caster:AddAbility( "juggernaut_fourth_gate" )
     		caster:RemoveAbility("juggernaut_first_gate")
end


 
 

function modifier_juggernaut_first_gate:GetEffectName()
	return "particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf"
end

function modifier_juggernaut_first_gate:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

  