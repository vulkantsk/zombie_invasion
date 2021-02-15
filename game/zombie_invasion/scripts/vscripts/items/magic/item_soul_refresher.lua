LinkLuaModifier("modifier_item_refresher_core", "items/magic/item_soul_refresher", LUA_MODIFIER_MOTION_NONE)


item_octarine_core_2 = class({})
			
 
function item_octarine_core_2:GetIntrinsicModifierName()
	return "modifier_item_refresher_core"
end

modifier_item_refresher_core = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function modifier_item_refresher_core:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}
end
  
 

function modifier_item_refresher_core:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor('bonus_health')
end

function modifier_item_refresher_core:GetModifierExtraManaBonus()
	return self:GetAbility():GetSpecialValueFor('bonus_mana')
end

function modifier_item_refresher_core:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor('bonus_health_regen')
end

function modifier_item_refresher_core:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor('bonus_mana_regen')
end

function modifier_item_refresher_core:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor('bonus_cooldown_pct')
end

function modifier_item_refresher_core:GetModifierCastRangeBonusStacking()
	return self:GetAbility():GetSpecialValueFor('bonus_cast')
end



ItemsExeptions = 
{
 
	item_octarine_core_2 = 1,

}

function item_octarine_core_2:OnSpellStart(keys)
	if not self:GetCaster():IsTempestDouble() then
		print("okok")
		for i = 0, 23 do
		    if self:GetCaster():GetAbilityByIndex(i) then
		        self:GetCaster():GetAbilityByIndex(i):EndCooldown()
		    end
		end
		for i = 0, 5 do
		    if self:GetCaster():GetItemInSlot(i) and self:GetCaster():GetItemInSlot(i):IsRefreshable() then 
		        self:GetCaster():GetItemInSlot(i):EndCooldown()
		    end
		end
		self:GetCaster():EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster()), 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		self:StartCooldown(math.random(self:GetSpecialValueFor("cooldown_min"), self:GetSpecialValueFor("cooldown_max")))
	end
end

