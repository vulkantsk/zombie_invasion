ability_surge = class({})

LinkLuaModifier( "modifier_ability_surge", "heroes/hero_dark_seer/surge/surge", LUA_MODIFIER_MOTION_NONE )

function ability_surge:OnSpellStart()

  	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetCastRange(self:GetCaster():GetAbsOrigin(),self:GetCaster())
		local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		print("P:",units)
		for _, ally in pairs(units) do
			ally:AddNewModifier(self:GetCaster(), self, "modifier_ability_surge", {duration = duration})
		end
	end

end

modifier_ability_surge = class({})

function modifier_ability_surge:IsHidden()
	return false
end

function modifier_ability_surge:IsDebuff()
	return false
end

function modifier_ability_surge:IsStunDebuff()
	return false
end

function modifier_ability_surge:IsPurgable()
	return true
end

function modifier_ability_surge:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed_boost" )

	if not IsServer() then
		return
	end

	EmitSoundOn( "Hero_Dark_Seer.Surge", self:GetParent() )
end

function modifier_ability_surge:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_surge:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_ability_surge:GetModifierMoveSpeedBonus_Constant()
	return self.speed
end

function modifier_ability_surge:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_ability_surge:GetActivityTranslationModifiers()
	return "haste"
end

function modifier_ability_surge:CheckState()
	local state = {
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
end

function modifier_ability_surge:GetEffectName()
	return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end

function modifier_ability_surge:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end