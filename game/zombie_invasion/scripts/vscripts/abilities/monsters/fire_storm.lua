

if fire_storm == nil then
    fire_storm = class({})
end

function fire_storm:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function fire_storm:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )
end


function fire_storm:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function fire_storm:OnSpellStart()

	self.caster = self:GetCaster()
	self.damage = self:GetSpecialValueFor("damage") or 0
	self.duration = self:GetSpecialValueFor("duration") or 0
	self.aoeRadius = self:GetSpecialValueFor("aoe_radius") or 0
	self.dmgRadius = self:GetSpecialValueFor("dmg_radius") or 0	
	self.think = 1
	--self.caster:AddNewModifier(self.caster, self, "modifier_signal_animation", {duration = self.think})
	--self.caster:EmitSound("Hero_Nevermore.RequiemOfSoulsCast")

    Timers:CreateTimer(self.think, function()
    	self:CreatePumpkin()
    	self.duration = self.duration - self.think
    	if self.duration >= self.think then
			return self.think
		end
		return nil
    end
    )

end


function fire_storm:CreatePumpkin()
	if self:GetCaster() then
		local point = ( self:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 0, self.aoeRadius )) ) or nil	
	
		if point then
			local particleID = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( particleID, 0, point)
			self:PumpkinDamage(point)
		end	

	end
end

function fire_storm:DestroyParticle(particleID)
	if particleID then
	    Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particleID, false)
			ParticleManager:ReleaseParticleIndex(particleID)
			return nil
	    end
	    )		
	end
end


function fire_storm:PumpkinDamage(vLocation)
    Timers:CreateTimer(2, function()
		if self:GetCaster() then
			local units = FindUnitsInRadius( self.caster:GetTeamNumber(), vLocation, self.caster, self.dmgRadius,
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

			local particleID = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_flame_immortal1.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( particleID, 0, vLocation)
			StartSoundEventFromPosition("Hero_Invoker.SunStrike.Ignite",vLocation)

			if units then  
				for i = 1, #units do
					if units[i] then
						ApplyDamage({
						    victim = units[i],
						    attacker = self.caster,
						    damage = self.damage,
						    damage_type = self:GetAbilityDamageType(),
						    ability = self
						   })
					end
				end	
			end
		end
		return nil
    end
    )

end