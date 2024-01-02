
item_fire_shivas_guard = class({})

 
 
LinkLuaModifier("modifier_fire_shiva_active_thinker", "items/magic/item_shivas_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_shiva_fire", "items/magic/item_shivas_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_shiva_passive", "items/magic/item_shivas_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_debuff", "items/magic/item_shivas_fire", LUA_MODIFIER_MOTION_NONE)
 

function item_fire_shivas_guard:GetIntrinsicModifierName() return "modifier_fire_shiva_passive" end
 



function item_fire_shivas_guard:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	caster:AddNewModifier(caster, self, "modifier_fire_shiva_active_thinker", {duration = (self:GetSpecialValueFor("blast_radius") / self:GetSpecialValueFor("blast_speed"))})
end

 
 

modifier_fire_shiva_active_thinker = class({})

function modifier_fire_shiva_active_thinker:IsDebuff()			return false end
function modifier_fire_shiva_active_thinker:IsHidden() 			return true end
function modifier_fire_shiva_active_thinker:IsPurgable() 		return false end
function modifier_fire_shiva_active_thinker:IsPurgeException() 	return false end
function modifier_fire_shiva_active_thinker:RemoveOnDeath() 	return false end
function modifier_fire_shiva_active_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_fire_shiva_active_thinker:OnCreated()
	self.ability = self:GetAbility()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti10/shivas_guard_ti10_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.ability:GetSpecialValueFor("blast_radius"), self:GetDuration() * 1.33, self.ability:GetSpecialValueFor("blast_speed")))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.hitted = {}
	end
end

function modifier_fire_shiva_active_thinker:OnIntervalThink()
	local radius_increase = (self.ability:GetSpecialValueFor("blast_speed") / (1.0 / FrameTime())) * 100
	self:SetStackCount(self:GetStackCount() + radius_increase)
	local radius = self:GetStackCount() / 100
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, FrameTime(), false)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not self.hitted[enemy:entindex()] then
			self.hitted[enemy:entindex()] = true
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti10/shivas_guard_ti10_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(pfx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
            enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_fire_shiva_fire", {duration = self.ability:GetSpecialValueFor("duration_fire")  * (1 - enemy:GetStatusResistance())})
		end
	end
end

function modifier_fire_shiva_active_thinker:OnDestroy()
	if IsServer() then
		local radius = self:GetStackCount() / 100
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, self.ability:GetSpecialValueFor("slow_duration_tooltip"), false)
		self.hitted = nil
	end
	self.ability = nil
end 


modifier_fire_shiva_passive = class({})

function modifier_fire_shiva_passive:IsDebuff()			return false end
function modifier_fire_shiva_passive:IsHidden() 			return true end
function modifier_fire_shiva_passive:IsPurgable() 		return false end
function modifier_fire_shiva_passive:IsPurgeException() 	return false end
function modifier_fire_shiva_passive:RemoveOnDeath() 	return false end
function modifier_fire_shiva_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_fire_shiva_passive:OnCreated()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
 	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
  	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
 	self.aura_radius =  self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_fire_shiva_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

	}
end

function modifier_fire_shiva_passive:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_fire_shiva_passive:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_fire_shiva_passive:GetModifierBonusStats_Intellect()
    return self.bonus_int
end

function modifier_fire_shiva_passive:IsAura() 				return true end
function modifier_fire_shiva_passive:IsAuraActiveOnDeath()	return false end

function modifier_fire_shiva_passive:GetAuraRadius()			return self.aura_radius end
function modifier_fire_shiva_passive:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_fire_shiva_passive:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY  end
function modifier_fire_shiva_passive:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC  end
function modifier_fire_shiva_passive:GetModifierAura()			return "modifier_imba_radiance_debuff" end


modifier_imba_radiance_debuff = class({})

function modifier_imba_radiance_debuff:OnDestroy() self.ability = nil end
function modifier_imba_radiance_debuff:IsDebuff()			return true end
function modifier_imba_radiance_debuff:IsHidden() 			return false end
function modifier_imba_radiance_debuff:IsPurgable() 		return false end
function modifier_imba_radiance_debuff:IsPurgeException() 	return false end
function modifier_imba_radiance_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MISS_PERCENTAGE} end
function modifier_imba_radiance_debuff:GetModifierMiss_Percentage() return self.ability:GetSpecialValueFor("miss_chance") end

function modifier_imba_radiance_debuff:OnCreated()
	self.ability = self:GetAbility()
	if IsServer() then
		self:StartIntervalThink(self.ability:GetSpecialValueFor("interval_radiance"))
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_radiance_debuff:GetTexture()
     return "item_fire_shiva"
end
function modifier_imba_radiance_debuff:OnIntervalThink()
	local dmg = self.ability:GetSpecialValueFor("damage_radiance")
 	local spell_amp = self:GetCaster():GetSpellAmplification(false)
		 
	dmg = dmg * (spell_amp + 1) / (1.0 / self.ability:GetSpecialValueFor("interval_radiance")) 
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self.ability, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
end


modifier_fire_shiva_fire = class({})

function modifier_fire_shiva_fire:IsDebuff()			return true end
function modifier_fire_shiva_fire:IsHidden() 			return false end
function modifier_fire_shiva_fire:IsPurgable() 		return true end
function modifier_fire_shiva_fire:RemoveOnDeath() 	return true end


function modifier_fire_shiva_fire:OnCreated()
     	self:StartIntervalThink( 0.4 )
end

function modifier_fire_shiva_fire:OnIntervalThink()

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage_fire_per_second"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})


end
function modifier_fire_shiva_fire:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_fire_shiva_fire:GetTexture()
	return "item_fire_shiva"
end
