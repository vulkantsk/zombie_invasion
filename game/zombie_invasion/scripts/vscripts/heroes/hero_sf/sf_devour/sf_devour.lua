--------------------------------------------------------------------------------
sf_devour = class({})

function sf_devour:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf",
	}, {
		"Hero_DoomBringer.Devour",
		"Hero_DoomBringer.DevourCast",
	}, context)
end

 

LinkLuaModifier( "modifier_sf_devour", "heroes/hero_sf/sf_devour/sf_devour", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sf_devour_endless", "heroes/hero_sf/sf_devour/sf_devour", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Cast Filter
function sf_devour:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
				hTarget,
                self:GetAbilityTargetTeam(),
                self:GetAbilityTargetType(),
                self:GetAbilityTargetFlags(),
                self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	if hTarget:GetLevel() ~= 1 then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function sf_devour:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "devour_time" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sf_devour", -- modifier name
		{ duration = duration } -- kv
	)

 

	-- Play effects and no draw
	self:PlayEffects( target )
	target:SetOrigin( target:GetOrigin() + Vector( 0, 0, -200 ) )

	-- kill target
	target:Kill( self, caster )
end
 

--------------------------------------------------------------------------------
function sf_devour:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	local sound_cast = "Hero_DoomBringer.Devour"
	local sound_target = "Hero_DoomBringer.DevourCast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end
 

 
modifier_sf_devour = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_EVENT_ON_DEATH,
        } end,

})
 
 
--------------------------------------------------------------------------------
function modifier_sf_devour:OnCreated( kv )
	-- references
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
end

function modifier_sf_devour:OnRefresh( kv )
	
end

function modifier_sf_devour:OnRemoved()
end

function modifier_sf_devour:OnDestroy()
	if not IsServer() then return end
	-- grant bonus gold if alive
	if self:GetParent():IsAlive() then
		PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )

		if not self:GetParent():HasModifier("modifier_sf_devour_endless") then 
		 	local modif = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_sf_devour_endless", {})
		 	modif:SetStackCount(1)
		else 
			local modif = self:GetParent():FindModifierByName("modifier_sf_devour_endless")
			modif:IncrementStackCount()
		end
	end
end
 


 

modifier_sf_devour_endless = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        } end,
})

function modifier_sf_devour_endless:OnCreated( kv )
	-- references
	self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

end

function modifier_sf_devour_endless:OnRefresh( kv )
	self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )	
end

function modifier_sf_devour_endless:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * self.bonus_movespeed 
end


function modifier_sf_devour_endless:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.bonus_armor
end

function modifier_sf_devour_endless:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount() * self.bonus_damage
end