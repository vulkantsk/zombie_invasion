LinkLuaModifier("modifier_shovel_effect","items/item_shovel.lua", LUA_MODIFIER_MOTION_NONE)
 if item_shovel == nil then
	item_shovel = class({})
 
end
 
 
 
 function item_shovel:GetIntrinsicModifierName()
	return "modifier_shovel_effect"
end
 
 

function item_shovel:OnSpellStart()
	-- Effects
 
 
	    EmitSoundOn( "burrow", self:GetCaster() )
 
   	local caster        =   self:GetCaster()
	local target_loc    =   self:GetCursorPosition() 
 
 
	self.particle_fx = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_dig.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(self.particle_fx, 0, caster:GetAbsOrigin())
 

end
  local call_jo = 1 
--------------------------------------------------------------------------------
-- Ability Channeling
-- function sand_king_epicenter_lua:GetChannelTime()

-- end
 
function item_shovel:OnChannelFinish( bInterrupted )
	-- cancel if fail
 
    local caster        =   self:GetCaster()
	 local target_loc    =   self:GetCursorPosition() 
 
    local gold_min =  self:GetSpecialValueFor("gold_min")
    local gold_max =  self:GetSpecialValueFor("gold_max")

	if bInterrupted then 
 
	    		StopSoundOn( "burrow", self:GetCaster() )
 
      ParticleManager:DestroyParticle( self.particle_fx, true)
 
 		return
	end
 
 if caster:HasModifier("modifier_Jo_effect")   then 
     
   	  
 	 
 	 if call_jo <= 1 then 
	point = Entities:FindByName( nil, "Djo_spawner"):GetAbsOrigin()
	unit = CreateUnitByName("npc_boss_mutant", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	unit.respawn = false	
	unit:SetForwardVector(RandomVector(1))
    end
    Plus()

 end   
    ParticleManager:DestroyParticle( self.particle_fx, true)
  
	self.particle_fx = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_revealed_baby_roshan.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(self.particle_fx, 0, caster:GetAbsOrigin())
 
   local gold = RandomInt(gold_min, gold_max)
 
 				EmitSoundOnClient( "General.Coins", caster)
			caster:ModifyGold(gold, false, 0)
			SendOverheadEventMessage( caster, OVERHEAD_ALERT_GOLD, caster, gold, nil )
 
 
  
 
 
  
	-- Effects
  
end
    function Plus()
   call_jo = call_jo + 1
end

modifier_shovel_effect = modifier_shovel_effect or class({})

-- Modifier properties

function modifier_shovel_effect:IsHidden()		return true end
function modifier_shovel_effect:IsPurgable()		return false end
function modifier_shovel_effect:RemoveOnDeath()	return false end
function modifier_shovel_effect:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

 
function modifier_shovel_effect:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_health             =   ability:GetSpecialValueFor("bonus_health")
 
 
 
	end
end

-- Various stat bonuses
function modifier_shovel_effect:DeclareFunctions()
	return {
 
      MODIFIER_PROPERTY_HEALTH_BONUS,

	}
end

  

-- Stats
function modifier_shovel_effect:GetModifierHealthBonus() return self.bonus_health end
 
 
 