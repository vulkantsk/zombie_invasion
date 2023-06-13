LinkLuaModifier("modifier_item_dragon_sword", "items/item_dragon_sword", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_dragon_sword_disarmor", "items/item_dragon_sword", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_dragon_sword_disarmor_tear", "items/item_dragon_sword", LUA_MODIFIER_MOTION_NONE )

item_dragon_sword = class({
    GetIntrinsicModifierName = function() return "modifier_item_dragon_sword" end
})

function item_dragon_sword:OnSpellStart() 

   self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_demon_absolute_form", {duration = 6 } )
   
end

modifier_item_dragon_sword = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_dragon_sword:IsHidden()
	return true
end

function modifier_item_dragon_sword:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

-- Initializations
function modifier_item_dragon_sword:OnCreated( kv )
	-- references
	self.crit_chance_sword = self:GetAbility():GetSpecialValueFor( "crit_chance_sword" )
	self.crit_cg_sword = self:GetAbility():GetSpecialValueFor( "crit_cg_sword" )
	self.bonus_dmg_sword = self:GetAbility():GetSpecialValueFor( "bonus_dmg_sword" )
end

function modifier_item_dragon_sword:OnRefresh( kv )
	self:OnCreated()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_dragon_sword:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

	}

	return funcs
end
function modifier_item_dragon_sword:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end

		-- Throw dice
		if RandomInt(0, 100)<self.crit_chance_sword then
			self.record = params.record
			return self.crit_cg_sword
		end
	end
end
function modifier_item_dragon_sword:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
		end
	end
end

function modifier_item_dragon_sword:GetModifierPreAttack_BonusDamage()
	return self.bonus_dmg_sword
end

modifier_item_dragon_sword_disarmor = modifier_item_dragon_sword_disarmor or class({})

function modifier_item_dragon_sword_disarmor:IsHidden() return true end
function modifier_item_dragon_sword_disarmor:IsDebuff() return false end
function modifier_item_dragon_sword_disarmor:IsPurgable() return false end
function modifier_item_dragon_sword_disarmor:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_dragon_sword_disarmor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_item_dragon_sword_disarmor:OnCreated()
	if IsClient() then return end
	self.player = self:GetParent():GetPlayerOwner()

end

function modifier_item_dragon_sword_disarmor:GetModifierProcAttack_Feedback(keys)
	if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end

	keys.target:EmitSound("Item_Desolator.Target")
	
	local modifier_sword = keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_dragon_sword_disarmor_tear", {})
	if modifier_sword and not modifier_sword:IsNull() then modifier_sword:IncrementStackCount() end
end

modifier_item_dragon_sword_disarmor_tear = class({})

function modifier_item_dragon_sword_disarmor_tear:IsHidden() return false end
function modifier_item_dragon_sword_disarmor_tear:IsDebuff() return true end
function modifier_item_dragon_sword_disarmor_tear:IsPurgable() return false end
function modifier_item_dragon_sword_disarmor_tear:GetTexture() return "innates/innate_rend" end

function modifier_item_dragon_sword_disarmor_tear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_dragon_sword_disarmor_tear:OnCreated()
	self.disarmor = (-1) * self:GetAbility():GetSpecialValueFor("disarmor")

	if IsClient() then return end
end

function modifier_item_dragon_sword_disarmor_tear:GetModifierPhysicalArmorBonus()
	return self.disarmor * self:GetStackCount()
end
