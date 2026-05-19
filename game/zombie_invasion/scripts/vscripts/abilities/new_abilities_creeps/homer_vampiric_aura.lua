homer_vampiric_aura = class({})

function homer_vampiric_aura:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf",
		"particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf",
	}, {
	}, context)
end

LinkLuaModifier( "modifier_homer_vampiric_aura", "abilities/quest/homer_vampiric_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_homer_vampiric_aura_lifesteal", "abilities/quest/homer_vampiric_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function homer_vampiric_aura:GetIntrinsicModifierName()
	return "modifier_homer_vampiric_aura"
end
 
 function homer_vampiric_aura:Clas()
	return "modifier_homer_vampiric_aura"
end
modifier_homer_vampiric_aura = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_homer_vampiric_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_homer_vampiric_aura:IsAura()
	return true
end

function modifier_homer_vampiric_aura:GetEffectName()
	return "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"
end

function modifier_homer_vampiric_aura:GetModifierAura()
	return "modifier_homer_vampiric_aura_lifesteal"
end
  
function modifier_homer_vampiric_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_homer_vampiric_aura:GetAuraSearchTeam()
 
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
 
end

function modifier_homer_vampiric_aura:GetAuraSearchType()
 
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
 
	
	 
end

 

function modifier_homer_vampiric_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_homer_vampiric_aura:OnCreated( kv )
	-- references
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "vampiric_aura_radius" ) -- special value
end

function modifier_homer_vampiric_aura:OnRefresh( kv )
	-- references
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "vampiric_aura_radius" ) -- special value
end

modifier_homer_vampiric_aura_lifesteal = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_homer_vampiric_aura_lifesteal:IsHidden()
	return false
end

function modifier_homer_vampiric_aura_lifesteal:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_homer_vampiric_aura_lifesteal:OnCreated( kv )
	-- references
	self.aura_lifesteal = self:GetAbility():GetSpecialValueFor( "vampiric_aura" ) -- special value
end

function modifier_homer_vampiric_aura_lifesteal:OnRefresh( kv )
	-- references
	self.aura_lifesteal = self:GetAbility():GetSpecialValueFor( "vampiric_aura" ) -- special value
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_homer_vampiric_aura_lifesteal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_homer_vampiric_aura_lifesteal:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- filter
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				pass = true
			end
		end

		-- logic
		if pass then
			-- save attack record
			self.attack_record = params.record
		end
	end
end

function modifier_homer_vampiric_aura_lifesteal:OnTakeDamage( params )
	if IsServer() then
		-- filter
		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end

		-- logic
		if pass then
			-- get heal value
			local heal = params.damage * self.aura_lifesteal/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_homer_vampiric_aura_lifesteal:PlayEffects( target )
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end