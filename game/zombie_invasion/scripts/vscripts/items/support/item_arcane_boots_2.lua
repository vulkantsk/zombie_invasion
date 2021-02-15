if item_arcane_boots_2 == nil then item_arcane_boots_2 = class({}) end

LinkLuaModifier("modifier_arcane_boots_2_passive", "items/support/item_arcane_boots_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcane_boots_2_mana_reduction", "items/support/item_arcane_boots_2", LUA_MODIFIER_MOTION_NONE)

function item_arcane_boots_2:OnSpellStart()
 	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("replenish_radius")
	caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")
	local pfx = ParticleManager:CreateParticle("particles/items/sup/arcane_boots_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)  
	ParticleManager:ReleaseParticleIndex(pfx)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		ally:GiveMana(self:GetSpecialValueFor("replenish_amount"))
        ally:AddNewModifier(caster, self, "modifier_arcane_boots_2_mana_reduction",  {duration =    self:GetSpecialValueFor( "replenish_duration" )})
		ParticleManager:CreateParticle("particles/items/sup/arcane_boots_2_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
	end


end

function item_arcane_boots_2:GetIntrinsicModifierName()
     return "modifier_arcane_boots_2_passive"
end


modifier_arcane_boots_2_passive = class({})

function modifier_arcane_boots_2_passive:IsDebuff()			return false end
function modifier_arcane_boots_2_passive:IsHidden() 			return true end
function modifier_arcane_boots_2_passive:IsPurgable() 		return false end
function modifier_arcane_boots_2_passive:RemoveOnDeath() 	return true end

function modifier_arcane_boots_2_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_arcane_boots_2_passive:OnCreated()
    self.bonus_mana = self:GetAbility():GetSpecialValueFor( "bonus_mana" )
    self.bonus_movement = self:GetAbility():GetSpecialValueFor( "bonus_movement" )
end

function modifier_arcane_boots_2_passive:OnRefresh()
    self.bonus_mana = self:GetAbility():GetSpecialValueFor( "bonus_mana" )
    self.bonus_movement = self:GetAbility():GetSpecialValueFor( "bonus_movement" )
end

 function modifier_arcane_boots_2_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
        MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_arcane_boots_2_passive:GetModifierMoveSpeedBonus_Special_Boots()
	return self.bonus_movement
end

function modifier_arcane_boots_2_passive:GetModifierManaBonus()
	return self.bonus_mana
end


modifier_arcane_boots_2_mana_reduction = class({})

function modifier_arcane_boots_2_mana_reduction:IsDebuff()			return false end
function modifier_arcane_boots_2_mana_reduction:IsHidden() 			return false end
function modifier_arcane_boots_2_mana_reduction:IsPurgable() 		return true end
function modifier_arcane_boots_2_mana_reduction:RemoveOnDeath() 	return true end

function modifier_arcane_boots_2_mana_reduction:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_arcane_boots_2_mana_reduction:OnCreated()
    self.replenish_manacost_reduction = self:GetAbility():GetSpecialValueFor( "replenish_manacost_reduction" )

end

function modifier_arcane_boots_2_mana_reduction:OnRefresh()
    self.replenish_manacost_reduction = self:GetAbility():GetSpecialValueFor( "replenish_manacost_reduction" )
end

function modifier_arcane_boots_2_mana_reduction:GetTexture()
     return "item_arcane_boots2_png"
end

 function modifier_arcane_boots_2_mana_reduction:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,

	}
end


function modifier_arcane_boots_2_mana_reduction:GetModifierPercentageManacost()
 
		return  self.replenish_manacost_reduction
 
end