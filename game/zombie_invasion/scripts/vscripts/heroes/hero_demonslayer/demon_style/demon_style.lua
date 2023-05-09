demon_style = class({})

LinkLuaModifier( "modifier_demon_style", "heroes/hero_demonslayer/demon_style/demon_style", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_style_attack", "heroes/hero_demonslayer/demon_style/demon_style", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_style_count", "heroes/hero_demonslayer/demon_style/demon_style", LUA_MODIFIER_MOTION_NONE )


function demon_style:GetIntrinsicModifierName()
    return "modifier_demon_style"
end
   
    modifier_demon_style = class({
        IsHidden                = function(self) return false end,
        IsPurgable              = function(self) return false end,
        IsDebuff                = function(self) return false end,
        RemoveOnDeath           = function(self) return true end,
        DeclareFunctions        = function(self) return 
            {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
             
            } end,
    })

    function modifier_demon_style:OnCreated( kv )
    self.stack_max = self:GetAbility():GetSpecialValueFor("stack_max")
    self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
    self.stack_attackspeed = self:GetAbility():GetSpecialValueFor("stack_attackspeed")
    end

    function modifier_demon_style:OnRefresh( kv )    
    self.stack_max = self:GetAbility():GetSpecialValueFor("stack_max")
    self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
    self.stack_attackspeed = self:GetAbility():GetSpecialValueFor("stack_attackspeed")
    end

function modifier_demon_style:GetModifierProcAttack_Feedback( params )
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        -- filter enemy
        local target = params.target   

        self:AddStack( 5, 1 )
    end
end

    function modifier_demon_style:GetModifierPreAttack_BonusDamage()
        return self:GetStackCount() * self.stack_damage
    end

    -- Helper
function modifier_demon_style:AddStack( duration, count )
    -- Add counter
    local mod = self:GetParent():AddNewModifier(
        self:GetParent(),
        self:GetAbility(),
        "modifier_demon_style_count",
        {
            duration = duration,
        }
    )
 
    mod.modifier = self
    mod.bonus = count
    -- Add stack
    self:SetStackCount(self:GetStackCount() + count)
 
end

function modifier_demon_style:RemoveStack( value )
    self:SetStackCount( self:GetStackCount() - value )
end

modifier_demon_style_count = class({
    IsHidden                 = function(self) return true end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return false end,
    GetAttributes                = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})
 
function modifier_demon_style_count:OnRemoved()
 
        self.modifier:RemoveStack(self.bonus)
   
end
 