

if sizzling_ray == nil then
    sizzling_ray = class({})
end

function sizzling_ray:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end


function sizzling_ray:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function sizzling_ray:OnSpellStart()
	
	self.caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration") or 0
	self.think = 0.07
	self.rotate = 0
	self.maxRotate = math.floor(self.duration / self.think) 
	self.damage = self:GetSpecialValueFor("damage") or 0
	self.particleID = nil
	self.caster:EmitSound("Hero_Phoenix.SuperNova.Death")
	self.caster:AddNewModifier(self.caster, self, "modifier_cast_ray", {})

    Timers:CreateTimer(2, function()
    	self.caster:StopSound("Hero_Phoenix.SunRay.Cast")
    	self:RayAnimation()
    	self:ApplyDamageToTargets()
    	self.rotate = self.rotate + 1
    	   	
    	if self.rotate <= self.maxRotate then
    		return self.think
    	end

		if self.particleID then
			ParticleManager:DestroyParticle(self.particleID, false)
			ParticleManager:ReleaseParticleIndex(self.particleID)
			self.particleID = nil
		end  
		self.caster:StopSound("Hero_Phoenix.SunRay.Cast")

		Timers:CreateTimer(1, function()
    		self.caster:RemoveModifierByName("modifier_cast_ray")
    		return nil
    		end
    		)

    	return nil
    end
    )

end


function sizzling_ray:RayAnimation()
	
	if self.particleID then
		ParticleManager:DestroyParticle(self.particleID, false)
		ParticleManager:ReleaseParticleIndex(self.particleID)
		self.particleID = nil
	end

	self.caster:SetAngles( 0, 5*self.rotate, 0 )

	local particleName = "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf"
	self.particleID = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleID, 0, self.caster, PATTACH_POINT, "attach_hitloc", self.caster:GetAbsOrigin(), true )
	local endPoint = self.caster:GetAbsOrigin() + self.caster:GetForwardVector()*self:GetCastRange(self.caster:GetAbsOrigin(),self.caster)
	endPoint = GetGroundPosition( endPoint, nil )
	endPoint.z = 300
	ParticleManager:SetParticleControl( self.particleID, 1,endPoint)

	self.caster:EmitSound("Hero_Phoenix.SunRay.Cast")
end


function sizzling_ray:ApplyDamageToTargets()

	if self:GetCaster() then
		local data = {
			EffectName	= "particles/units/heroes/hero_lina/lina_base_attack_explosion_c.vpcf",
			Ability = self,
			Source = self.caster,
			vSpawnOrigin = self.caster:GetAbsOrigin(),
			vVelocity = self.caster:GetForwardVector() * 4000 * 0.7, 
			fStartRadius = 100,
			fEndRadius = 100,
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


function sizzling_ray:OnProjectileThink(vLocation)

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