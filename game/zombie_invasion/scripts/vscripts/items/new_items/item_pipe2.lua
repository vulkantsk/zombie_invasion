LinkLuaModifier("modifier_pipe2_active", "items/new_items/item_pipe2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe2_aura", "items/new_items/item_pipe2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe2_buff", "items/new_items/item_pipe2", LUA_MODIFIER_MOTION_NONE)

item_pipe2 = class({})

function item_pipe2:GetIntrinsicModifierName()
	return "modifier_item_pipe2_aura"
end

modifier_item_pipe2_buff = class({})

function modifier_item_pipe2_buff:IsDebuff() return false end
function modifier_item_pipe2_buff:IsHidden() return false end
function modifier_item_pipe2_buff:IsPurgable() return false end

function modifier_item_pipe2_buff:OnCreated()
	self.aura_resist    =   self:GetAbility():GetSpecialValueFor("aura_resist")
end
function modifier_item_pipe2_buff:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_pipe2_buff:GetModifierMagicalResistanceBonus()
	return self.aura_resist
end

modifier_item_pipe2_aura = class ({})

function modifier_item_pipe2_aura:IsHidden()		return false end
function modifier_item_pipe2_aura:IsPurgable()		return false end
function modifier_item_pipe2_aura:RemoveOnDeath()	return false end
function modifier_item_pipe2_aura:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_pipe2_aura:IsAura() return true end

function modifier_item_pipe2_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_pipe2_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_item_pipe2_aura:GetModifierAura()
	return "modifier_item_pipe2_buff"
end

function modifier_item_pipe2_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("buff_radius")
end

function modifier_item_pipe2_aura:DeclareFunctions()  
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_pipe2_aura:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("res")
end

function item_pipe2:OnSpellStart()
	if IsServer() then
		local buff_duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("buff_radius")
		local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
		print("P:",units)
		for _, ally in pairs(units) do
			ally:AddNewModifier(self:GetCaster(), self, "modifier_pipe2_active", {duration = buff_duration})
		end
	end
end

modifier_item_pipe2_active class({})

function modifier_item_pipe2_active:IsDebuff() return false end
function modifier_item_pipe2_active:IsHidden() return false end

function modifier_item_pipe2_active:OnCreated( params )
	if not self:GetAbility() then self:Destroy() return end

	self.barrier_block			= self:GetAbility():GetSpecialValueFor("barrier_block")
	self.barrier_health			= self.barrier_block

end