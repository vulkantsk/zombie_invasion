LinkLuaModifier("modifier_lord_true_essence", "heroes/hero_lord/lord_true_essence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_true_essence_active", "heroes/hero_lord/lord_true_essence", LUA_MODIFIER_MOTION_NONE)


lord_true_essence = class({})

function lord_true_essence:GetBehavior()
    if self:GetCaster():HasScepter() then 
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    else 
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
end

function lord_true_essence:GetIntrinsicModifierName()
	return "modifier_lord_true_essence"
end

function lord_true_essence:OnSpellStart()
    local caster = self:GetCaster()

    if caster:HasScepter() then 
        caster:AddNewModifier(caster,self,'modifier_lord_true_essence_active',{duration = self:GetSpecialValueFor("duration")})
    end
        EmitSoundOn( "fly", caster )
end

modifier_lord_true_essence = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_PROPERTY_HEALTH_BONUS,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

        } end,
})

function modifier_lord_true_essence:OnCreated()
    self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus") 
    self.armor_bonus = self:GetAbility():GetSpecialValueFor("armor_bonus") 
    self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus") 
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("ms_bonus") 
    self.hp_regen_bonus = self:GetAbility():GetSpecialValueFor("hp_regen_bonus") 
end 
 


function modifier_lord_true_essence:OnRefresh()
    self:OnCreated()
end 
 

 
function modifier_lord_true_essence:GetModifierHealthBonus()
    return self.health_bonus
end 
 
function modifier_lord_true_essence:GetModifierPhysicalArmorBonus()
    return self.armor_bonus
end 
 
function modifier_lord_true_essence:GetModifierPreAttack_BonusDamage()
    return self.damage_bonus
end 
 
function modifier_lord_true_essence:GetModifierMoveSpeedBonus_Constant()
    return self.ms_bonus
end 
 
function modifier_lord_true_essence:GetModifierConstantHealthRegen()
    return self.hp_regen_bonus
end 
  

  modifier_lord_true_essence_active = class({
      IsHidden                 = function(self) return false end,
      IsPurgable                 = function(self) return true end,
      IsDebuff                 = function(self) return false end,
      IsBuff                  = function(self) return true end,
      RemoveOnDeath             = function(self) return true end,
      DeclareFunctions        = function(self) return 
          {
  
          } end,
    GetEffectName = function(self) return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf" end,
  })

function modifier_lord_true_essence_active:OnCreated()
    self:GetParent():SetMoveCapability( DOTA_UNIT_CAP_MOVE_FLY )
end 
 
function modifier_lord_true_essence_active:OnDestroy()
    self:GetParent():SetMoveCapability( DOTA_UNIT_CAP_MOVE_GROUND )
end 

  

  

  