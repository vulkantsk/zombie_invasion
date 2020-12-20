juggernaut_shadow = class({})
 

LinkLuaModifier( "modifier_juggernaut_shadow", "heroes/hero_samurai/spells/shadow_spell", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function juggernaut_shadow:GetIntrinsicModifierName()
	return "modifier_juggernaut_shadow"
end

 
 
 modifier_juggernaut_shadow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_shadow:IsHidden()
	return true
end

 
--------------------------------------------------------------------------------
-- Initializations
function modifier_juggernaut_shadow:OnCreated( kv )
	-- references
	self.miss = self:GetAbility():GetSpecialValueFor( "miss" ) -- special value
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "speed_atack" ) -- special value
end

function modifier_juggernaut_shadow:OnRefresh( kv )
	-- references
	self.miss = self:GetAbility():GetSpecialValueFor( "miss" ) -- special value
	self.speed_atack = self:GetAbility():GetSpecialValueFor( "speed_atack" ) -- special value
end

function modifier_juggernaut_shadow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_juggernaut_shadow:GetModifierEvasion_Constant( kv )
		if not self:GetParent():PassivesDisabled() then
	 return self.miss
	end
 
end

function modifier_juggernaut_shadow:GetModifierBaseAttackTimeConstant()
	if not self:GetParent():PassivesDisabled() then
		return self.speed_atack
	end
end
