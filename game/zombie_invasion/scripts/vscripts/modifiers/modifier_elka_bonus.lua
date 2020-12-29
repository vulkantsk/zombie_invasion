
if modifier_elka_bonus == nil then
    modifier_elka_bonus = class({})
end

function modifier_elka_bonus:IsHidden()
	return false
end

function modifier_elka_bonus:IsBuff()
	return true
end

function modifier_elka_bonus:IsPurgable() 
	return false 
end

 function modifier_elka_bonus:RemoveOnDeath() 
	return false 
end

function modifier_elka_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_elka_bonus:AllowIllusionDuplicate()
	return true
end

function modifier_elka_bonus:DeclareFunctions()
	local funcs = 
	{
 		MODIFIER_PROPERTY_EXP_RATE_BOOST,
 			MODIFIER_EVENT_ON_TAKEDAMAGE,
   
	}

	return funcs
end

function modifier_elka_bonus:OnTakeDamage(data)
    local parent = self:GetParent()
	local attacker = data.attacker
	local unit = data.unit
	local flDamage = data.damage
	  local stack = self:GetCaster():FindModifierByName("modifier_elka_bonus"):GetStackCount()

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
   end
end

function modifier_elka_bonus:GetModifierPercentageExpRateBoost()
	return self:GetStackCount() * 5
end
 

 function modifier_elka_bonus:GetTexture()
	return "custom_games_xp_coin"
 end
  