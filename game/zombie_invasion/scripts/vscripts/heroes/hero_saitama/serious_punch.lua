saitama_serious_punch = class({})

if IsServer() then
	function saitama_serious_punch:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		if not target:TriggerSpellAbsorb(self) then
			target:TriggerSpellReflect(self)
			local damage = caster:GetAverageTrueAttackDamage(target) * (self:GetSpecialValueFor("base_damage_multiplier_pct") + self:GetSpecialValueFor("damage_multiplier_per_stack_pct") * caster:GetModifierStackCount("modifier_saitama_limiter", caster)) * 0.01

			target:EmitSound("Hero_Earthshaker.EchoSlam")
			ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_mid_egset.vpcf", PATTACH_ABSORIGIN, target)

			ApplyDamage({
				attacker = caster,
				victim = target,
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self
			})

			-- Добавляем клиф атаку
			GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), 300, false)
			local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			local stacks = caster:GetModifierStackCount("modifier_saitama_limiter", caster)
			target:AddNewModifier(caster, self, "modifier_knockback", {
				center_x = target:GetAbsOrigin().x - direction.x,
				center_y = target:GetAbsOrigin().y - direction.y,
				center_z = target:GetAbsOrigin().z,
				duration = 0.5,
				knockback_duration = 0.5 + 0.1 * stacks,
				knockback_distance = 300 + 50 * stacks,
				knockback_height = 200 + 20 * stacks
			})
			DoCleaveAttack(caster, target, self, damage, 300, 600, 650, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf")

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage, nil)	
		end
	end
end
