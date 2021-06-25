

if exhausting_fireball == nil then
    exhausting_fireball = class({})
end

function exhausting_fireball:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end


function exhausting_fireball:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end


function exhausting_fireball:OnSpellStart()
	
	self.caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration") or 0
	--self.duration = 5
	self.think = 0.3
	self.projNumber = 0
	self.maxProj = math.floor(self.duration / self.think) 
	self.damage = self:GetSpecialValueFor("damage") or 0
	self.hTarget = nil

	self.caster:EmitSound("Hero_Nightstalker.Darkness")
	self.caster:AddNewModifier(self.caster, self, "modifier_cast_ray", {})

	Timers:CreateTimer(2, function()

		local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.caster, self:GetCastRange(self.caster:GetAbsOrigin(),self.caster),
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

		if units then
			self.hTarget = units[RandomInt(1, #units)]
		end

	    Timers:CreateTimer(0, function()
	    	self:CreateProjectile()
	    	self.projNumber = self.projNumber + 1
	    	   	
	    	if self.projNumber <= self.maxProj then
	    		return self.think
	    	end

			Timers:CreateTimer(1, function()
	    		self.caster:RemoveModifierByName("modifier_cast_ray")
	    		return nil
	    		end
	    		)

	    	return nil
	    end
	    )
	    return nil
	end
	)

end


function exhausting_fireball:CreateProjectile()

	if self:GetCaster() then
		if self.hTarget and self.caster then

			local vDirection = self.hTarget:GetAbsOrigin() - self.caster:GetAbsOrigin()
			vDirection = Vector(vDirection.x, vDirection.y, 0) 
			vDirection = vDirection:Normalized()				
			self.caster:SetForwardVector(vDirection)

			local data = {
				EffectName	= "particles/neutral_fx/satyr_hellcaller.vpcf",
				Ability = self,
				Source = self.caster,
				vSpawnOrigin = self.caster:GetAbsOrigin(),
				vVelocity = self.caster:GetForwardVector() * 1000 * 0.7, 
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


function exhausting_fireball:OnProjectileThink(vLocation)

	if self:GetCaster() then
		local units = FindUnitsInRadius( self.caster:GetTeamNumber(), vLocation, self.caster, 100,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

		if units then  
			for i = 1, #units do
				if units[i] then
					local modifier = units[i]:FindModifierByName("modifier_singe")
					
					ApplyDamage({
					    victim = units[i],
					    attacker = self.caster,
					    damage = self.damage,
					    damage_type = self:GetAbilityDamageType(),
					    ability = self
					   })

					if modifier then
						modifier:IncrementStackCount()
						modifier:ForceRefresh()
					else					
						units[i]:AddNewModifier(self.caster, self, "modifier_singe", {duration = 60})	
					end
				end
			end	
		end
	end

end