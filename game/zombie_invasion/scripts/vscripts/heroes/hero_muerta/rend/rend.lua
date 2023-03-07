innate_rend = class({})

LinkLuaModifier("modifier_innate_rend", "heroes/hero_muerta/rend/rend", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_rend_tear", "heroes/hero_muerta/rend/rend", LUA_MODIFIER_MOTION_NONE)

function innate_rend:GetIntrinsicModifierName()
	return "modifier_innate_rend"
end


modifier_innate_rend = modifier_innate_rend or class({})

function modifier_innate_rend:IsHidden() return true end
function modifier_innate_rend:IsDebuff() return false end
function modifier_innate_rend:IsPurgable() return false end
function modifier_innate_rend:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_rend:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end

function modifier_innate_rend:OnCreated()
	if IsClient() then return end
	self.crit_damage = (self:GetAbility():GetLevelSpecialValueFor("crit_damage", 1) - 100) * 0.01
	self.crit_chance_per_negative_armor = self:GetAbility():GetLevelSpecialValueFor("crit_chance_per_negative_armor", 1)
	self.player = self:GetParent():GetPlayerOwner()

end

function modifier_innate_rend:GetModifierProcAttack_Feedback(keys)
	if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end

	keys.target:EmitSound("Item_Desolator.Target")
	
	local modifier_rend = keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_innate_rend_tear", {})
	if modifier_rend and not modifier_rend:IsNull() then modifier_rend:IncrementStackCount() end
end

function modifier_innate_rend:GetModifierProcAttack_BonusDamage_Physical(keys)
	if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end

	if RollPseudoRandomPercentage(self:GetCritChance(keys.target), DOTA_PSEUDO_RANDOM_CUSTOM_GAME_7, keys.attacker) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, keys.target, (self.crit_damage + 1) * keys.damage, self.player)
		return self.crit_damage * keys.damage
	end

	return 0
end

function modifier_innate_rend:GetCritChance(target)
	local armor = target:GetPhysicalArmorValue(false) * (-1)

	return math.max(0, math.min(100, armor * self.crit_chance_per_negative_armor))
end


modifier_innate_rend_tear = class({})

function modifier_innate_rend_tear:IsHidden() return false end
function modifier_innate_rend_tear:IsDebuff() return true end
function modifier_innate_rend_tear:IsPurgable() return false end
function modifier_innate_rend_tear:GetTexture() return "innates/innate_rend" end

function modifier_innate_rend_tear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_innate_rend_tear:OnCreated()
	self.armor_tear = (-1) * self:GetAbility():GetSpecialValueFor("armor_tear")

	if IsClient() then return end

	self.rend_pfx = ParticleManager:CreateParticle("particles/custom/innates/rend_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.rend_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(self.rend_pfx, 2, Vector(1,0,0))
end

function modifier_innate_rend_tear:OnStackCountChanged()
	if self.rend_pfx then
		ParticleManager:SetParticleControl(self.rend_pfx, 2, Vector(self:GetStackCount(), 0, 0))
	end
end

function modifier_innate_rend_tear:OnDestroy()
	if self.rend_pfx then
		ParticleManager:DestroyParticle(self.rend_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.rend_pfx)
	end
end

function modifier_innate_rend_tear:GetModifierPhysicalArmorBonus()
	return self.armor_tear * self:GetStackCount()
end

function modifier_innate_rend_tear:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_rend_tear:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:Destroy()
end
