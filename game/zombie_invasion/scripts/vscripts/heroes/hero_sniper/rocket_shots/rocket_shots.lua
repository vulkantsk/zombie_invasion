rocket_shots = class({})
 LinkLuaModifier("modifier_rocket_shots_passive", "heroes/hero_sniper/rocket_shots/rocket_shots", LUA_MODIFIER_MOTION_NONE)


function rocket_shots:GetIntrinsicModifierName()
    return "modifier_rocket_shots_passive"
end

modifier_rocket_shots_passive = class({})
function modifier_rocket_shots_passive:IsDebuff() return false end
function modifier_rocket_shots_passive:IsHidden() return true end
function modifier_rocket_shots_passive:IsPermanent() return true end
function modifier_rocket_shots_passive:IsPurgable() return false end
function modifier_rocket_shots_passive:IsPurgeException() return false end
function modifier_rocket_shots_passive:IsStunDebuff() return false end
function modifier_rocket_shots_passive:RemoveOnDeath() return false end
 
function modifier_rocket_shots_passive:OnCreated()
    self.net_damage = self:GetAbility():GetSpecialValueFor("net_damage")
end

function modifier_rocket_shots_passive:OnRefresh()
    self.net_damage = self:GetAbility():GetSpecialValueFor("net_damage")
end


function modifier_rocket_shots_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		 
 
	}
    return decFuns
end


function modifier_rocket_shots_passive:GetModifierBaseAttackTimeConstant()
    return self.net_damage
end