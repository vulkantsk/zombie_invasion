LinkLuaModifier("modifier_item_lance1", "items/new_items/item_lance1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lance1_active", "items/new_items/item_lance1", LUA_MODIFIER_MOTION_NONE)

item_lance1 = class({})

function item_lance1:GetIntrinsicModifierName()
	return "modifier_item_lance1"
end

modifier_item_lance1 = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}end,
})

 
function modifier_item_lance1:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("ran")
	else
		return 0
	end
end

function modifier_item_lance1:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("str")
end

function modifier_item_lance1:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("agi")
end

function item_lance1:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("dur")
	caster:AddNewModifier(caster, self, "modifier_item_lance1_active", {duration = buff_duration})

end

modifier_item_lance1_active = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
        }
    end,
})


function modifier_item_lance1_active:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as")
end
