if item_medallion_of_courage_custom == nil then item_medallion_of_courage_custom = class({}) end
if item_medallion_of_courage_custom_2 == nil then item_medallion_of_courage_custom_2 = class({}) end
if item_medallion_of_courage_custom_3 == nil then item_medallion_of_courage_custom_3 = class({}) end

LinkLuaModifier("modifier_medallion_active", "items/support/item_medallion_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medallion_passive", "items/support/item_medallion_of_courage", LUA_MODIFIER_MOTION_NONE)
 


function item_medallion_of_courage_custom:OnSpellStart()
	-- Parameters
 	local caster = self:GetCaster()
  	local target = self:GetCursorTarget()
	target:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
	target:AddNewModifier(target, self, "modifier_medallion_active", {duration =   self:GetSpecialValueFor("duration")})
 
 
end

 

function item_medallion_of_courage_custom:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if self:GetCaster() == target then
			return UF_FAIL_CUSTOM
		end
 		if not target:IsSameTeam(self:GetCaster()) then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
end


function item_medallion_of_courage_custom:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
		if self:GetCaster() == target then
			return  "#dota_hud_error_use_myself"
		end
 		if not target:IsSameTeam(self:GetCaster()) then
			return "#dota_hud_error_use_enemies"
		end

		return UF_SUCCESS
	end
end

function item_medallion_of_courage_custom:GetIntrinsicModifierName()
	return "modifier_medallion_passive"
end



function item_medallion_of_courage_custom_2:OnSpellStart()
	-- Parameters
 	local caster = self:GetCaster()
  	local target = self:GetCursorTarget()
	target:EmitSound("Item.StarEmblem.Friendly")
	target:AddNewModifier(target, self, "modifier_medallion_active", {duration =   self:GetSpecialValueFor("duration")})

 	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_small_d_it_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_head", target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
 
end


function item_medallion_of_courage_custom_2:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if self:GetCaster() == target then
			return UF_FAIL_CUSTOM
		end
 		if not target:IsSameTeam(self:GetCaster()) then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
end


function item_medallion_of_courage_custom_2:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
		if self:GetCaster() == target then
			return  "#dota_hud_error_use_myself"
		end
 		if not target:IsSameTeam(self:GetCaster()) then
			return "#dota_hud_error_use_enemies"
		end

		return UF_SUCCESS
	end
end

function item_medallion_of_courage_custom_2:GetIntrinsicModifierName()
	return "modifier_medallion_passive"
end





function item_medallion_of_courage_custom_3:OnSpellStart()
	-- Parameters
 	local caster = self:GetCaster()
  	local target = self:GetCursorTarget()
	target:EmitSound("Item.StarEmblem.Friendly")
	target:AddNewModifier(target, self, "modifier_medallion_active", {duration =   self:GetSpecialValueFor("duration")})

 	local nFXIndex = ParticleManager:CreateParticle( "particles/items/sup/sven_spell_warcry_small_d_it_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_head", target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
 
end


function item_medallion_of_courage_custom_3:CastFilterResultTarget(target)
	--print("Error")
	if IsServer() then
		if self:GetCaster() == target then
			return UF_FAIL_CUSTOM
		end
 		if not target:IsSameTeam(self:GetCaster()) then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
end


function item_medallion_of_courage_custom_3:GetCustomCastErrorTarget(target)
	--print("Error")
	if IsServer() then
		if self:GetCaster() == target then
			return  "#dota_hud_error_use_myself"
		end
 		if not target:IsSameTeam(self:GetCaster()) then
			return "#dota_hud_error_use_enemies"
		end

		return UF_SUCCESS
	end
end

function item_medallion_of_courage_custom_3:GetIntrinsicModifierName()
	return "modifier_medallion_passive"
end



modifier_medallion_passive = class({})

function modifier_medallion_passive:IsDebuff()			return false end
function modifier_medallion_passive:IsHidden() 			return true end
function modifier_medallion_passive:IsPurgable() 		return false end
function modifier_medallion_passive:RemoveOnDeath() 	return true end

function modifier_medallion_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_medallion_passive:OnCreated()
 self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
 self.bonus_mana_regen_pct = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen_pct" )
  self.bonus_all_stats = self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
    
end 

function modifier_medallion_passive:OnRefresh()
  self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
 self.bonus_mana_regen_pct = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen_pct" )
   self.bonus_all_stats = self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end 

 function modifier_medallion_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

	}
end

 
 

function modifier_medallion_passive:GetModifierBonusStats_Strength()
 
		return self.bonus_all_stats
 
end

function modifier_medallion_passive:GetModifierBonusStats_Agility()
 
		return self.bonus_all_stats
 
end

function modifier_medallion_passive:GetModifierBonusStats_Intellect()
 
		return self.bonus_all_stats
 
end

function modifier_medallion_passive:GetModifierConstantManaRegen()
	return  self.bonus_mana_regen_pct
end

function modifier_medallion_passive:GetModifierPhysicalArmorBonus()
	return  self.bonus_armor
end

 

modifier_medallion_active = class({})

function modifier_medallion_active:IsDebuff()			return false end
function modifier_medallion_active:IsHidden() 			return false end
function modifier_medallion_active:IsPurgable() 		return true end
function modifier_medallion_active:RemoveOnDeath() 	return true end
 
function modifier_medallion_active:OnCreated()
 self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
 self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
  self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )  
  self.bonus_all = self:GetAbility():GetSpecialValueFor( "bonus_all" )
end 

function modifier_medallion_active:OnRefresh()
  self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
 self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
  self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )  
  self.bonus_all = self:GetAbility():GetSpecialValueFor( "bonus_all" )
end 

 function modifier_medallion_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,


	}
end

function modifier_medallion_active:GetModifierBonusStats_Strength()
	return  self.bonus_all
end

function modifier_medallion_active:GetModifierBonusStats_Agility()
	return  self.bonus_all
end

function modifier_medallion_active:GetModifierBonusStats_Intellect()
	return  self.bonus_all
end

function modifier_medallion_active:GetModifierAttackSpeedBonus_Constant()
	return  self.bonus_attack_speed
end

function modifier_medallion_active:GetModifierPhysicalArmorBonus()
	return  self.bonus_armor
end

function modifier_medallion_active:GetModifierMoveSpeedBonus_Percentage()
	return  self.bonus_move_speed
end

 function modifier_medallion_active:GetEffectName()
 	 if self:GetAbility():GetName() == "item_medallion_of_courage_custom_3"  then
 		     return "particles/items/sup/solar_crest.vpcf"
         else
	         return "particles/items2_fx/medallion_of_courage_friend.vpcf"
	 end
end

function modifier_medallion_active:GetTexture()
 if self:GetAbility():GetName() == "item_medallion_of_courage_custom_3"  then
 	return "item_medallion_of_courage_3"
 elseif self:GetAbility():GetName() == "item_medallion_of_courage_custom_2"  then
    return "item_solar_crest"
 elseif self:GetAbility():GetName() == "item_medallion_of_courage_custom"  then 
    return "item_medallion_of_courage"
 end
end

function modifier_medallion_active:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end