ghost_speed = class({})
 

LinkLuaModifier( "modifier_ghost_speed", "abilities/zombie/ghost_speed", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function ghost_speed:GetIntrinsicModifierName()
	return "modifier_ghost_speed"
end

 

if modifier_ghost_speed == nil then
    modifier_ghost_speed = class({})
end

function modifier_ghost_speed:IsHidden()
	return true
end
 
function modifier_ghost_speed:RemoveOnDeath()
	return true
end

function modifier_ghost_speed:IsPurgable()
	return false
end

function modifier_ghost_speed:IsPurgeException()
	return false
end


function modifier_ghost_speed:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end
-- Initializations
function modifier_ghost_speed:OnCreated( kv )
	-- references
	self.min = self:GetAbility():GetSpecialValueFor( "min" )
	self.max =  self:GetAbility():GetSpecialValueFor( "max" )
		self:StartIntervalThink( 5.0 )
end

 function modifier_ghost_speed:OnIntervalThink()
 
	     	self.speed =  RandomInt(self.min, self.max)
     	 
end

--------------------------------------------------------------------------------
 

function modifier_ghost_speed:GetModifierMoveSpeedBonus_Constant()	
		return self.speed
end


 