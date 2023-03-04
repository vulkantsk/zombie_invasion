if modifier_special_effect_admin == nil then
    modifier_special_effect_admin = class({})
end

function modifier_special_effect_admin:IsHidden()
	return true
end

function modifier_special_effect_admin:RemoveOnDeath()
	return false
end

function modifier_special_effect_admin:IsPurgable() 
	return false 
end

function modifier_special_effect_admin:OnCreated()

	local particleName2 = "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal_buff_ring.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
end

function modifier_special_effect_admin:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_admin:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_admin:AllowIllusionDuplicate()
	return true
end

modifier_special_effect_slark_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
if modifier_special_effect_admin2 == nil then
    modifier_special_effect_admin2 = class({})
end

function modifier_special_effect_admin2:IsHidden()
	return true
end

function modifier_special_effect_admin2:RemoveOnDeath()
	return false
end

function modifier_special_effect_admin2:IsPurgable() 
	return false 
end

function modifier_special_effect_admin2:OnCreated()

	local particleName2 = "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8_swoosh.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
	local particleName2 = "particles/econ/events/ti10/emblem/ti10_emblem_effect_ring_twinkle.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end

function modifier_special_effect_admin2:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_admin2:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_admin2:AllowIllusionDuplicate()
	return true
end

modifier_special_effect_slark_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
if modifier_special_effect_admin3 == nil then
    modifier_special_effect_admin3 = class({})
end

function modifier_special_effect_admin3:IsHidden()
	return true
end

function modifier_special_effect_admin3:RemoveOnDeath()
	return false
end

function modifier_special_effect_admin3:IsPurgable() 
	return false 
end

function modifier_special_effect_admin3:OnCreated()

	
	local particleName2 = "particles/econ/events/ti10/emblem/ti10_emblem_effect_ring_twinkle.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end

function modifier_special_effect_admin3:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_admin3:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_admin3:AllowIllusionDuplicate()
	return true
end

modifier_special_effect_slark_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})