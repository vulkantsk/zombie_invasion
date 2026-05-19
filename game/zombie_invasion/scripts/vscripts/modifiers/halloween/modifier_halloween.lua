 
modifier_halloween_gold = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_GOLD_RATE_BOOST,
			 
 
		} end,
})

function modifier_halloween_gold:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_halloween_gold:OnCreated()
 
end

 function modifier_halloween_gold:GetTexture()
	return "alchemist_goblins_greed"
 end
  
--[[ 
function modifier_halloween_gold:OnTakeDamage(data)
    local parent = self:GetParent()
	local attacker = data.attacker
	local unit = data.unit
	local flDamage = data.damage
	  local stack = self:GetParent():FindModifierByName("modifier_halloween_gold"):GetStackCount()

    if parent == attacker and unit:GetHealth() <= 0  then 
	    local ability = self:GetAbility()
 
		local bonus_xp = 0.05
		local bonus_gold = 0.05
 
			local gold = unit:GetGoldBounty()*((stack * 0.05) +1)
 
			unit:SetMaximumGoldBounty(gold)
			unit:SetMinimumGoldBounty(gold)
 

--			parent:ModifyGold(gold, false, 0)
--			parent:AddExperience(xp, 0, true, true)

 
	 
--		local player = PlayerResource:GetPlayer(caster:GetPlayerID())
--		SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, caster, gold, nil )
--		caster:ModifyGold(gold, false, 0)
   ed
endn
]]
function modifier_halloween_gold:GetModifierPercentageGoldRateBoost()
	return self:GetStackCount() * 5
end

modifier_halloween_experience = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_EXP_RATE_BOOST,
 
		} end,
})

function modifier_halloween_experience:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_halloween_experience:OnCreated()
 
end

 function modifier_halloween_experience:GetTexture()
	return "custom_games_xp_coin"
 end
  

function modifier_halloween_experience:GetModifierPercentageExpRateBoost()
	return self:GetStackCount() * 5
end

 modifier_halloween_magic_resist = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
 
		} end,
})

function modifier_halloween_magic_resist:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_halloween_magic_resist:OnCreated()
 
end
 function modifier_halloween_magic_resist:GetTexture()
	return "antimage_counterspell"
 end

 
function modifier_halloween_magic_resist:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() * 3
end


 

 modifier_halloween_health = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE ,
 
		} end,
})

function modifier_halloween_health:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_halloween_health:OnCreated()
	 self:StartIntervalThink( 0.5 )
     
end

 function modifier_halloween_health:GetTexture()
	return "granite_golem_hp_aura"
 end
  
 
function modifier_halloween_health:OnIntervalThink()

      self:GetParent():CalculateStatBonus(true)
 
end
 
function modifier_halloween_health:GetModifierExtraHealthPercentage()
	return 5 * self:GetStackCount()
end


 
 modifier_halloween_damage = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
 
		} end,
})

function modifier_halloween_damage:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

 function modifier_halloween_damage:GetTexture()
	return "item_broadsword"
 end

function modifier_halloween_damage:OnCreated()
 
end

function modifier_halloween_damage:GetModifierPreAttack_BonusDamage()
	return 30 * self:GetStackCount()
end

 modifier_halloween_spell = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
 
		} end,
})

function modifier_halloween_spell:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_halloween_spell:OnCreated()
 
end

 function modifier_halloween_spell:GetTexture()
	return "item_kaya"
 end

function modifier_halloween_spell:GetModifierSpellAmplify_Percentage()
	return 10 * self:GetStackCount()
end


 


 

