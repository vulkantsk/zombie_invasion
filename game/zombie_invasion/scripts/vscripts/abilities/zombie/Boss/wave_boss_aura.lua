wave_boss_aura = class({})
 
LinkLuaModifier( "modifier_wave_boss_aura", "abilities/zombie/Boss/wave_boss_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wave_boss_slow", "abilities/zombie/Boss/wave_boss_aura", LUA_MODIFIER_MOTION_NONE )
 
function wave_boss_aura:GetIntrinsicModifierName()
	return "modifier_wave_boss_aura"
end

modifier_wave_boss_aura = class({})
--------------------------------------------------------------------------------
function modifier_wave_boss_aura:IsDebuff()
	return true
end

 function modifier_wave_boss_aura:RemoveOnDeath()
	return true
end
    

function modifier_wave_boss_aura:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_wave_boss_aura:IsAura()
		return true
end

--------------------------------------------------------------------------------

function modifier_wave_boss_aura:GetModifierAura()
	return "modifier_wave_boss_slow"
end

--------------------------------------------------------------------------------

function modifier_wave_boss_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_wave_boss_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

 
--------------------------------------------------------------------------------

function modifier_wave_boss_aura:GetAuraRadius()
	return -1
end

 
 modifier_wave_boss_slow = class({})
 

--------------------------------------------------------------------------------
function modifier_wave_boss_slow:IsDebuff()
	return true
end

 function modifier_wave_boss_slow:RemoveOnDeath()
	return true
end
    

function modifier_wave_boss_slow:IsHidden()
	return true
end


 function modifier_wave_boss_slow:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
	return funcs
end


function modifier_wave_boss_slow:GetModifierMoveSpeedBonus_Constant( params )
	if self:GetCaster() == self:GetParent() then 
		return nil 
	else
	    return -550
	end
end
 