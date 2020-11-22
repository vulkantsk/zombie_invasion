ursa_enrage_lua = class({})
 

LinkLuaModifier( "modifier_ursa_enrage_lua", "heroes/hero_axe/ursa_energy/ursa_enrage_lua", LUA_MODIFIER_MOTION_NONE )

function ursa_enrage_lua:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE

 	if self:GetCaster():HasScepter() then
 		behavior = behavior + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
 	end

 	return behavior
end

function ursa_enrage_lua:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, level )
end

function ursa_enrage_lua:OnSpellStart()
	self:GetCaster():Purge(false, true, false, true, false)

	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_ursa_enrage_lua",
		{ duration = self:GetSpecialValueFor("duration") }
	)

	EmitSoundOn( "zakaz_madam", self:GetCaster() )
end

modifier_ursa_enrage_lua = {}

function modifier_ursa_enrage_lua:IsHidden()
	return false
end

function modifier_ursa_enrage_lua:IsDebuff()
	return false
end

function modifier_ursa_enrage_lua:IsPurgable()
	return false
end

function modifier_ursa_enrage_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

 


function modifier_ursa_enrage_lua:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_ursa_enrage_lua:GetModifierModelScale()
	return 40
end

function modifier_ursa_enrage_lua:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("status_resistance")
end

function modifier_ursa_enrage_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

 
 

function modifier_ursa_enrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




 