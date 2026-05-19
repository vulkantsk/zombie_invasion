LinkLuaModifier( "modifier_juggernaut_fifth_gate", "heroes/hero_samurai/gate_dead/limit", LUA_MODIFIER_MOTION_NONE )

juggernaut_fifth_gate = class({})

function juggernaut_fifth_gate:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf",
	}, {
	}, context)
end

--------------------------------------------------------------------------------
-- Ability Start

function juggernaut_fifth_gate:GetIntrinsicModifierName()
	return "modifier_juggernaut_fifth_gate"
end


modifier_juggernaut_fifth_gate = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
 
		
		} end,
})

function modifier_juggernaut_fifth_gate:OnCreated()
 
	self:StartIntervalThink( 0.01 )
end


function modifier_juggernaut_fifth_gate:OnIntervalThink()
	 local caster = self:GetCaster()
 
      local ability = self:GetAbility()
          if ability:GetLevel() == 1   then 
    if not caster:HasAbility("void_spirit_astral_step_lua") then
  	    caster:AddAbility( "void_spirit_astral_step_lua" ):SetLevel(1)
  	      	    caster:SwapAbilities("jugger_5", "void_spirit_astral_step_lua", false, true)
  	      	    caster:AddAbility( "juggernaut_second_gate" )
  	    	caster:RemoveAbility("juggernaut_fifth_gate")
  	end
 end
 
end
 


function modifier_juggernaut_fifth_gate:GetEffectName()
	return "particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death_fire.vpcf"
end

function modifier_juggernaut_fifth_gate:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

  