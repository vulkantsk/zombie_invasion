demon_desolate = class({})

LinkLuaModifier("modifier_demon_desolate", "heroes/hero_demonslayer/demon_desolate/demon_desolate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_desolate_tear", "heroes/hero_demonslayer/demon_desolate/demon_desolate", LUA_MODIFIER_MOTION_NONE)

function demon_desolate:GetIntrinsicModifierName()
	return "modifier_demon_desolate"
end


modifier_demon_desolate = modifier_demon_desolate or class({})

function modifier_demon_desolate:IsHidden() return true end
function modifier_demon_desolate:IsDebuff() return false end
function modifier_demon_desolate:IsPurgable() return false end
function modifier_demon_desolate:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_desolate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_demon_desolate:OnCreated()
	if IsClient() then return end
	self.crit_damage = (self:GetAbility():GetLevelSpecialValueFor("crit_damage", 1) - 100) * 0.01
	self.crit_chance_per_negative_armor = self:GetAbility():GetLevelSpecialValueFor("crit_chance_per_negative_armor", 1)
	self.player = self:GetParent():GetPlayerOwner()

end

function modifier_demon_desolate:GetModifierProcAttack_Feedback(keys)
	if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end

	keys.target:EmitSound("Item_Desolator.Target")
	
	local modifier_demon_desolate = keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_demon_desolate_tear", {})
	if modifier_demon_desolate and not modifier_demon_desolate:IsNull() then modifier_demon_desolate:IncrementStackCount() end
end

function modifier_demon_desolate:GetModifierProcAttack_BonusDamage_Physical(keys)
	if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end

	if RollPseudoRandomPercentage(self:GetCritChance(keys.target), DOTA_PSEUDO_RANDOM_CUSTOM_GAME_7, keys.attacker) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, keys.target, (self.crit_damage + 1) * keys.damage, self.player)
		return self.crit_damage * keys.damage
	end

	return 0
end

function modifier_demon_desolate:GetCritChance(target)
	local armor = target:GetPhysicalArmorValue(false) * (-1)

	return math.max(0, math.min(100, armor * self.crit_chance_per_negative_armor))
end

function modifier_demon_desolate:OnTakeDamage( params )
	if  params.attacker == self:GetParent() and not params.unit:IsBuilding() and not params.unit:IsOther() and params.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
 

			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, params.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
		 
			params.attacker:Heal(params.damage * self:GetAbility():GetSpecialValueFor("lifesteal_pct"), params.attacker)
		end

end


modifier_demon_desolate_tear = class({})

function modifier_demon_desolate_tear:IsHidden() return false end
function modifier_demon_desolate_tear:IsDebuff() return true end
function modifier_demon_desolate_tear:IsPurgable() return false end

function modifier_demon_desolate_tear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_demon_desolate_tear:OnCreated()
	self.armor_tear = (-1) * self:GetAbility():GetSpecialValueFor("armor_tear")

	if IsClient() then return end

	self.rend_pfx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_maelstrom_impact_sparks.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.rend_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(self.rend_pfx, 2, Vector(0,0,0))
end


function modifier_demon_desolate_tear:OnStackCountChanged()
	if self.rend_pfx then
		ParticleManager:SetParticleControl(self.rend_pfx, 2, Vector(self:GetStackCount(), 0, 0))
	end
end

function modifier_demon_desolate_tear:OnDestroy()
	if self.rend_pfx then
		ParticleManager:DestroyParticle(self.rend_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.rend_pfx)
	end
end

function modifier_demon_desolate_tear:GetModifierPhysicalArmorBonus()
	return self.armor_tear * self:GetStackCount()
end

function modifier_demon_desolate_tear:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_demon_desolate_tear:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:Destroy()
end
