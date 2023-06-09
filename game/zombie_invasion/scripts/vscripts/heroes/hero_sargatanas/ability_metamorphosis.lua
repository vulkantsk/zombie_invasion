ability_metamorphosis = {}

LinkLuaModifier( "modifier_ability_metamorphosis", "heroes/hero_sargatanas/ability_metamorphosis", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_metamorphosis_aura", "heroes/hero_sargatanas/ability_metamorphosis", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_metamorphosis_burn", "heroes/hero_sargatanas/ability_metamorphosis", LUA_MODIFIER_MOTION_NONE )
 function ability_metamorphosis:OnSpellStart()

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )

	caster:AddNewModifier(
		caster,
		self,
		"modifier_ability_metamorphosis",
		{ duration = duration }
	)

	caster:AddNewModifier(
		caster,
		self,
		"modifier_ability_metamorphosis_aura",
		{ duration = duration }
	)

end

 
modifier_ability_metamorphosis = {}

function modifier_ability_metamorphosis:IsHidden()
	return false
end

function modifier_ability_metamorphosis:IsDebuff()
	return false
end

function modifier_ability_metamorphosis:IsStunDebuff()
	return false
end

function modifier_ability_metamorphosis:IsPurgable()
	return false
end

function modifier_ability_metamorphosis:OnCreated( kv )
	self.bonus_resistance = self:GetAbility():GetSpecialValueFor( "bonus_resistance" ) * (self:GetParent():GetStrength()/0.2)
	self.max_resistance  = self:GetAbility():GetSpecialValueFor( "max_resistance" )
	self.resistance = math.min(self.bonus_resistance,self.max_resistance)
	print(self.resistance)
	EmitSoundOn( "Hero_Terrorblade.Metamorphosis", self:GetParent() )
end

function modifier_ability_metamorphosis:OnRefresh( kv )
	self:OnCreated( kv )
end

 

function modifier_ability_metamorphosis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_ability_metamorphosis:GetModifierModelScale()
	return 10
end

function modifier_ability_metamorphosis:GetModifierIncomingDamage_Percentage()
	return -self.resistance
end


function modifier_ability_metamorphosis:GetModifierModelChange()
	return "models/items/terrorblade/endless_purgatory_demon/endless_purgatory_demon.vmdl"
end

function modifier_ability_metamorphosis:GetModifierModelScale()
	return 10
end

function modifier_ability_metamorphosis:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end


function modifier_ability_metamorphosis:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_ability_metamorphosis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_ability_metamorphosis_aura = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,

})

 
function modifier_ability_metamorphosis_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
end

function modifier_ability_metamorphosis_aura:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_metamorphosis_aura:IsAura()
	return true
end

function modifier_ability_metamorphosis_aura:GetModifierAura()
	return "modifier_ability_metamorphosis_burn"
end

function modifier_ability_metamorphosis_aura:GetAuraRadius()
	return self.radius
end

function modifier_ability_metamorphosis_aura:GetAuraDuration()
	return 1
end

function modifier_ability_metamorphosis_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ability_metamorphosis_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_metamorphosis_aura:GetAuraSearchFlags()
	return 0
end

function modifier_ability_metamorphosis_aura:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity:GetPlayerOwnerID()~=self:GetParent():GetPlayerOwnerID() then
			return true
		end
	end

	return false
end

modifier_ability_metamorphosis_burn = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	    DeclareFunctions        = function(self) return 
        {
 			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
 			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        } end,
    GetEffectName           = function(self) return "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_ambient.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})



function modifier_ability_metamorphosis_burn:GetModifierAttackSpeedBonus_Constant()
	return (self:GetCaster():GetAgility() ) * self:GetAbility():GetSpecialValueFor("attack_speed_ag")
end

function modifier_ability_metamorphosis_burn:GetModifierPhysicalArmorBonus()
	return (self:GetCaster():GetAgility() ) * self:GetAbility():GetSpecialValueFor("armor_ag")
end