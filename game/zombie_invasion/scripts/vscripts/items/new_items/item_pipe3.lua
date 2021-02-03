LinkLuaModifier("modifier_pipe3_active", "items/new_items/item_pipe3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe3_aura", "items/new_items/item_pipe3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe3_buff", "items/new_items/item_pipe3", LUA_MODIFIER_MOTION_NONE)

item_pipe3 = class({})

function item_pipe3:GetIntrinsicModifierName()
	return "modifier_item_pipe3_aura"
end

modifier_item_pipe3_buff = class({})

function modifier_item_pipe3_buff:IsDebuff() return false end
function modifier_item_pipe3_buff:IsHidden() return false end
function modifier_item_pipe3_buff:IsPurgable() return false end

function modifier_item_pipe3_buff:OnCreated()
	self.aura_resist    =   self:GetAbility():GetSpecialValueFor("aura_resist")
end
function modifier_item_pipe3_buff:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_pipe3_buff:GetModifierMagicalResistanceBonus()
	return self.aura_resist
end

modifier_item_pipe3_aura = class ({})

function modifier_item_pipe3_aura:IsHidden()		return false end
function modifier_item_pipe3_aura:IsPurgable()		return false end
function modifier_item_pipe3_aura:RemoveOnDeath()	return false end
function modifier_item_pipe3_aura:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_pipe3_aura:IsAura() return true end

function modifier_item_pipe3_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_pipe3_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_item_pipe3_aura:GetModifierAura()
	return "modifier_item_pipe3_buff"
end

function modifier_item_pipe3_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("buff_radius")
end

function modifier_item_pipe3_aura:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_pipe3_aura:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("res")
end

function item_pipe3:OnSpellStart()
	if IsServer() then
		local buff_duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("buff_radius")
		local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
		print("P:",units)
		for _, ally in pairs(units) do
			ally:AddNewModifier(self:GetCaster(), self, "modifier_pipe3_active", {duration = buff_duration})
		end
	end
end

modifier_pipe3_active = class({
	IsHidden = function(self) return false end,
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}end,
})

function modifier_pipe3_active:GetAbsoluteNoDamageMagical()
	return 1
end