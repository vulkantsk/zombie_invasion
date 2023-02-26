
if modifier_special_effect_legendary == nil then
    modifier_special_effect_legendary = class({})
end

function modifier_special_effect_legendary:IsHidden()
	return true
end

function modifier_special_effect_legendary:RemoveOnDeath()
	return false
end

function modifier_special_effect_legendary:IsPurgable() 
	return false 
end

function modifier_special_effect_legendary:OnCreated()

	local particleName2 = "particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end

function modifier_special_effect_legendary:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_legendary:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_legendary:AllowIllusionDuplicate()
	return true
end

modifier_special_effect_slark_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

 
 