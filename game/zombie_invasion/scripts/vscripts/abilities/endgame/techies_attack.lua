techies_attack = class({})

function techies_attack:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_ATTACK)

	local info = {
		EffectName = "particles/units/heroes/hero_techies/techies_base_attack.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = caster,
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Techies.Attack", caster )
end

function techies_attack:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil  then
		hTarget:ForceKill(false)
		EmitSoundOn( "Hero_Techies.ProjectileImpact", hTarget )

	end
 end 
