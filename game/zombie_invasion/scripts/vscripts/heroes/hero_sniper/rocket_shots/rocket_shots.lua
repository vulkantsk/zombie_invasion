-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
rocket_shots = class({})
 
LinkLuaModifier("modifier_rocket_shots_passive", "heroes/hero_sniper/rocket_shots/rocket_shots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rocket_shots_haste", "heroes/hero_sniper/rocket_shots/rocket_shots", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
 
 
-------------------------------------------

 

-------------------------------------------
function rocket_shots:GetIntrinsicModifierName()
    return "modifier_rocket_shots_passive"
end

-------------------------------------------
modifier_rocket_shots_passive = class({})
function modifier_rocket_shots_passive:IsDebuff() return false end
function modifier_rocket_shots_passive:IsHidden() return true end
function modifier_rocket_shots_passive:IsPermanent() return true end
function modifier_rocket_shots_passive:IsPurgable() return false end
function modifier_rocket_shots_passive:IsPurgeException() return false end
function modifier_rocket_shots_passive:IsStunDebuff() return false end
function modifier_rocket_shots_passive:RemoveOnDeath() return false end
 
--------------------------------------------------------------------------------
-- Modifier Effects
 

function modifier_rocket_shots_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_EVENT_ON_ATTACK_START,
		 
 
	}
    return decFuns
end

 
 
function modifier_rocket_shots_passive:OnAttackStart(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
 
 
 self.think = self:GetAbility():GetSpecialValueFor( "duration" )
 	if not self:GetCaster():PassivesDisabled() then	
 				if (keys.attacker == parent) and (parent:IsRealHero() or parent:IsClone()) then
			if item:IsCooldownReady() then
                print("z utq")
                	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_rocket_shots_haste", {duration = self.think})
 
				item:UseResources(false,false,true)			
			end
end
 
    end
 
end





-------------------------------------------
modifier_rocket_shots_haste = class({})
function modifier_rocket_shots_haste:IsDebuff() return false end
function modifier_rocket_shots_haste:IsHidden() return false end
function modifier_rocket_shots_haste:IsPurgable() return false end
function modifier_rocket_shots_haste:IsPurgeException() return false end
function modifier_rocket_shots_haste:IsStunDebuff() return false end
function modifier_rocket_shots_haste:RemoveOnDeath() return true end
-------------------------------------------
function modifier_rocket_shots_haste:OnCreated()
 	self.speed_atack = self:GetAbility():GetSpecialValueFor( "bonus_speed_atack" )	
end

function modifier_rocket_shots_haste:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		 
    }
    return decFuns
end

 

function modifier_rocket_shots_haste:GetModifierBaseAttackTimeConstant()
		return self.speed_atack
end
-------------------------------------------
