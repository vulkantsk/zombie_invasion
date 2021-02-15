 item_freez_shivas_guard = class({})

LinkLuaModifier("modifier_freez_shiva_passive", "items/magic/item_shivas_freez", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_freez_shivas_aura_debuff", "items/magic/item_shivas_freez", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freez_shiva_active_thinker", "items/magic/item_shivas_freez", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_freez_shivas_active_debuff", "items/magic/item_shivas_freez", LUA_MODIFIER_MOTION_NONE)

function item_freez_shivas_guard:GetIntrinsicModifierName() return "modifier_freez_shiva_passive" end

function item_freez_shivas_guard:GetCastRange()
	if not IsServer() then
		return (self:GetSpecialValueFor("blast_radius") - self:GetCaster():GetCastRangeBonus())
	end
end

function item_freez_shivas_guard:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	caster:AddNewModifier(caster, self, "modifier_freez_shiva_active_thinker", {duration = (self:GetSpecialValueFor("blast_radius") / self:GetSpecialValueFor("blast_speed"))})
end

modifier_freez_shiva_passive = class({})

function modifier_freez_shiva_passive:IsDebuff()			return false end
function modifier_freez_shiva_passive:IsHidden() 		return true end
function modifier_freez_shiva_passive:IsPurgable() 		return false end
function modifier_freez_shiva_passive:IsPurgeException() return false end
function modifier_freez_shiva_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end  
function modifier_freez_shiva_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_MANA_BONUS ,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end    
function modifier_freez_shiva_passive:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_int") end
function modifier_freez_shiva_passive:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_freez_shiva_passive:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_str") end
function modifier_freez_shiva_passive:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agi") end  
function modifier_freez_shiva_passive:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_freez_shiva_passive:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor("bonus_mana") end

function modifier_freez_shiva_passive:IsAura() return true end
function modifier_freez_shiva_passive:GetAuraDuration() return 1.0 end
function modifier_freez_shiva_passive:GetModifierAura() return "modifier_item_freez_shivas_aura_debuff" end
function modifier_freez_shiva_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_freez_shiva_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_freez_shiva_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_freez_shiva_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_freez_shiva_passive:GetAuraEntityReject(unit) return unit:HasModifier("modifier_item_imba_shivas_2_aura_debuff") end

modifier_item_freez_shivas_aura_debuff = class({})

function modifier_item_freez_shivas_aura_debuff:IsDebuff()			return true end
function modifier_item_freez_shivas_aura_debuff:IsHidden() 			return false end
function modifier_item_freez_shivas_aura_debuff:IsPurgable() 		return false end
function modifier_item_freez_shivas_aura_debuff:IsPurgeException() 	return false end
function modifier_item_freez_shivas_aura_debuff:GetTexture() return "item_shivas_guard" end
function modifier_item_freez_shivas_aura_debuff:OnCreated() self.ability = self:GetAbility() end
function modifier_item_freez_shivas_aura_debuff:OnDestroy() self.ability = nil end
function modifier_item_freez_shivas_aura_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_freez_shivas_aura_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self.ability:GetSpecialValueFor("aura_as_reduction")) end

modifier_freez_shiva_active_thinker = class({})

function modifier_freez_shiva_active_thinker:IsDebuff()			return false end
function modifier_freez_shiva_active_thinker:IsHidden() 			return true end
function modifier_freez_shiva_active_thinker:IsPurgable() 		return false end
function modifier_freez_shiva_active_thinker:IsPurgeException() 	return false end
function modifier_freez_shiva_active_thinker:RemoveOnDeath() 	return false end
function modifier_freez_shiva_active_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_freez_shiva_active_thinker:OnCreated()
	self.ability = self:GetAbility()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.ability:GetSpecialValueFor("blast_radius"), self:GetDuration() * 1.33, self.ability:GetSpecialValueFor("blast_speed")))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.hitted = {}
	end
end

function modifier_freez_shiva_active_thinker:OnIntervalThink()
	local radius_increase = (self.ability:GetSpecialValueFor("blast_speed") / (1.0 / FrameTime())) * 100
	self:SetStackCount(self:GetStackCount() + radius_increase)
	local radius = self:GetStackCount() / 100
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, FrameTime(), false)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not self.hitted[enemy:entindex()] then
			self.hitted[enemy:entindex()] = true
			local pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(pfx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
			enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_item_freez_shivas_active_debuff", {duration = self.ability:GetSpecialValueFor("slow_duration_tooltip")  * (1 - enemy:GetStatusResistance())})
		end
	end
end

function modifier_freez_shiva_active_thinker:OnDestroy()
	if IsServer() then
		local radius = self:GetStackCount() / 100
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, self.ability:GetSpecialValueFor("slow_duration_tooltip"), false)
		self.hitted = nil
	end
	self.ability = nil
end

modifier_item_freez_shivas_active_debuff = class({})

function modifier_item_freez_shivas_active_debuff:IsDebuff()			return true end
function modifier_item_freez_shivas_active_debuff:IsHidden() 		return false end
function modifier_item_freez_shivas_active_debuff:IsPurgable() 		return true end
function modifier_item_freez_shivas_active_debuff:IsPurgeException() return true end
function modifier_item_freez_shivas_active_debuff:GetTexture() return "item_shivas_guard" end
function modifier_item_freez_shivas_active_debuff:OnDestroy() self.ability = nil end
function modifier_item_freez_shivas_active_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_freez_shivas_active_debuff:GetModifierMoveSpeedBonus_Percentage() return  self.ability:GetSpecialValueFor("move_speed_acitve") end
function modifier_item_freez_shivas_active_debuff:GetModifierAttackSpeedBonus_Constant() return self.ability:GetSpecialValueFor("active_as_reduction") end
function modifier_item_freez_shivas_active_debuff:GetEffectName() return "particles/generic_gameplay/generic_slowed_cold.vpcf" end  
function modifier_item_freez_shivas_active_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_freez_shivas_active_debuff:OnCreated()
	self.ability = self:GetAbility()
	if IsServer() then
 
	end
end
