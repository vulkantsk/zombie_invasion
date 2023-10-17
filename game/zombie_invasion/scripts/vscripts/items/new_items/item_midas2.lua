LinkLuaModifier( "modifier_item_midas_tress", "items/new_items/item_midas2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_midas_buff", "items/new_items/item_midas2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_midas_tress_use", "items/new_items/item_midas2", LUA_MODIFIER_MOTION_NONE )
 
item_midas2 = class({
	GetIntrinsicModifierName = function() return "modifier_item_midas_buff" end
})

function item_midas2:OnAbilityPhaseStart()
		if IsServer() then
	    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1)  
	end
 	return true
end


function item_midas2:OnAbilityPhaseInterrupted()
		if IsServer() then
	    self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
	end
 	return true
end

function item_midas2:OnSpellStart()
	   self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY) 
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin() + RandomVector( RandomFloat( 150, 150))
	local gold_min = self:GetSpecialValueFor("gold_min")
	local gold_max = self:GetSpecialValueFor("gold_max")
		if self:GetCaster():HasModifier("modifier_change_hero") then 
				CreateUnitByName("npc_EdgardBs", point, true, nil, nil, DOTA_TEAM_BADGUYS)
				GameRules:SendCustomMessage("<font color='#c10020'>АХАХАХАХАХАХ ЕБАННЫЙ АБУЗЕР</font>", 0, 0)
				EmitGlobalSound("chto")
				return
		end

	 
				caster:EmitSound("DOTA_Item.Hand_Of_Midas")
local treasure = CreateUnitByName("npc_medas", point, true, nil, nil, DOTA_TEAM_BADGUYS)
            
            treasure:AddNewModifier(treasure,self,"modifier_item_midas_tress", {})
            treasure:SetMinimumGoldBounty(gold_min)
            treasure:SetMaximumGoldBounty(gold_max)
			local effect = "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, treasure)
			ParticleManager:SetParticleControl(particle_fx, 0, treasure:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 1, treasure:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
			
			caster:AddNewModifier(caster,self,"modifier_item_midas_tress_use",{duration = 30})

end

modifier_item_midas_tress = {}


function modifier_item_midas_tress:IsHidden()
	return true
end

function modifier_item_midas_tress:RemoveOnDeath()
	return false
end

function modifier_item_midas_tress:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_item_midas_tress:CheckState()
    local state = {
    [MODIFIER_STATE_NO_HEALTH_BAR]=true,     --MODIFIER_STATE_PROVIDES_VISION
            [MODIFIER_STATE_NO_UNIT_COLLISION]=true,     --MODIFIER_STATE_PROVIDES_VISION

}      
    return state
end

function modifier_item_midas_tress:GetModifierProvidesFOWVision()
	return 1
end


modifier_item_midas_tress_use = {}

function modifier_item_midas_tress_use:IsHidden()
 	return true
 end

function modifier_item_midas_tress_use:RemoveOnDeath()
	return false
end

modifier_item_midas_buff = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    } end
})


function modifier_item_midas_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("attack_speed")
    end
end

function modifier_item_midas_buff:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("attack_damage")
    end
end

function modifier_item_midas_buff:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("armor")
    end
end