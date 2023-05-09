demon_style = class({})

LinkLuaModifier( "modifier_demon_style", "heroes/hero_demonslayer/demon_style/demon_style", LUA_MODIFIER_MOTION_NONE )

    function demon_style:GetIntrinsicModifierName()
        return "modifier_demon_style"
    end
   

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


    function modifier_demon_style:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * self.stack_damage
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
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            } end,
    })

modifier_demon_style = class({})

    function modifier_demon_style:GetModifierProcAttack_Feedback( params )
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        -- filter enemy
        local target = params.target        
        local stack = 100
        local count_stuck = 0

        if RollPseudoRandomPercentage(stack, 1, self:GetCaster()) then 
            count_stuck = count_stuck + 1              
        end 
        
        if count_stuck >= 1 then 
            self:AddStack( duration,count_stuck )
            self:PlayEffects( params.target )  
        end

    end
end

    -- Helper
function modifier_demon_style:AddStack( duration, count )
    -- Add counter
    local mod = self:GetParent():AddNewModifier(
        self:GetParent(),
        self:GetAbility(),
        "modifier_demon_style",
        {
            duration = self.duration,
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