item_veil_of_discord_2 = item_veil_of_discord_2 or class({})
 
LinkLuaModifier("modifier_veil_passive", "items/magic/item_discord_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_debuff_aura_modifier", "items/magic/item_discord_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_buff_aura", "items/magic/item_discord_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_buff_aura_modifier", "items/magic/item_discord_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_active_debuff", "items/magic/item_discord_2", LUA_MODIFIER_MOTION_NONE)

function item_veil_of_discord_2:OnSpellStart()
	-- Ability properties
	local caster        =   self:GetCaster()
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/items2_fx/veil_of_discord.vpcf"

	-- Emit sound
	caster:EmitSound("DOTA_Item.VeilofDiscord.Activate")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("debuff_radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(caster:GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("debuff_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)

	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff
		enemy:AddNewModifier(caster, self, "modifier_veil_active_debuff", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end

function item_veil_of_discord_2:GetAOERadius()
	return self:GetSpecialValueFor("debuff_radius")
end

function item_veil_of_discord_2:GetIntrinsicModifierName()
	return "modifier_veil_passive"
end

 

--- ACTIVE DEBUFF MODIFIER
modifier_veil_active_debuff = modifier_veil_active_debuff or class({})

-- Modifier properties
function modifier_veil_active_debuff:IsDebuff() return true end
function modifier_veil_active_debuff:IsHidden() return false end
function modifier_veil_active_debuff:IsPurgable() return true end

function modifier_veil_active_debuff:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.spell_amp    =   self:GetAbility():GetSpecialValueFor("spell_amp")
end

-- TODO: Check that this works
function modifier_veil_active_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_veil_active_debuff:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return self.spell_amp
	end
end

function modifier_veil_active_debuff:GetTexture()
	return "item_veil_of_discord_2"
end

function modifier_veil_active_debuff:OnTooltip()
	return self.spell_amp
end


function modifier_veil_active_debuff:GetEffectName()
	return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_veil_active_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------
--- PASSIVE STAT/BUFF AURA ---
------------------------------
modifier_veil_passive = modifier_veil_passive or class({})

-- Modifier properties

function modifier_veil_passive:IsHidden()		return true end
function modifier_veil_passive:IsPurgable()		return false end
function modifier_veil_passive:RemoveOnDeath()	return false end
function modifier_veil_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_veil_passive:IsAura() return true end

function modifier_veil_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
		self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_veil_buff_aura", {})
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_all_stats              =   ability:GetSpecialValueFor("bonus_all_stats")
 
	end
end

-- Various stat bonuses
function modifier_veil_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

-- Stats
function modifier_veil_passive:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_veil_passive:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_veil_passive:GetModifierBonusStats_Strength() return self.bonus_all_stats end

--- DEBUFF AURA
 

function modifier_veil_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

 

function modifier_veil_passive:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_veil_passive:OnDestroy()
	if IsServer() and self and not self:IsNull() and self:GetParent() and not self:GetParent():IsNull() then
		self:GetParent():RemoveModifierByName("modifier_veil_buff_aura")
	end
end

--- AURA DEBUFF MODIFIER
 

-----------------
--- BUFF AURA ---
-----------------
modifier_veil_buff_aura = modifier_veil_buff_aura or class({})

-- Modifier properties
function modifier_veil_buff_aura:IsHidden() return true end
function modifier_veil_buff_aura:IsPurgable() return false end
function modifier_veil_buff_aura:RemoveOnDeath() return false end
function modifier_veil_buff_aura:IsAura() return true end

function modifier_veil_buff_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_veil_buff_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_veil_buff_aura:GetModifierAura()
	return "modifier_veil_buff_aura_modifier"
end

function modifier_veil_buff_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

--- AURA BUFF MODIFIER
modifier_veil_buff_aura_modifier = modifier_veil_buff_aura_modifier or class({})

-- Modifier properties
function modifier_veil_buff_aura_modifier:IsDebuff() return false end
function modifier_veil_buff_aura_modifier:IsHidden() return false end
function modifier_veil_buff_aura_modifier:IsPurgable() return true end

function modifier_veil_buff_aura_modifier:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.aura_mana_regen	= self:GetAbility():GetSpecialValueFor("aura_mana_regen")
 
end

function modifier_veil_buff_aura_modifier:GetTexture()
	return "item_veil_of_discord_2"
end

function modifier_veil_buff_aura_modifier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
 
	}
end

function modifier_veil_buff_aura_modifier:GetModifierConstantManaRegen()
	return self.aura_mana_regen
end

 