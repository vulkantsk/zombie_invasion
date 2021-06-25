

if puddle_of_poison == nil then
    puddle_of_poison = class({})
end

function puddle_of_poison:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function puddle_of_poison:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )
end


function puddle_of_poison:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function puddle_of_poison:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor("puddle_duration") or 0
		self.puddleRadius = self:GetSpecialValueFor("puddle_radius") or 0	
		self.delayTime = 2
		--self.caster:AddNewModifier(self.caster, self, "modifier_signal_animation", {duration = self.think})
		self.caster:EmitSound("Hero_DeathProphet.Silence")
		self:CreatePuddle()
	end
end


function puddle_of_poison:CreatePuddle()
	if self:GetCaster() then

		local units = nil
		local target = nil
		local particleID = nil

		units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.caster, self:GetCastRange(self.caster:GetAbsOrigin(),self.caster),
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		
		if units then
			target = units[RandomInt(1, #units)]
			if target then
				self:GetCaster().point = target:GetAbsOrigin()
			else
				self:GetCaster().point = self.caster:GetAbsOrigin()
			end
		end			
		
		if self:GetCaster().point then

	    	particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf", PATTACH_CUSTOMORIGIN, self)
	    	ParticleManager:SetParticleControl(particleID, 0, self:GetCaster().point )
	   		ParticleManager:SetParticleControl(particleID, 1, Vector(self.puddleRadius, 0, 0))			
	   		self:DestroyParticle(particleID,self.delayTime)
		    Timers:CreateTimer(self.delayTime, function()
		    	StartSoundEventFromPosition("Hero_Viper.NetherToxin", self:GetCaster().point)
	    		CreateModifierThinker(	self:GetCaster(), 
	    								self, 
	    								"modifier_puddle_of_poison", 
	    								{duration = self.duration}, 
	    								self:GetCaster().point, 
	    								self:GetCaster():GetTeamNumber(), 
	    								false)
				return nil
	    	end
	    	)	
		end

	end
end


function puddle_of_poison:DestroyParticle(particleID,time)
	if particleID then
	    Timers:CreateTimer(time, function()
			ParticleManager:DestroyParticle(particleID, false)
			ParticleManager:ReleaseParticleIndex(particleID)
			return nil
	    end
	    )		
	end
end
