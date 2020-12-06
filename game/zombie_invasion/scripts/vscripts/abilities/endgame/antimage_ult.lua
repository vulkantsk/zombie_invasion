antimage_ult=class({})

function antimage_ult:OnSpellStart()
	local target = self:GetCursorTarget()
	target:EmitSound("Hero_Antimage.ManaVoid")
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

	local effect = "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 1, Vector(400,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
end

