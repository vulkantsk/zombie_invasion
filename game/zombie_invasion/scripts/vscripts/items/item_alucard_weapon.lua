LinkLuaModifier("modifier_item_alucard_weapon", "items/item_alucard_weapon", LUA_MODIFIER_MOTION_NONE)

item_alucard_weapon = class({})

function item_alucard_weapon:GetIntrinsicModifierName()
	return "modifier_item_alucard_weapon"
end

modifier_item_alucard_weapon = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_DEATH,
        } end,
})

 
function modifier_item_alucard_weapon:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage") *  self:GetAbility():GetCurrentCharges()
end


function modifier_item_alucard_weapon:OnDeath(data)
        local parent = self:GetParent()
        local killer = data.attacker
        local killed_unit = data.unit

        local chance = self:GetAbility():GetSpecialValueFor("chance_to_stack")
        local charges = 1 + self:GetAbility():GetCurrentCharges()
        if killer == parent and RollPercentage(chance) then
            self:GetAbility():SetCurrentCharges(charges)
        end
end

 

 