modifier_no_heal = class({})

--------------------------------------------------------------------------------

function modifier_no_heal:IsDebuff()
	return true
end

function modifier_no_heal:IsStunDebuff()
	return true
end


function modifier_no_heal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_no_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
	 
	}
 
	return funcs
end
--------------------------------------------------------------------------------
 function modifier_no_heal:GetDisableHealing()
	return 1
end

--------------------------------------------------------------------------------
function modifier_no_heal:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_no_heal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_no_heal:GetStatusEffectName()
	return "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_smoke_ti5.vpcf"
end

function modifier_no_heal:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

 