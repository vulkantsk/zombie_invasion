
if modifier_special_effect_legendary2 == nil then
    modifier_special_effect_legendary2 = class({})
end

function modifier_special_effect_legendary2:IsHidden()
	return true
end

function modifier_special_effect_legendary2:RemoveOnDeath()
	return false
end

function modifier_special_effect_legendary2:IsPurgable() 
	return false 
end

function modifier_special_effect_legendary2:OnCreated()

	local particleName2 = "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end

function modifier_special_effect_legendary2:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_legendary2:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_legendary2:AllowIllusionDuplicate()
	return true
end

modifier_special_effect_slark_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

 
 