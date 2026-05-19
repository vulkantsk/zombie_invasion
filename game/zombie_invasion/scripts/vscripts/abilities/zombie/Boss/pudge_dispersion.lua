pudge_dispersion = class({})
 
LinkLuaModifier( "modifier_pudge_dispersion", "abilities/zombie/Boss/pudge_dispersion", LUA_MODIFIER_MOTION_NONE )
 

--------------------------------------------------------------------------------
-- Passive Modifier
function pudge_dispersion:GetIntrinsicModifierName()
	return "modifier_pudge_dispersion"
end

 
modifier_pudge_dispersion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pudge_dispersion:IsHidden()
	return true
end

function modifier_pudge_dispersion:IsDebuff()
	return true
end

function modifier_pudge_dispersion:IsStunDebuff()
	return false
end

function modifier_pudge_dispersion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_pudge_dispersion:OnCreated( kv )
	-- references
 self.block_dps = self:GetAbility():GetSpecialValueFor("block_dps")
 
end

 
 function modifier_pudge_dispersion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_pudge_dispersion:GetModifierIncomingDamage_Percentage()
	return -(self.block_dps) 
end


 