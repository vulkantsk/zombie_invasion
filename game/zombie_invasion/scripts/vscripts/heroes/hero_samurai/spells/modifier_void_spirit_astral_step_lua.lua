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
modifier_void_spirit_astral_step_lua = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_void_spirit_astral_step_lua:IsHidden()
	return false
end

function modifier_void_spirit_astral_step_lua:IsDebuff()
	return true
end

function modifier_void_spirit_astral_step_lua:IsStunDebuff()
	return false
end

function modifier_void_spirit_astral_step_lua:IsPurgable()
	return true
end

function modifier_void_spirit_astral_step_lua:GetAttributes()
	return 1
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_void_spirit_astral_step_lua:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_void_spirit_astral_step_lua:OnRefresh( kv )
	
end

function modifier_void_spirit_astral_step_lua:OnRemoved()
end

function modifier_void_spirit_astral_step_lua:OnDestroy()
	if not IsServer() then return end

	-- Apply damage
 
	    
	-- play effects
 
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_void_spirit_astral_step_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_void_spirit_astral_step_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_astral_step_lua:GetEffectName()
	return "particles/heroes/samurai_astral_step_debuff.vpcf"
end

function modifier_void_spirit_astral_step_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

 
 