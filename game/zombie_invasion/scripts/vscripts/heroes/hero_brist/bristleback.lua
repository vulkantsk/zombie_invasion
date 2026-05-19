ability_bristleback = class({})

function ability_bristleback:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf",
		"particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf",
	}, {
		"Hero_Bristleback.Bristleback",
	}, context)
end

function ability_bristleback:GetIntrinsicModifierName() return 'modifier_ability_bristleback_buff' end

LinkLuaModifier('modifier_ability_bristleback_buff', 'heroes/hero_brist/bristleback', LUA_MODIFIER_MOTION_NONE)
-- Original https://github.com/EarthSalamander42/dota_imba/blob/77d0b1f04e322812d16b0fce6e0089c24c4a38e2/game/dota_addons/dota_imba_reborn/scripts/vscripts/components/abilities/heroes/hero_bristleback.lua#L548-L628

modifier_ability_bristleback_buff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
})


function modifier_ability_bristleback_buff:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self.ability:GetSpecialValueFor("side_angle")
	self.back_angle					= self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
	self.armor_bonus				= self.ability:GetSpecialValueFor("armor_bonus")
    self.damageTaken                = self.damageTaken or 0

    self.scepter_thr1 = self.ability:GetSpecialValueFor("quill_release_threshold_scepter1")
    self.scepter_thr2 = self.ability:GetSpecialValueFor("quill_release_threshold_scepter2")
    self.scepter_thr3 = self.ability:GetSpecialValueFor("quill_release_threshold_scepter3")
    self.scepter_thr4 = self.ability:GetSpecialValueFor("quill_release_threshold_scepter4")

end

function modifier_ability_bristleback_buff:OnRefresh()
	self:OnCreated()
end

function modifier_ability_bristleback_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_ability_bristleback_buff:GetModifierIncomingDamage_Percentage(keys)
    if self.parent:PassivesDisabled() or 
    bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or 
    bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end

	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)
	
	-- There's 100% a more straightforward way to calculate this but I can't think properly right now
	if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
		--print("Hit the back ", (self.back_damage_reduction), "%")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle2)
		
		self.parent:EmitSound("Hero_Bristleback.Bristleback")
		
		return self.back_damage_reduction * (-1)
	elseif (difference <= (self.side_angle / 2)) or (difference >= (360 - (self.side_angle / 2))) then 
		--print("Hit the side", (self.side_damage_reduction), "%")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		
		return self.side_damage_reduction * (-1)
	else
		--print("Hit the front")
		return self.front_damage_reduction * (-1)
	end
end

function modifier_ability_bristleback_buff:OnTakeDamage( keys )

	if keys.unit == self.parent then
 
		if self.parent:PassivesDisabled() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS or not self.parent:HasAbility("ability_quill_spray") or not self.parent:FindAbilityByName("ability_quill_spray"):IsTrained() then return end
	
		-- Pretty inefficient to calculate this stuff twice but I don't want to make these class variables due to how much damage might stack in a single frame...
		local forwardVector			= self.caster:GetForwardVector()
		local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
				
		local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
		local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

		local difference = math.abs(forwardAngle - reverseEnemyAngle)
 
        if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
                        
            self.damageTaken = self.damageTaken + keys.damage
 

			local quill_spray_ability = self.parent:FindAbilityByName("ability_quill_spray")
			
			if quill_spray_ability and quill_spray_ability:IsTrained() and self.damageTaken >= self.quill_release_threshold then
  					if self:GetParent():HasScepter() then 
  						local count_qu_spray = 0

 						if self.damageTaken <= self.scepter_thr1 then 
 							Timers:CreateTimer(0,function()

 								if count_qu_spray == 1 then return end
 								quill_spray_ability:OnSpellStart()
 								count_qu_spray = count_qu_spray + 1

 								return 1
 						 	end)
 						elseif self.damageTaken <= self.scepter_thr2 then 
 							Timers:CreateTimer(0,function()

 								if count_qu_spray == 2 then return end
 								quill_spray_ability:OnSpellStart()
 								count_qu_spray = count_qu_spray + 1

 								return 0.8
 						 	end)
 						elseif self.damageTaken <= self.scepter_thr3 then 
 							Timers:CreateTimer(0,function()

 								if count_qu_spray == 3 then return end
 								quill_spray_ability:OnSpellStart()
 								count_qu_spray = count_qu_spray + 1

 								return 0.7
 						 	end)
 						elseif self.damageTaken < self.scepter_thr4 then 
 							Timers:CreateTimer(0,function()

 								if count_qu_spray == 4 then return end
 								quill_spray_ability:OnSpellStart()
 								count_qu_spray = count_qu_spray + 1

 								return 0.6
 						 	end)
 						elseif self.damageTaken >= self.scepter_thr4 then 
 							Timers:CreateTimer(0,function()

 								if count_qu_spray == 5 then return end
 								quill_spray_ability:OnSpellStart()
 								count_qu_spray = count_qu_spray + 1

 								return 0.5
 						 	end) 			
 						end

 					else 
 						quill_spray_ability:OnSpellStart()
 					end
 			 
  

                --local count = 0
                --while(self.damageTaken >= self.quill_release_threshold and count < 10) do 
                    --self.damageTaken = self.damageTaken - self.quill_release_threshold
                    --count = count + 1
                    --if count == 5 then
                    	--self.damageTaken = 0
                    --end
               --end
               self.damageTaken = self.damageTaken % self.quill_release_threshold

			end
		end
	end
end

function modifier_ability_bristleback_buff:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end
