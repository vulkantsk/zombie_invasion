LinkLuaModifier("modifier_item_kefteme_effect","items/donate/item_kefteme.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_kefteme_passive","items/donate/item_kefteme.lua", LUA_MODIFIER_MOTION_NONE)
 if item_kefteme == nil then
	item_kefteme = class({})
 
end
 
 
 
 function item_kefteme:GetIntrinsicModifierName()
	return "modifier_item_kefteme_passive"
end
 
 

function item_kefteme:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster,self,"modifier_item_kefteme_effect", {duration = self:GetSpecialValueFor("duration")})
    EmitSoundOn("kefteme",caster)
end
  
 
modifier_item_kefteme_passive = class({
	IsHidden 		= function(self) return true end,
	IsPurgable 		= function(self) return false end,
	IsDebuff 		= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
            MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        } end,
})
 
 function modifier_item_kefteme_passive:OnCreated()
    self.atribut__bonus = self:GetAbility():GetSpecialValueFor("atribut__bonus")
    self.outdamage__bonus = self:GetAbility():GetSpecialValueFor("outdamage__bonus")
     
end

function modifier_item_kefteme_passive:GetModifierBonusStats_Strength()
    return self.atribut__bonus
end

function modifier_item_kefteme_passive:GetModifierBonusStats_Agility()
    return self.atribut__bonus
end

function modifier_item_kefteme_passive:GetModifierBonusStats_Intellect()
    return self.atribut__bonus
end

function modifier_item_kefteme_passive:GetModifierDamageOutgoing_Percentage()
    return self.outdamage__bonus
end

modifier_item_kefteme_effect = class({
	IsHidden 		= function(self) return false end,
	IsPurgable 		= function(self) return false end,
	IsDebuff 		= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MODEL_CHANGE,
            MODIFIER_PROPERTY_MOVESPEED_LIMIT,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

        } end,
    CheckState      = function(self) return 
        {
 		[MODIFIER_STATE_MUTED] = true,  
  		[MODIFIER_STATE_SILENCED] = true,            
        } end,
})
 
 
function modifier_item_kefteme_effect:OnCreated()
    self.move_bonus = self:GetAbility():GetSpecialValueFor("move_bonus")
    self.move_limit = self:GetAbility():GetSpecialValueFor("move_limit")
    self.attack_speed__bonus = self:GetAbility():GetSpecialValueFor("attack_speed__bonus")
end

function modifier_item_kefteme_effect:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed__bonus
end


function modifier_item_kefteme_effect:GetModifierMoveSpeedBonus_Constant()
    return self.move_bonus
end

function modifier_item_kefteme_effect:GetModifierIgnoreMovespeedLimit()  
    return 1
end
 

function modifier_item_kefteme_effect:GetModifierMoveSpeed_Limit() 
    return self.move_limit
end

 

function modifier_item_kefteme_effect:GetModifierModelChange()  
    return "models/props_gameplay/pig_blue.vmdl"
end
 
