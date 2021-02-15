item_veil_of_discord_3 = item_veil_of_discord_3 or class({})
LinkLuaModifier("modifier_veil_passive_3", "items/magic/item_discord_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_buff_aura_3", "items/magic/item_discord_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_buff_aura_modifier_3", "items/magic/item_discord_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_active_debuff_3", "items/magic/item_discord_3", LUA_MODIFIER_MOTION_NONE)

function item_veil_of_discord_3:OnSpellStart()
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
		enemy:AddNewModifier(caster, self, "modifier_veil_active_debuff_3", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end

function item_veil_of_discord_3:GetAOERadius()
	return self:GetSpecialValueFor("debuff_radius")
end

function item_veil_of_discord_3:GetIntrinsicModifierName()
	return "modifier_veil_passive_3"
end

--- ACTIVE DEBUFF MODIFIER
modifier_veil_active_debuff_3 = modifier_veil_active_debuff_3 or class({})

-- Modifier properties
function modifier_veil_active_debuff_3:IsDebuff() return true end
function modifier_veil_active_debuff_3:IsHidden() return false end
function modifier_veil_active_debuff_3:IsPurgable() return true end

function modifier_veil_active_debuff_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
 if self:GetCaster():HasModifier("modifier_veil_active_debuff") then 
    RemoveModifierByName("modifier_veil_active_debuff")
 end
	self.spell_amp    =   self:GetAbility():GetSpecialValueFor("spell_amp")
end

-- TODO: Check that this works
function modifier_veil_active_debuff_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_veil_active_debuff_3:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return self.spell_amp
	end
end

function modifier_veil_active_debuff_3:OnTooltip()
	return self.spell_amp
end

function modifier_veil_active_debuff_3:GetTexture()
	return "item_veil_of_discord_3"
end

function modifier_veil_active_debuff_3:GetEffectName()
	return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_veil_active_debuff_3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------
--- PASSIVE STAT/BUFF AURA ---
------------------------------
modifier_veil_passive_3 = modifier_veil_passive_3 or class({})

-- Modifier properties

function modifier_veil_passive_3:IsHidden()		return true end
function modifier_veil_passive_3:IsPurgable()		return false end
function modifier_veil_passive_3:RemoveOnDeath()	return false end
function modifier_veil_passive_3:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_veil_passive_3:IsAura() return true end

function modifier_veil_passive_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
		self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_veil_buff_aura_3", {})
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.bonus_all_stats              =   ability:GetSpecialValueFor("bonus_all_stats")
 
	end
end

-- Various stat bonuses
function modifier_veil_passive_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

-- Stats
function modifier_veil_passive_3:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_veil_passive_3:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_veil_passive_3:GetModifierBonusStats_Strength() return self.bonus_all_stats end

--- DEBUFF AURA
 

function modifier_veil_passive_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

 

function modifier_veil_passive_3:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_veil_passive_3:OnDestroy()
	if IsServer() and self and not self:IsNull() and self:GetParent() and not self:GetParent():IsNull() then
		self:GetParent():RemoveModifierByName("modifier_veil_buff_aura_3")
	end
end

--- AURA DEBUFF MODIFIER
 

-----------------
--- BUFF AURA ---
-----------------
modifier_veil_buff_aura_3 = modifier_veil_buff_aura_3 or class({})

-- Modifier properties
function modifier_veil_buff_aura_3:IsHidden() return true end
function modifier_veil_buff_aura_3:IsPurgable() return false end
function modifier_veil_buff_aura_3:RemoveOnDeath() return false end
function modifier_veil_buff_aura_3:IsAura() return true end

function modifier_veil_buff_aura_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_veil_buff_aura_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_veil_buff_aura_3:GetModifierAura()
	return "modifier_veil_buff_aura_modifier_3"
end

function modifier_veil_buff_aura_3:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

--- AURA BUFF MODIFIER
modifier_veil_buff_aura_modifier_3 = modifier_veil_buff_aura_modifier_3 or class({})

-- Modifier properties
function modifier_veil_buff_aura_modifier_3:IsDebuff() return false end
function modifier_veil_buff_aura_modifier_3:IsHidden() return false end
function modifier_veil_buff_aura_modifier_3:IsPurgable() return true end

function modifier_veil_buff_aura_modifier_3:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.aura_mana_regen	= self:GetAbility():GetSpecialValueFor("aura_mana_regen")
 
end


function modifier_veil_buff_aura_modifier_3:GetTexture()
	return "item_veil_of_discord_3"
end

function modifier_veil_buff_aura_modifier_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_veil_buff_aura_modifier_3:GetModifierConstantManaRegen()
	return self.aura_mana_regen
end

 