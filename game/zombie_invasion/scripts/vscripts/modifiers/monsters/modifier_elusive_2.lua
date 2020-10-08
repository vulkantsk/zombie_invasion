
if modifier_elusive_2 == nil then
    modifier_elusive_2 = class({})
end

function modifier_elusive_2:IsHidden()
	return false
end

function modifier_elusive_2:GetTexture()
    return "riki_blink_strike"
end

function modifier_elusive_2:RemoveOnDeath()
	return true
end

function modifier_elusive_2:CanBeAddToMinions()
    return true
end

function modifier_elusive_2:IsPurgable()
	return false
end

function modifier_elusive_2:IsPurgeException()
	return false
end

function modifier_elusive_2:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
    }
    return funcs
end

function modifier_elusive_2:GetModifierEvasion_Constant()	
	return self.evasionBonus or 100
end

function modifier_elusive_2:OnCreated()
	self.evasionBonus = 100

	if IsServer() then
		self:GetParent():SetRenderColor(72, 61, 139)
	end
end


