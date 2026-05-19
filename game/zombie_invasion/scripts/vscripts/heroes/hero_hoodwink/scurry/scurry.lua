LinkLuaModifier("modifier_hoodwink_scurry_custom", "heroes/hero_hoodwink/scurry/scurry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hoodwink_scurry_custom_buff", "heroes/hero_hoodwink/scurry/scurry", LUA_MODIFIER_MOTION_NONE)

hoodwink_scurry_custom = class({})

function hoodwink_scurry_custom:Precache(context)
	PrecacheAbilityResources({
		"particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf",
	}, {
		"Hero_Hoodwink.Scurry.Cast",
		"hoodwink/hoodwink_scurry_0",
	}, context)
end


function hoodwink_scurry_custom:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local duration = ability:GetSpecialValueFor("duration")
	
	local modifier = caster:AddNewModifier(caster, ability, "modifier_hoodwink_scurry_custom_buff", {duration = duration})
   
   local index = RandomInt(1, 17)
    if index < 10 then
        index = "0"..index
    end
    caster:EmitSound("hoodwink/hoodwink_scurry_0"..index)
    caster:EmitSound("Hero_Hoodwink.Scurry.Cast")
end
 
 
------------------------------------------------------------

modifier_hoodwink_scurry_custom_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    CheckState      = function(self) return 
        {
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        }end,          
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
 		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		} end,
})

function modifier_hoodwink_scurry_custom_buff:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
 

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
       self:GetCaster():RemoveModifierByName("modifier_hoodwink_scurry_custom_buff")
			end
		end
	end
	return 0
end


 


function modifier_hoodwink_scurry_custom_buff:OnCreated()
	self.ms_bonus = self:GetAbility():GetSpecialValueFor("movement_speed_pct")
end

function modifier_hoodwink_scurry_custom_buff:GetModifierIgnoreMovespeedLimit()  
	return 1
end

function modifier_hoodwink_scurry_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf"
end

function modifier_hoodwink_scurry_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

