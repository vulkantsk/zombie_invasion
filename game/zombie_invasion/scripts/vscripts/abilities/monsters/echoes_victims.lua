
if echoes_victims == nil then
    echoes_victims = class({})
end

function echoes_victims:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function echoes_victims:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )
end


function echoes_victims:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function echoes_victims:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		self.aoeRadius = self:GetCastRange(self.caster:GetAbsOrigin(),self.caster) or 0
		self.duration = self:GetSpecialValueFor("duration") or 0
		self.sZoneDur = self:GetSpecialValueFor("sZone_duration") or 0		
		self.handsDur = self:GetSpecialValueFor("hands_duration") or 0	
		self.handsRadius = self:GetSpecialValueFor("hands_radius") or 0
		self.think = 1
		--self.caster:AddNewModifier(self.caster, self, "modifier_signal_animation", {duration = self.think})

			self.caster:EmitSound("Hero_DeathProphet.Exorcism.Cast")

		    Timers:CreateTimer(self.think, function()
		    	self:CreateSignalZone()
		    	self.duration = self.duration - self.think
		    	if self.duration >= self.think then
					return self.think
				end
				return nil
		    end
		    )
	end
end


function echoes_victims:CreateSignalZone()

	if self.caster then
		if not self.caster:IsNull() then
			local point = ( self.caster:GetAbsOrigin() + RandomVector( RandomFloat( 0, self.aoeRadius )) ) or nil	
		
			if point then
				local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_nightmare_slime.vpcf", PATTACH_CUSTOMORIGIN, self.caster )
				ParticleManager:SetParticleControl(particleID, 0, point)
				--ParticleManager:SetParticleControl(particleID, 1, Vector(400, 0, 0))
				self:DestroyParticle(particleID,self.sZoneDur)
				self:CreateHands(point,self.sZoneDur)				
			end
		end
	end
	
end

function echoes_victims:DestroyParticle(particleID,time)
	if particleID then
	    Timers:CreateTimer(time, function()
			ParticleManager:DestroyParticle(particleID, false)
			ParticleManager:ReleaseParticleIndex(particleID)
			return nil
	    end
	    )		
	end
end


function echoes_victims:CreateHands(vLocation,time)

    Timers:CreateTimer(time, function()

		if self.caster then
			if not self.caster:IsNull() then
				--StartSoundEventFromPosition("Hero_Bane.FiendsGrip.Cast",vLocation)	
				CreateModifierThinker(	self.caster, 
										self, 
										"modifier_echoes_victims", 
										{duration = self.handsDur}, 
										vLocation, 
										self.caster:GetTeamNumber(), 
										false)
			end
		end

		return nil
    end
    )
end