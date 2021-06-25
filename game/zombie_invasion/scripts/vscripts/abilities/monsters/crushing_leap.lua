

if crushing_leap == nil then
    crushing_leap = class({})
end

function crushing_leap:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function crushing_leap:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )
end


function crushing_leap:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function crushing_leap:OnSpellStart()

	self.caster = self:GetCaster()
	self.damage = self:GetSpecialValueFor("damage") or 0
	self.stunDuration = self:GetSpecialValueFor("stun_duration") or 0
	self.aoeRadius = self:GetSpecialValueFor("aoe_radius") or 0

	self.think = 3
	self.caster:AddNewModifier(self.caster, self, "modifier_signal_animation", {duration = self.think})
	self.caster:EmitSound("Hero_Undying.FleshGolem.Cast")
    Timers:CreateTimer(self.think, function()
    	self:Jump()
		return nil
    end
    )


end


function crushing_leap:Jump()
	if not self:GetCaster():IsNull() then

		local units = nil
		local target = nil
		units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.caster, self:GetCastRange(self.caster:GetAbsOrigin(),self.caster),
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		
		if units then
			target = units[RandomInt(1, #units)]
			if target then
				self.target = target
			else
				self.target = self.caster
			end
		end			
		

		self.caster:SetAbsOrigin(self.target:GetAbsOrigin())
		FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), true)
		self.caster:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stunDuration})
		self.caster:EmitSound("Hero_Warlock.RainOfChaos")
		ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_explosion.vpcf", PATTACH_ABSORIGIN, self.caster)


		local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.caster, self.aoeRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		
		if units then
			for i = 1, #units do
				if units[i] then
					units[i]:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stunDuration})
			        ApplyDamage({
			            victim = units[ i ],
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


