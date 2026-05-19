star_devour = {}

LinkLuaModifier( "modifier_star_devour", "heroes/hero_sargatanas/star_devour", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_star_devour_stack", "heroes/hero_sargatanas/star_devour", LUA_MODIFIER_MOTION_NONE )


function star_devour:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end
	 

	return UF_SUCCESS
end

function star_devour:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "devour_time" )

	caster:AddNewModifier(
		caster,
		self,
		"modifier_star_devour",
		{ duration = duration }
	)

	if target:IsNeutralUnitType() and self:GetAutoCastState() and not self:IsStolen() then
		local targetAbilities = {}

		for i = 0,5 do
			local ability = target:GetAbilityByIndex( i )

			if ability then
				table.insert( targetAbilities, ability:GetAbilityName() )

				if #targetAbilities > 1 then
					break
				end
			end
		end

		if #targetAbilities > 0 then
			for i = 1, 2 do
				local empty = "doom_bringer_empty" .. i
				local newAbilityName = targetAbilities[i] or empty
				local oldAbilityName = caster:GetAbilityByIndex( i + self.addIndex ):GetAbilityName()

				if newAbilityName ~= oldAbilityName then
					local ability = caster:AddAbility( newAbilityName )
					caster:SwapAbilities( oldAbilityName, newAbilityName, false, true )
					caster:RemoveAbility( oldAbilityName )

					if newAbilityName ~= empty then
						ability:SetLevel( 1 )
					end
				end
			end
		end
	end

	target:AddNoDraw()

	target:Kill( self, caster )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )

	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)

	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_DoomBringer.Devour", self:GetCaster() )
	EmitSoundOn( "Hero_DoomBringer.DevourCast", target )
end

function star_devour:OnUpgrade()
	if self:GetLevel() == 1 then
		if not self:GetAutoCastState() then
			self:ToggleAutoCast()
		end
	end

	if not self.addIndex then
		for i = 0, 10 do
			local ability = self:GetCaster():GetAbilityByIndex( i )

			if ability and ability:GetAbilityName() == "doom_bringer_empty1" then
				self.addIndex = i - 1

				break
			end
		end
	end
end

modifier_star_devour = {}

function modifier_star_devour:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_star_devour:IsHidden()
	return false
end

function modifier_star_devour:IsDebuff()
	return false
end

function modifier_star_devour:IsPurgable()
	return false
end

function modifier_star_devour:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_star_devour:RemoveOnDeath()
	return false
end

function modifier_star_devour:OnCreated( kv )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "regen" )
	self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
end

function modifier_star_devour:OnDestroy()
	if not IsServer() then return end
	if self:GetParent():IsAlive() then
		PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )

		if self:GetParent():HasModifier("modifier_star_devour_stack") then 
			local modif = self:GetParent():FindModifierByName("modifier_star_devour_stack")
			if modif:GetStackCount() == self.max_stack then 
				modif:SetStackCount(self.max_stack)
			else
				modif:IncrementStackCount()
			end
		else 
			local modif = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_star_devour_stack", {})

				modif:SetStackCount(1)
 
		end
	end
end

function modifier_star_devour:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_star_devour:GetModifierConstantHealthRegen()
	return self.bonus_regen
end

modifier_star_devour_stack = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

