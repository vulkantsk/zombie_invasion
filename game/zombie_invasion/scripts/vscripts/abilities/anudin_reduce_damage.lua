LinkLuaModifier("modifier_anudin_reduce_damage", "abilities/anudin_reduce_damage.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_anudin_reduce_damage_debuff", "abilities/anudin_reduce_damage.lua", LUA_MODIFIER_MOTION_NONE )


anudin_reduce_damage = class({})

function anudin_reduce_damage:Precache(context)
	PrecacheAbilityResources({
		"particles/econ/items/lycan/ti9_immortal/lycan_ti9_immortal_overhead.vpcf",
	}, {
	}, context)
end

 
function anudin_reduce_damage:GetIntrinsicModifierName()
   return "modifier_anudin_reduce_damage"
end

modifier_anudin_reduce_damage = class({
   IsHidden             = function(self) return true end,
   IsPurgable             = function(self) return false end,
   IsDebuff             = function(self) return false end,
   IsBuff                  = function(self) return true end,
   RemoveOnDeath          = function(self) return false end,

})


function modifier_anudin_reduce_damage:IsAura()
   return true
end

function modifier_anudin_reduce_damage:GetModifierAura()
   return "modifier_anudin_reduce_damage_debuff"
end

function modifier_anudin_reduce_damage:GetAuraRadius()
   return 3500
end

function modifier_anudin_reduce_damage:GetAuraDuration()
   return 0.1
end

function modifier_anudin_reduce_damage:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_anudin_reduce_damage:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_anudin_reduce_damage:GetAuraSearchFlags()
   return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end


modifier_anudin_reduce_damage_debuff = class({
   IsHidden             = function(self) return false end,
   IsPurgable             = function(self) return false end,
   IsDebuff             = function(self) return false end,
   IsBuff                  = function(self) return true end,
   RemoveOnDeath          = function(self) return false end,
   GetEffectName = function(self) return "particles/econ/items/lycan/ti9_immortal/lycan_ti9_immortal_overhead.vpcf" end,
    DeclareFunctions        = function(self) return 
        {
         MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        } end,
})

function modifier_anudin_reduce_damage_debuff:GetModifierDamageOutgoing_Percentage()
   return -50
end