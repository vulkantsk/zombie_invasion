LinkLuaModifier("modifier_ghoul_reincornation", "abilities/zombie/ghoul_reincornation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghoul_reincornation_active", "abilities/zombie/ghoul_reincornation", LUA_MODIFIER_MOTION_NONE)

 
ghoul_reincornation = class({})

function ghoul_reincornation:GetIntrinsicModifierName()
   return "modifier_ghoul_reincornation" 
end


if modifier_ghoul_reincornation == nil then
    modifier_ghoul_reincornation = class({})
end

function modifier_ghoul_reincornation:IsHidden()
	return true
end
 

function modifier_ghoul_reincornation:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MIN_HEALTH
    }
    return funcs
end

function modifier_ghoul_reincornation:GetMinHealth()
   return 1
end  

function modifier_ghoul_reincornation:OnCreated()
    self.ability = self:GetAbility()
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.heal_pct = self.ability:GetSpecialValueFor("heal_pct")/100
 
end  


function modifier_ghoul_reincornation:OnRefresh()
    self.ability = self:GetAbility()
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.heal_pct = self.ability:GetSpecialValueFor("heal_pct")/100
 
end  


function modifier_ghoul_reincornation:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() and params.unit:GetMaxHealth() * 0.1 >= params.unit:GetHealth()  then
            local target = params.attacker
            local unit = params.unit
            if target == self:GetParent() then
                return
            end
            
            unit:Purge( false, true, false, false, false )
	        local sound_cast = "Hero_LifeStealer.Rage"
	        EmitSoundOn( sound_cast, unit )    
            unit:AddNewModifier(unit, self:GetAbility(), "modifier_ghoul_reincornation_active", {duration = self.duration})
            unit:Heal(self.heal_pct*unit:GetMaxHealth(),unit)
            unit:RemoveAbility("ghoul_reincornation")
        end
    end
end

modifier_ghoul_reincornation_active = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ghoul_reincornation_active:IsHidden()
	return false
end

function modifier_ghoul_reincornation_active:IsDebuff()
	return false
end

function modifier_ghoul_reincornation_active:IsPurgable()
	return false
end


function modifier_ghoul_reincornation_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_ghoul_reincornation_active:StatusEffectPriority()
	return 60
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ghoul_reincornation_active:OnCreated( kv )
	-- references
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" ) -- special value
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_ghoul_reincornation_active:OnRefresh( kv )
	-- references
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" ) -- special value
end

function modifier_ghoul_reincornation_active:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ghoul_reincornation_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
	}

	return funcs
end
  

function modifier_ghoul_reincornation_active:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ghoul_reincornation_active:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ghoul_reincornation_active:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_CENTER_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
--	assert(loadfile("heroes/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_cast)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end