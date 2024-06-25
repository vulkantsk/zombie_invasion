LinkLuaModifier("modifier_rom_effect","items/item_rom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rom_passive","items/item_rom.lua", LUA_MODIFIER_MOTION_NONE)
 if item_rom == nil then
	item_rom = class({})
 
end
 
 
 
 function item_rom:GetIntrinsicModifierName()
	return "modifier_rom_passive"
end
 
 

function item_rom:OnSpellStart()
	-- Effects

 
   	local caster = self:GetCaster()
 
  if not caster:HasModifier("modifier_rom_effect") then
  	EmitSoundOn( "drinking", self:GetCaster() )
  	caster:AddNewModifier(caster, self, "modifier_rom_effect", {})
  else 
  	caster:RemoveModifierByName("modifier_rom_effect")
  end

end
  
 


modifier_rom_effect = modifier_rom_effect or class({})

-- Modifier MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT

function modifier_rom_effect:IsHidden()		return true end
function modifier_rom_effect:IsPurgable()		return false end
function modifier_rom_effect:RemoveOnDeath()	return true end
--function modifier_rom_effect:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

 function modifier_rom_effect:GetTexture()
	return "item_drink_pirate"
end

-- Various stat bonuses
function modifier_rom_effect:DeclareFunctions()
	return {
 
      		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_rom_effect:OnCreated()

	self.ability = self:GetAbility()

		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
		self.bonus_speed = self.ability:GetSpecialValueFor("bonus_speed")
		self.bonus_attack_time = self.ability:GetSpecialValueFor("bonus_attack_time")
		self.bonus_anti_damage = self.ability:GetSpecialValueFor("bonus_anti_damage")
		self.bonus_spell_damage = self.ability:GetSpecialValueFor("bonus_spell_damage")
		self:StartIntervalThink(0.25)
   		self:OnIntervalThink()

end

function modifier_rom_effect:OnIntervalThink()
    if not IsServer() then return end
    	if self:GetParent():HasModifier("modifier_rom_passive") then
    		self:GetParent():SetHealth(math.max( self:GetParent():GetHealth() - (100 * 0.25), 1))
		else
			self:GetParent():RemoveModifierByName("modifier_rom_effect")	
		end
end


-- Stats
function modifier_rom_effect:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_rom_effect:GetModifierMoveSpeedBonus_Percentage() return self.bonus_speed end

function modifier_rom_effect:GetModifierBaseAttackTimeConstant() return self.bonus_attack_time end

function modifier_rom_effect:GetModifierIncomingDamage_Percentage() return -self.bonus_anti_damage end

function modifier_rom_effect:GetModifierSpellAmplify_Percentage() return self.bonus_spell_damage end
 
  
function modifier_rom_effect:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf"
end

function modifier_rom_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

  
  

 modifier_rom_passive = modifier_rom_passive or class({})

-- Modifier properties

function modifier_rom_passive:IsHidden()		return true end
function modifier_rom_passive:IsPurgable()		return false end
function modifier_rom_passive:RemoveOnDeath()	return true end
--function modifier_rom_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Various stat bonuses
function modifier_rom_passive:DeclareFunctions()
	return {
 
      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 
	}
end

function modifier_rom_passive:OnCreated()
	self.ability	= self:GetAbility()

		self.strenght             =   self.ability:GetSpecialValueFor("strenght")
 
end


-- Stats
function modifier_rom_passive:GetModifierBonusStats_Strength() return self.strenght end

 
-- Stats
 