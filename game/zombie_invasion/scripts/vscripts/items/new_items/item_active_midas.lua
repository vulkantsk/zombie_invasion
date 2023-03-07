LinkLuaModifier( "modifier_item_active_midas", "items/new_items/item_active_midas", LUA_MODIFIER_MOTION_NONE )

item_active_midas = class({})
 
 
function item_active_midas:GetIntrinsicModifierName()
	return "modifier_item_active_midas"
end

function item_active_midas:OnSpellStart()
 
	local caster = self:GetCaster()
    local gold = self:GetSpecialValueFor("gold")
    local experience = self:GetSpecialValueFor("experience")

 	caster:ModifyGold(gold, false, 0)
	SendOverheadEventMessage( caster, OVERHEAD_ALERT_GOLD, caster, gold, nil )
    caster:AddExperience(experience, 0, false, true)


	local effect = "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf"
	local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_fx, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_fx)
	caster:EmitSound("DOTA_Item.Hand_Of_Midas")
end

modifier_item_active_midas = modifier_item_active_midas or class({})

-- Modifier properties

function modifier_item_active_midas:IsHidden()		return true end
function modifier_item_active_midas:IsPurgable()		return false end
function modifier_item_active_midas:RemoveOnDeath()	return false end
function modifier_item_active_midas:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_item_active_midas:DeclareFunctions()
	return { 		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
end

function modifier_item_active_midas:OnCreated()
 	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
 	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

end


function modifier_item_active_midas:OnRefresh()
 	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
 	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

end

function modifier_item_active_midas:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_item_active_midas:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_item_active_midas:GetModifierBonusStats_Strength() return self.bonus_all_stats end

function modifier_item_active_midas:GetModifierAttackSpeedBonus_Constant() return self.bonus_attack_speed end
