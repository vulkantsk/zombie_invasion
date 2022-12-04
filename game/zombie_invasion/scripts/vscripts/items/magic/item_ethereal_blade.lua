LinkLuaModifier("modifier_item_imba_ethereal_blade", "items/magic/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_ethereal_blade_ethereal", "items/magic/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
 

item_ethereal_blade_2					= class({})
modifier_item_imba_ethereal_blade			= class({})
modifier_item_imba_ethereal_blade_ethereal	= class({})
modifier_item_imba_ethereal_blade_slow		= class({})

 

-------------------------
-- ETHEREAL BLADE BASE --
-------------------------

function item_ethereal_blade_2:GetIntrinsicModifierName()
	return "modifier_item_imba_ethereal_blade"
end

-- function item_imba_ethereal_blade:GetAbilityTextureName()
	-- if self:GetLevel() == 2 then
		-- if self:GetCaster():GetModifierStackCount("modifier_item_imba_rod_of_atos", self:GetCaster()) == self:GetSpecialValueFor("curtain_fire_activation_charge") then
			-- return "custom/imba_rod_of_atos_2_cfs"
		-- else
			-- return "custom/imba_rod_of_atos_2"
		-- end
	-- else
		-- return "item_rod_of_atos"
	-- end
-- end

function item_ethereal_blade_2:GetAOERadius()
 
		return self:GetSpecialValueFor( "splash_radius" )
	 

	 
end
 

--------------------------------------------------------------------------------
 

function item_ethereal_blade_2:OnSpellStart()
	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	self.blast_movement_slow		=	self:GetSpecialValueFor("blast_movement_slow")
	self.duration					=	self:GetSpecialValueFor("duration")
	self.blast_agility_multiplier	=	self:GetSpecialValueFor("blast_agility_multiplier")

	self.blast_damage_base			=	self:GetSpecialValueFor("blast_damage_base")
	self.duration_ally				=	self:GetSpecialValueFor("duration_ally")
	self.ethereal_damage_bonus		=	self:GetSpecialValueFor("ethereal_damage_bonus")
	self.projectile_speed			=	self:GetSpecialValueFor("projectile_speed")
 
	if not IsServer() then return end
	
	local target			= self:GetCursorTarget()
	local search = self:GetSpecialValueFor("splash_radius")

	local targets = {}
 
		targets = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

	-- Play the cast sound
	self.caster:EmitSound("DOTA_Item.EtherealBlade.Activate")
	for _,enemy in pairs(targets) do
	-- Fire the projectile
	local projectile =
			{
				Target 				= enemy,
				Source 				= self.caster,
				Ability 			= self,
				EffectName 			= "particles/items_fx/ethereal_blade.vpcf",
				iMoveSpeed			= self.projectile_speed,
				vSourceLoc 			= caster_location,
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 20,
				bProvidesVision 	= false,
			}
			
		ProjectileManager:CreateTrackingProjectile(projectile)
		end
end

function item_ethereal_blade_2:OnProjectileHit(target, location)
	if not IsServer() then return end
	
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then

		-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end
		
		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.EtherealBlade.Target")
		
		-- ...apply the Ethereal modifier...
		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_imba_ethereal_blade_ethereal", {duration = self.duration_ally})
			target:AddNewModifier(self.caster, self, "modifier_item_imba_gem_of_true_sight", {duration = self.duration}) -- The radius was designated with the "radius" KV for the item in npc_items_custom.txt (guess that's just how it works)
		else
			target:AddNewModifier(self.caster, self, "modifier_item_imba_ethereal_blade_ethereal", {duration = self.duration * (1 - target:GetStatusResistance())})
						
			-- ...apply the damage if it's an enemy...
			local damageTable = {
				victim 			= target,
				damage 			= self.caster:GetPrimaryStatValue() * self.blast_agility_multiplier + self.blast_damage_base,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self
			}
									
			ApplyDamage(damageTable)		
			
 
		end
	end
end

--------------------------------------
-- ETHEREAL BLADE ETHEREAL MODIFIER --
--------------------------------------
-- TODO: Change Pugna and Necrophos Ethereal to also use decrepify modifier property

function modifier_item_imba_ethereal_blade_ethereal:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_imba_ethereal_blade_ethereal:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability					= self:GetAbility()
	self.caster						= self:GetCaster()
	self.parent						= self:GetParent()
	
	self.ethereal_damage_bonus		= self.ability:GetSpecialValueFor("ethereal_damage_bonus")
 

	self.blast_movement_slow				=	self:GetAbility():GetSpecialValueFor("blast_movement_slow")
	self.realms_grasp_turn_rate_reduction	= 	self:GetAbility():GetSpecialValueFor("realms_grasp_turn_rate_reduction")
	self.realms_grasp_cast_time_lag	= 	self:GetAbility():GetSpecialValueFor("realms_grasp_cast_time_lag")

	self:StartIntervalThink(FrameTime())
end

 

function modifier_item_imba_ethereal_blade_ethereal:OnRefresh()
	self:OnCreated()
end

function modifier_item_imba_ethereal_blade_ethereal:GetTexture()
	return "item_ethereal_blade_2"
end

function modifier_item_imba_ethereal_blade_ethereal:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end

function modifier_item_imba_ethereal_blade_ethereal:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

 
		-- IMBAfication: Extrasensory
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		  
    }
	
	return decFuncs
end

function modifier_item_imba_ethereal_blade_ethereal:GetModifierMoveSpeedBonus_Percentage()
    return self.blast_movement_slow
end

function modifier_item_imba_ethereal_blade_ethereal:GetModifierTurnRate_Percentage()
	return self.realms_grasp_turn_rate_reduction
end

 
	

function modifier_item_imba_ethereal_blade_ethereal:GetModifierMagicalResistanceDecrepifyUnique()
    return self.ethereal_damage_bonus
end

function modifier_item_imba_ethereal_blade_ethereal:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_imba_ethereal_blade_ethereal:GetModifierIgnoreCastAngle()
	if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
		return 1
	end
end

 
-----------------------------
-- ETHEREAL BLADE MODIFIER --
-----------------------------

function modifier_item_imba_ethereal_blade:IsHidden()		return true end
function modifier_item_imba_ethereal_blade:IsPurgable()		return false end
function modifier_item_imba_ethereal_blade:RemoveOnDeath()	return false end
function modifier_item_imba_ethereal_blade:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_ethereal_blade:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_imba_ethereal_blade:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_item_imba_ethereal_blade:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_agility")
	end
end

function modifier_item_imba_ethereal_blade:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intellect")
	end
end

function modifier_item_imba_ethereal_blade:GetModifierSpellAmplify_Percentage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("spell_amp")
	end
end

function modifier_item_imba_ethereal_blade:GetModifierMPRegenAmplify_Percentage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("spell_amp")
	end
end