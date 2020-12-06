antimage_attack=class({})

function antimage_attack:OnSpellStart()
	local target = self:GetCursorTarget()
	target:EmitSound("Hero_Antimage.ManaBreak")
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_ATTACK)

	local effect = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, target)
	ParticleManager:ReleaseParticleIndex(pfx)
	target:SetMana(target:GetMana()-100)
end

