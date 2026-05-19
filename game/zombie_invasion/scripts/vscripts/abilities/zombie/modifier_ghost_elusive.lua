modifier_ghost_elusive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ghost_elusive:IsHidden()
	return true
end

 
--------------------------------------------------------------------------------
-- Initializations
function modifier_ghost_elusive:OnCreated( kv )
	-- references
	local gate_main = Entities:FindByName(nil, 'gate_main') or nil
	print(gate_main)
	if gate_main then 
	    self.miss = self:GetAbility():GetSpecialValueFor( "miss" ) -- special value
    else 
	    self.miss = 0 
    end
 
end


function modifier_ghost_elusive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

function modifier_ghost_elusive:GetModifierEvasion_Constant( kv )
	if not self:GetParent():PassivesDisabled()   then
	    return self.miss
	end
 
end
