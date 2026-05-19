
if modifier_special_effect_zombie == nil then
    modifier_special_effect_zombie = class({})
end

function modifier_special_effect_zombie:IsHidden()
	return true
end

function modifier_special_effect_zombie:RemoveOnDeath()
	return false
end

function modifier_special_effect_zombie:IsPurgable() 
	return false 
end

function modifier_special_effect_zombie:OnCreated()

	local particleName2 = "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_base_b.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end

function modifier_special_effect_zombie:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_zombie:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_zombie:AllowIllusionDuplicate()
	return true
end

modifier_special_effect_slark_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate 	= function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})


if modifier_special_effect_zombie2 == nil then
    modifier_special_effect_zombie2 = class({})
end

function modifier_special_effect_zombie2:IsHidden()
	return true
end

function modifier_special_effect_zombie2:RemoveOnDeath()
	return false
end

function modifier_special_effect_zombie2:IsPurgable() 
	return false 
end

function modifier_special_effect_zombie2:OnCreated()

	local particleName2 = "particles/econ/items/omniknight/omni_crimson_witness_2021/omniknight_crimson_witness_2021_degen_aura_debuff.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end
function modifier_special_effect_zombie2:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_zombie2:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_zombie2:AllowIllusionDuplicate()
	return true
end

if modifier_special_effect_zombie3 == nil then
    modifier_special_effect_zombie3 = class({})
end

function modifier_special_effect_zombie3:IsHidden()
	return true
end

function modifier_special_effect_zombie3:RemoveOnDeath()
	return false
end

function modifier_special_effect_zombie3:IsPurgable() 
	return false 
end

function modifier_special_effect_zombie3:OnCreated()

	local particleName2 = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,self:GetParent())

end
function modifier_special_effect_zombie3:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_zombie3:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_zombie3:AllowIllusionDuplicate()
	return true
end

 
 