

if crushing_explosion == nil then
    crushing_explosion = class({})
end

VECTOR_TABLE = {
	Vector(-1,-1,0),
	Vector(-1,0,0),
	Vector(-1,1,0),
	Vector(0,-1,0),
	Vector(0,1,0),
	Vector(1,-1,0),
	Vector(1,0,0),
	Vector(1,1,0)
}	


function crushing_explosion:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function crushing_explosion:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )
end


function crushing_explosion:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function crushing_explosion:OnSpellStart()

	self.caster = self:GetCaster()
	self.damage = self:GetSpecialValueFor("damage") or 0
	self.stunDuration = self:GetSpecialValueFor("stun_duration") or 0
	self.aoeRadius = self:GetSpecialValueFor("aoe_radius") or 0
	self.think = 2.5
	self.caster:AddNewModifier(self.caster, self, "modifier_signal_animation", {duration = self.think})
	self.caster:EmitSound("Hero_Nevermore.RequiemOfSoulsCast")

    Timers:CreateTimer(self.think, function()
    	self:Jump()
    	self:CreateProjectile()
		return nil
    end
    )

end


function crushing_explosion:Jump()
	if self:GetCaster() then
		FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), true)
		self.caster:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stunDuration})
		self.caster:EmitSound("Hero_Nevermore.RequiemOfSouls")
		self.caster:EmitSound("Hero_Warlock.RainOfChaos")
		ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiem_head.vpcf", PATTACH_ABSORIGIN, self.caster)
		ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7_golden/antimage_blink_start_ti7_golden_flame.vpcf", PATTACH_ABSORIGIN, self.caster)


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


function crushing_explosion:CreateProjectile()
	if self:GetCaster() then	

		for i = 1, #VECTOR_TABLE do 
			local data = {
				EffectName	= "particles/neutral_fx/satyr_hellcaller.vpcf",
				Ability = self,
				Source = self.caster,
				vSpawnOrigin = self.caster:GetAbsOrigin(),
				vVelocity = VECTOR_TABLE[i] * 1000 * 0.7, 
				fStartRadius = 50,
				fEndRadius = 50,
				fDistance = self:GetCastRange(self.caster:GetAbsOrigin(),self.caster),
				iUnitTargetTeams = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetTypes = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iVisionTeamNumber = self.caster:GetTeamNumber(),
				iVisionRadius = 100
			}
			ProjectileManager:CreateLinearProjectile( data )
		end
	end

end


function crushing_explosion:OnProjectileThink(vLocation)

	if self:GetCaster() then
		local units = FindUnitsInRadius( self.caster:GetTeamNumber(), vLocation, self.caster, 100,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

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

end