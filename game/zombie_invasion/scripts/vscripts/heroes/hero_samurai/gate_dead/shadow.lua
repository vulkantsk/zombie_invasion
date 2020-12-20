LinkLuaModifier( "modifier_juggernaut_second_gate", "heroes/hero_samurai/gate_dead/shadow", LUA_MODIFIER_MOTION_NONE )

juggernaut_second_gate = class({})
--------------------------------------------------------------------------------
-- Ability Start

function juggernaut_second_gate:GetIntrinsicModifierName()
	return "modifier_juggernaut_second_gate"
end

modifier_juggernaut_second_gate = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{

 
		} end,
})

function modifier_juggernaut_second_gate:OnCreated()
 
	self:StartIntervalThink( 0.01 )
end


function modifier_juggernaut_second_gate:OnIntervalThink()
	 local caster = self:GetCaster()
 
      local ability = self:GetAbility()
          if ability:GetLevel() == 1   then 
    if not caster:HasAbility("juggernaut_shadow") then
  	    caster:AddAbility( "juggernaut_shadow" ):SetLevel(1)
  	     	    caster:SwapAbilities("jugger_2", "juggernaut_shadow", false, true)
  	     	    caster:AddAbility( "juggernaut_third_gate" )
  	    	caster:RemoveAbility("juggernaut_second_gate")
  	end
 end
 
end
 


function modifier_juggernaut_second_gate:GetEffectName()
	return "particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf"
end

function modifier_juggernaut_second_gate:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

  