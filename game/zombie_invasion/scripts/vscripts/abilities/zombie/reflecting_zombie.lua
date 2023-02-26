LinkLuaModifier( "modifier_reflecting_zombie", "abilities/zombie/reflecting_zombie", LUA_MODIFIER_MOTION_NONE )
 

reflecting_zombie = class({})
 
 
function reflecting_zombie:GetIntrinsicModifierName()
    return "modifier_reflecting_zombie"
end


modifier_reflecting_zombie = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_EVENT_ON_DEATH,
        } end,

})
 

function modifier_reflecting_zombie:OnDeath(data)
    if IsServer() then
        local caster = self:GetCaster()
        local killer = data.attacker
        local killed_unit = data.unit
        local damage = self:GetAbility():GetSpecialValueFor("damage")
         if killed_unit == caster then
		     DealDamage(caster, killer,damage, self:GetAbility():GetAbilityDamageType(), self:GetAbility():GetAbilityTargetFlags(), self:GetAbility())
        end
    end
end