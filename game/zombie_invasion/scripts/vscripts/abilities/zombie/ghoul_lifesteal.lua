LinkLuaModifier("modifier_ghoul_lifesteal", "abilities/zombie/ghoul_lifesteal", LUA_MODIFIER_MOTION_NONE)

 
ghoul_lifesteal = class({})

function ghoul_lifesteal:GetIntrinsicModifierName()
   return "modifier_ghoul_lifesteal" 
end


if modifier_ghoul_lifesteal == nil then
    modifier_ghoul_lifesteal = class({})
end

function modifier_ghoul_lifesteal:IsHidden()
	return true
end

function modifier_ghoul_lifesteal:GetTexture()
    return "life_stealer_feast"
end

function modifier_ghoul_lifesteal:RemoveOnDeath()
	return true
end

function modifier_ghoul_lifesteal:IsPurgable()
	return false
end

function modifier_ghoul_lifesteal:IsPurgeException()
	return false
end

function modifier_ghoul_lifesteal:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_ghoul_lifesteal:OnAttackLanded(data)
	if IsServer() then
		if data.attacker == self:GetParent() then
			data.attacker:Heal(data.damage*(self:GetAbility():GetSpecialValueFor("lifesteal_pct")/100),data.attacker)
		end
	end
end