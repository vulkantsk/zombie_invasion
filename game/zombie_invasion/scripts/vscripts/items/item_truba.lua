LinkLuaModifier("modifier_item_truba_effect","items/item_truba.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_truba_passive","items/item_truba.lua", LUA_MODIFIER_MOTION_NONE)
 if item_truba == nil then
	item_truba = class({})
 
end
 
 
 
 function item_truba:GetIntrinsicModifierName()
	return "modifier_item_truba_passive"
end
 
 

function item_truba:OnSpellStart()
	-- Effects
 
 
	    EmitSoundOn( "lufi", self:GetCaster() )
 
 
 
  	if IsServer() then
		local buff_duration = self:GetSpecialValueFor("buff_duration")
		local radius = self:GetSpecialValueFor("buff_radius")
		local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
		print("P:",units)
		for _, ally in pairs(units) do
			ally:AddNewModifier(self:GetCaster(), self, "modifier_item_truba_effect", {duration = buff_duration})
			 
				self.particle_fx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", PATTACH_ABSORIGIN, ally)
	ParticleManager:SetParticleControl(self.particle_fx, 0, ally:GetAbsOrigin())
		end
	end
 
    

end
  
 


modifier_item_truba_effect = modifier_item_truba_effect or class({})

-- Modifier properties

function modifier_item_truba_effect:IsHidden()		return false end
function modifier_item_truba_effect:IsPurgable()		return false end
function modifier_item_truba_effect:RemoveOnDeath()	return true end
--function modifier_item_truba_effect:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

 
function modifier_item_truba_effect:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
 
 
 
 
  
end

 function modifier_item_truba_effect:GetTexture()
	return "item_truba"
end

-- Various stat bonuses
function modifier_item_truba_effect:DeclareFunctions()
	return {
 
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_truba_effect:OnCreated()
	self.ability	= self:GetAbility()

 
		self.bonus_speed             =   self.ability:GetSpecialValueFor("bonus_speed")
 
		self.bonus_armor           =   self.ability:GetSpecialValueFor("bonus_armor")

end


-- Stats
function modifier_item_truba_effect:GetModifierPhysicalArmorBonus() return self.bonus_armor end

function modifier_item_truba_effect:GetModifierMoveSpeedBonus_Percentage() return self.bonus_speed end

 
 
  
 
  
  

 modifier_item_truba_passive = modifier_item_truba_passive or class({})

-- Modifier properties

function modifier_item_truba_passive:IsHidden()		return true end
function modifier_item_truba_passive:IsPurgable()		return false end
function modifier_item_truba_passive:RemoveOnDeath()	return true end
--function modifier_item_truba_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

 
function modifier_item_truba_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
 
	end

	-- Ability parameters
 
 
 
 
  
end

-- Various stat bonuses
function modifier_item_truba_passive:DeclareFunctions()
	return {
 
 
 		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_item_truba_passive:OnCreated()
	self.ability	= self:GetAbility()

		self.bonus_stat             =   self.ability:GetSpecialValueFor("bonus_stat")

		self.bonus_regen             =   self.ability:GetSpecialValueFor("bonus_regen") 
		self.bonus_attac_speed             =   self.ability:GetSpecialValueFor("bonus_attac_speed")
 
end


 
 
 
-- Stats
function modifier_item_truba_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_attac_speed end
function modifier_item_truba_passive:GetModifierHealthRegen_Constant() return self.bonus_regen end
function modifier_item_truba_passive:GetModifierPhysicalArmorBonus() return self.bonus_armor end
function modifier_item_truba_passive:GetModifierBonusStats_Intellect() return self.bonus_stat end
function modifier_item_truba_passive:GetModifierBonusStats_Agility() return self.bonus_stat end
function modifier_item_truba_passive:GetModifierBonusStats_Strength() return self.bonus_stat end
