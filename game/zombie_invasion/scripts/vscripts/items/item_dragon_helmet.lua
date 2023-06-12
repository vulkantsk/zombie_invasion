LinkLuaModifier("modifier_item_dragon_helmet", "items/item_dragon_helmet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dragon_helmet_stats", "items/item_dragon_helmet", LUA_MODIFIER_MOTION_NONE)

item_dragon_helmet = class({
    GetIntrinsicModifierName = function() return "modifier_item_dragon_helmet_stats" end
})

modifier_item_dragon_helmet_stats = class({
    isHidden = function() return false end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    } end
})

function modifier_item_dragon_helmet_stats:GetTexture()
	return "item_dragon_helmet"
end

function modifier_item_dragon_helmet_stats:OnCreated()
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")	
end

function modifier_item_dragon_helmet_stats:OnRefresh()
    self:OnCreated()

end

function modifier_item_dragon_helmet_stats:GetModifierBonusStats_Agility()
	return self.bonus_agility 
end

function modifier_item_dragon_helmet_stats:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_dragon_helmet_stats:GetModifierSpellAmplify_Percentage() 
    return self.spell_amp
end

function item_dragon_helmet:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	if target then point = target:GetOrigin() end

	local projectile_direction = point - caster:GetOrigin()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		bDeleteOnHit = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		fDistance = self:GetSpecialValueFor( "range" ),
		fStartRadius = self:GetSpecialValueFor( "start_radius" ),
		fEndRadius = self:GetSpecialValueFor( "end_radius" ),
		vVelocity = projectile_direction:Normalized() * self:GetSpecialValueFor( "speed" ),
	}

	ProjectileManager:CreateLinearProjectile(info)

	EmitSoundOn( "Hero_DragonKnight.BreathFire", caster )
end

function item_dragon_helmet:OnProjectileHit( target, location )
	if not target then return end

	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "duration" )

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
	}

	ApplyDamage(damageTable)

	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_item_dragon_helmet",
		{ duration = duration }
	)
end


modifier_item_dragon_helmet = {}

function modifier_item_dragon_helmet:IsHidden()
	return false
end

function modifier_item_dragon_helmet:IsDebuff()
	return true
end

function modifier_item_dragon_helmet:IsStunDebuff()
	return false
end

function modifier_item_dragon_helmet:IsPurgable()
	return true
end

function modifier_item_dragon_helmet:OnCreated( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "reduction" )
end

function modifier_item_dragon_helmet:OnRefresh( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "reduction" )	
end

function modifier_item_dragon_helmet:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_item_dragon_helmet:GetModifierDamageOutgoing_Percentage()
	return self.reduction
end
