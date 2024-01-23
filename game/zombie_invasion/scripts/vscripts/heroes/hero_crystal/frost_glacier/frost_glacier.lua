frost_glacier = {}
function frost_glacier:OnSpellStart()
	local caster = self:GetCaster()
	ProjectileManager:CreateLinearProjectile({
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		EffectName = "particles/glaicer.vpcf",
		fDistance = self:GetSpecialValueFor("distance"),
		fStartRadius = self:GetSpecialValueFor("starting_aoe"),
		fEndRadius = self:GetSpecialValueFor("final_aoe"),
		bHasFrontalCone = false,
		vVelocity = (self:GetCursorPosition()-caster:GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed"),
		bDeleteOnHit = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bProvidesVision = false,
	})
	EmitSoundOn( "Hero_Ancient_Apparition.IceVortexCast", caster )
end
function frost_glacier:OnProjectileHit( target, location )
	ApplyDamage({
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetIntellect(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	})
end