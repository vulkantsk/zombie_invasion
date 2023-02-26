LinkLuaModifier("modifier_item_brassiere", "items/drop/item_brassiere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_brassiere_aura", "items/drop/item_brassiere.lua", LUA_MODIFIER_MOTION_NONE)

item_brassiere = class({})

function item_brassiere:GetIntrinsicModifierName()
	return "modifier_item_brassiere"
end

-------------------------------------------
modifier_item_brassiere = class({
	IsHidden 				= function(self) return true end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
             MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        } end,
    CheckState      = function(self) return 
        {
		[MODIFIER_STATE_DISARMED] = true,         
        } end,
})
-------------------------------------------


function modifier_item_brassiere:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_rg")
end 

function modifier_item_brassiere:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end 

function modifier_item_brassiere:IsAura()
	return true
end

function modifier_item_brassiere:GetModifierAura()
	return "modifier_item_brassiere_aura"
end

function modifier_item_brassiere:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_item_brassiere:GetAuraDuration()
	return 0.1
end

function modifier_item_brassiere:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_brassiere:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

 

modifier_item_brassiere_aura = class({
	IsHidden 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
             MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
             MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        } end,
 
})

function modifier_item_brassiere_aura:OnCreated()
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_brassiere_aura:OnRefresh()
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_brassiere_aura:GetModifierAttackRangeBonus()
	if not self:GetParent():IsRangedAttacker() then 
	    return self.bonus_attack_range
	end 
	return 0
end 

function modifier_item_brassiere_aura:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end 

function modifier_item_brassiere_aura:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end 