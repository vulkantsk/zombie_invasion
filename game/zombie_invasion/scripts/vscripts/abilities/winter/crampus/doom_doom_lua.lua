-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
doom_doom_lua = class({})

function doom_doom_lua:Precache(context)
	PrecacheAbilityResources({
		"particles/status_fx/status_effect_doom.vpcf",
		"particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf",
	}, {
		"Hero_DoomBringer.Doom",
	}, context)
end

LinkLuaModifier( "modifier_doom_passive", "abilities/winter/crampus/doom_doom_lua", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_doom_aura", "abilities/winter/crampus/doom_doom_lua", LUA_MODIFIER_MOTION_NONE )  
 LinkLuaModifier( "modifier_doom_doom_lua", "abilities/winter/crampus/doom_doom_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
 
function doom_doom_lua:GetIntrinsicModifierName()
    return "modifier_doom_passive"
end

 


 

modifier_doom_passive = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
 
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,

})
 
local doom = 0 
function modifier_doom_passive:OnTakeDamage( keys )
 if doom == 0 then
    if self:GetCaster():GetHealth() < self:GetCaster():GetMaxHealth() * 0.2  then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
 
      doom = doom + 1
        caster:AddNewModifier(caster, ability, "modifier_doom_aura", { })
 
   
    end
 end
end

modifier_doom_aura = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_doom_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_doom_aura:IsAura()
	return true
end

 
function modifier_doom_aura:GetModifierAura()
	return "modifier_doom_doom_lua"
end

function modifier_doom_aura:GetAuraRadius()
	return 1000
end

function modifier_doom_aura:GetAuraSearchTeam()
	if not self:GetParent():PassivesDisabled() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	end
end

 function modifier_doom_aura:GetAuraSearchType()
 
	
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_doom_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_doom_aura:OnCreated( kv )
	-- references
	self.aura_radius = 1000 -- special value
end

function modifier_doom_aura:OnRefresh( kv )
	-- references
	self.aura_radius = 1000
end


--------------------------------------------------------------------------------
modifier_doom_doom_lua = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_doom_doom_lua:IsHidden()
	return false
end

function modifier_doom_doom_lua:IsDebuff()
	return true
end

function modifier_doom_doom_lua:IsStunDebuff()
	return false
end

function modifier_doom_doom_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_doom_doom_lua:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.deniable = self:GetAbility():GetSpecialValueFor( "deniable_pct" )
	self.interval = 1

	-- scepter
	self.scepter = self:GetCaster():HasScepter()
	if self.scepter then
		damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" )
	end
	self.check_radius = 900

	if not IsServer() then return end
	-- precache and apply damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( self.damageTable )

	-- Start interval
	self:StartIntervalThink( self.interval )

	-- play effects
	self:PlayEffects()
end

function modifier_doom_doom_lua:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.deniable = self:GetAbility():GetSpecialValueFor( "deniable_pct" )

	-- scepter
	self.scepter = self:GetCaster():HasScepter()
	if self.scepter then
		damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" )
	end

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage

	-- Create Sound
	local sound_cast = "Hero_DoomBringer.Doom"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_doom_doom_lua:OnRemoved()
end

function modifier_doom_doom_lua:OnDestroy()
	if not IsServer() then return end
	-- stop sound
	local sound_cast = "Hero_DoomBringer.Doom"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_doom_doom_lua:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = self.scepter,
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = self:GetParent():GetHealthPercent()<self.deniable,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_doom_doom_lua:OnIntervalThink()
	-- Apply damage
	ApplyDamage( self.damageTable )

	-- scepter time check
	if self.scepter then
		-- get distance
		local distance = (self:GetParent():GetOrigin()-self:GetCaster():GetOrigin()):Length2D()
		if distance<self.check_radius then
			-- increment duration
			self:SetDuration( self:GetRemainingTime() + self.interval, true )
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_doom_doom_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function modifier_doom_doom_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_doom_doom_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
	local sound_cast = "Hero_DoomBringer.Doom"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	local effect_cast = assert(loadfile("heroes/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		MODIFIER_PRIORITY_SUPER_ULTRA, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end