modifier_portal_unit_vision = {}

function modifier_portal_unit_vision:IsHidden()
	return true
end

function modifier_portal_unit_vision:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_portal_unit_vision:GetModifierProvidesFOWVision()
	return 1
end

function modifier_portal_unit_vision:CheckState()
    local state = {
    [MODIFIER_STATE_PROVIDES_VISION]=true,     --MODIFIER_STATE_PROVIDES_VISION
}      
    return state
end


function modifier_portal_unit_vision:OnCreated()
 
     		Timers:CreateTimer(0, function()  
 
  
     end)
      		Timers:CreateTimer(5, function()  
 
         	self:GetParent():RemoveModifierByName("modifier_portal_unit_vision" )
     end)
end


 