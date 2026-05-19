LinkLuaModifier( "modifier_warlock_chaos", "abilities/zombie/warlock_chaos", LUA_MODIFIER_MOTION_NONE )

warlock_chaos = class({})

function warlock_chaos:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf",
		"particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf",
	}, {
		"Hero_Warlock.RainOfChaos",
		"Hero_Warlock.RainOfChaos_buildup",
	}, context)
end

 
function warlock_chaos:GetIntrinsicModifierName()
	return "modifier_warlock_chaos"
end


--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function warlock_chaos:OnAbilityPhaseStart()
      EmitSoundOn("Hero_Warlock.RainOfChaos_buildup",  self:GetCaster())
      self.effect_cast_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	  ParticleManager:SetParticleControl( self.effect_cast_start, 0, self:GetCursorPosition() )
	  ParticleManager:SetParticleControl( self.effect_cast_start, 1, Vector( self:GetSpecialValueFor("radius"), 0, 0 ) )

 end
function warlock_chaos:OnAbilityPhaseInterrupted()
      StopSoundOn("Hero_Warlock.RainOfChaos_buildup", self:GetCaster())     
      ParticleManager:DestroyParticle(self.effect_cast_start, true)
end


function warlock_chaos:OnSpellStart()
 
 	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor( "duration" )
 
    local unit = CreateUnitByName("npc_classic_warlock_golem", point, true, caster, caster, caster:GetTeam())
 
	unit:AddNewModifier(caster, self, "modifier_kill", {duration = duration})

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		point,
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{duration = self:GetSpecialValueFor("duration_stun")})
	end
      self.effect_cast_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	  ParticleManager:SetParticleControl( self.effect_cast_start, 0, self:GetCursorPosition() )
	  ParticleManager:SetParticleControl( self.effect_cast_start, 1, Vector( self:GetSpecialValueFor("radius"), 0, 0 ) )
 
 
	EmitSoundOn( "Hero_Warlock.RainOfChaos", caster )
end 

function warlock_chaos:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

 


 
modifier_warlock_chaos = class({
	IsHidden 				= function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MODEL_SCALE,
            MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        } end,
 
})

function modifier_warlock_chaos:GetModifierModelScale()
	if self:GetParent():HasAbility("warlock_chaos") then return nil end
	return self.model_scale
end

function modifier_warlock_chaos:GetModifierBaseAttack_BonusDamage()
	if self:GetParent():HasAbility("warlock_chaos") then  return nil end
	return self.base_damage
end

function modifier_warlock_chaos:GetModifierIncomingDamage_Percentage()
	if self:GetParent():HasAbility("warlock_chaos") then return nil end
	return self.reduc_damage
end

function modifier_warlock_chaos:IsAura()
	if self:GetCaster() == self:GetParent() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_warlock_chaos:GetModifierAura()
	return "modifier_warlock_chaos"
end

--------------------------------------------------------------------------------

function modifier_warlock_chaos:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_warlock_chaos:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_warlock_chaos:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_warlock_chaos:OnCreated( kv )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )
	self.reduc_damage = self:GetAbility():GetSpecialValueFor( "reduc_damage" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
 
end