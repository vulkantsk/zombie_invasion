LinkLuaModifier( "modifier_zombie_suic", "abilities/zombie/zombie_suic", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_suic_2", "abilities/zombie/zombie_suic", LUA_MODIFIER_MOTION_NONE )

zombie_suic = class({})

function zombie_suic:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_techies/techies_suicide.vpcf",
	}, {
		"Hero_Techies.Suicide",
	}, context)
end

zombie_suic_2 = class({})

function zombie_suic_2:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_techies/techies_suicide.vpcf",
	}, {
		"Hero_Techies.Suicide",
	}, context)
end

 
function zombie_suic:GetIntrinsicModifierName()
    return "modifier_zombie_suic"
end

--------------------------------------------------------------------------------
-- Passive Modifier
function zombie_suic:OnOwnerDied()
 	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor('radius')

 

		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_CLOSEST,
			false
		)


	for _,unit in pairs(units) do
		DealDamage(caster, unit,self:GetSpecialValueFor('damage_basic'), self:GetAbilityDamageType(), self:GetAbilityTargetFlags(), self)
	end

 
	caster:EmitSound("Hero_Techies.Suicide")
	local nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_techies/techies_suicide.vpcf', PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(nfx, 1, Vector(radius/2, 0, 0))
	ParticleManager:SetParticleControl(nfx, 2, Vector(radius, 1, 1))
end

 
 modifier_zombie_suic = {}

function modifier_zombie_suic:IsHidden()
    return true
end

function modifier_zombie_suic:OnCreated()
 
	self:GetCaster():SetRenderColor(255, 0 , 0 )

end

function zombie_suic_2:GetIntrinsicModifierName()
    return "modifier_zombie_suic_2"
end

--------------------------------------------------------------------------------
-- Passive Modifier
function zombie_suic_2:OnOwnerDied()
 	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor('radius')

 

		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_CLOSEST,
			false
		)


	for _,unit in pairs(units) do
		DealDamage(caster, unit,self:GetSpecialValueFor('damage_basic'), self:GetAbilityDamageType(), self:GetAbilityTargetFlags(), self)
	end

 
	caster:EmitSound("Hero_Techies.Suicide")
	local nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_techies/techies_suicide.vpcf', PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(nfx, 1, Vector(radius/2, 0, 0))
	ParticleManager:SetParticleControl(nfx, 2, Vector(radius, 1, 1))
end

 
 modifier_zombie_suic_2 = {}

function modifier_zombie_suic_2:IsHidden()
    return true
end

function modifier_zombie_suic_2:OnCreated()
 
	self:GetCaster():SetRenderColor(255, 0 , 0 )

end