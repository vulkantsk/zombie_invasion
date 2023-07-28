LinkLuaModifier( "modifier_templar_assassin_refraction_custom_damage", "heroes/hero_templar/refraction/refraction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_absorb", "heroes/hero_templar/refraction/refraction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_reflect_cd", "heroes/hero_templar/refraction/refraction", LUA_MODIFIER_MOTION_NONE )







templar_assassin_refraction_custom = class({})



function templar_assassin_refraction_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf', context )

end







function templar_assassin_refraction_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_3") then 
    bonus = self.cd[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_3")]
end

    return self.BaseClass.GetCooldown( self, level ) - bonus
end





function templar_assassin_refraction_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_refraction_custom_damage", {duration = duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_refraction_custom_absorb", {duration = duration})
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Refraction")
	self:GetCaster():StartGesture(ACT_DOTA_CAST_REFRACTION)

	self:EndCooldown()
	self:SetActivated(false)
end


-- Урон

modifier_templar_assassin_refraction_custom_damage = class({})

function modifier_templar_assassin_refraction_custom_damage:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_templar_assassin_refraction_custom_damage:IsPurgable() return false end

function modifier_templar_assassin_refraction_custom_damage:OnCreated()
	self.instances = self:GetAbility():GetSpecialValueFor("instances")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then return end
	self:SetStackCount(self.instances)

	self.shield_procs = 0

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, true, false)
end

function modifier_templar_assassin_refraction_custom_damage:OnStackCountChanged()
	if not IsServer() then return end
	if self:GetStackCount() <= 0 then
		self:Destroy()

	

	end
end

function modifier_templar_assassin_refraction_custom_damage:OnRefresh()
	self.instances = self:GetAbility():GetSpecialValueFor("instances")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then return end
	self:SetStackCount(self.instances)
end

function modifier_templar_assassin_refraction_custom_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_templar_assassin_refraction_custom_damage:GetModifierPreAttack_BonusDamage()
local bonus = 0 

	return self.bonus_damage + bonus
end

function modifier_templar_assassin_refraction_custom_damage:OnAttackLanded(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	params.target:EmitSound("Hero_TemplarAssassin.Refraction.Damage")
	self:DecrementStackCount()




	if self:GetParent():HasModifier("modifier_templar_assassin_refraction_2") then 
		local heal = self:GetAbility().shield_heal[self:GetParent():GetUpgradeStack("modifier_templar_assassin_refraction_2")]*self:GetParent():GetMaxHealth()

		my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())
	end
end

function modifier_templar_assassin_refraction_custom_damage:GetTexture()
	return "templar_assassin_refraction_damage"
end


modifier_templar_assassin_refraction_custom_absorb = class({})

function modifier_templar_assassin_refraction_custom_absorb:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_templar_assassin_refraction_custom_absorb:IsPurgable() return false end

function modifier_templar_assassin_refraction_custom_absorb:OnCreated()
self.instances = self:GetAbility():GetSpecialValueFor("instances")

if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_4") then 
	self.instances = self.instances + self:GetAbility().shield_charges[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_4")]
end

self.damage_threshold = self:GetAbility():GetSpecialValueFor("damage_threshold")
if not IsServer() then return end
self:SetStackCount(self.instances)

if self.particle then
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

self.damage_count = 0

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 0, self:GetCaster():GetOrigin())
ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster():GetOrigin(), true );
ParticleManager:SetParticleControl( self.particle, 5, self:GetCaster():GetOrigin())
self:AddParticle(self.particle, false, false, -1, true, false)
end

function modifier_templar_assassin_refraction_custom_absorb:OnRefresh()
	self.instances = self:GetAbility():GetSpecialValueFor("instances")
	


	self.damage_threshold = self:GetAbility():GetSpecialValueFor("damage_threshold")
	if not IsServer() then return end
	self:SetStackCount(self.instances)
end

function modifier_templar_assassin_refraction_custom_absorb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
    return funcs
end






function modifier_templar_assassin_refraction_custom_absorb:OnStackCountChanged()
if not IsServer() then return end


if self:GetStackCount() <= 0 then
	self:Destroy()

	if self:GetParent():HasModifier("modifier_templar_assassin_refraction_5") then 
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().knockback_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		self:GetParent():EmitSound("TA.Shield_break")
		

		local wave_particle = ParticleManager:CreateParticle( "particles/ta_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(wave_particle)

		local particle = ParticleManager:CreateParticle("particles/ta_shield_exp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	end
end
end

function modifier_templar_assassin_refraction_custom_absorb:GetModifierTotal_ConstantBlock(params)
    if not IsServer() then return end
    if params.damage < self.damage_threshold then return end
    if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end

	self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

	local forward = self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()
	forward.z = 0
	forward = forward:Normalized()

	local particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_2, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlForward(particle_2, 1, forward)
	ParticleManager:SetParticleControlEnt(particle_2, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(particle_2)

	local update_ui = false

	if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_7") then 

	
			update_ui = true	

			
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_shield',  {max = self.instances, charges = self:GetStackCount() - 1, damage = mod:GetStackCount()})
	end
	if update_ui then 

		local stack = self:GetStackCount()
		if self:GetStackCount() == 0 then 
			stack = self.instances
		end
	end


    return params.damage
end



function modifier_templar_assassin_refraction_custom_absorb:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)
	
end

