LinkLuaModifier( "modifier_bloodrage_buff", "heroes/hero_blood_hunter/bloodrage/bloodrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodrage_count", "heroes/hero_blood_hunter/bloodrage/bloodrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodstained_memory", "heroes/hero_blood_hunter/bloodstained_memory/bloodstained_memory", LUA_MODIFIER_MOTION_NONE )

bloodstained_memory = class({})

function bloodstained_memory:GetIntrinsicModifierName()
    return "modifier_bloodstained_memory"
end

 modifier_bloodstained_memory = class({
        IsHidden                = function(self) return false end,
        IsPurgable              = function(self) return false end,
        IsDebuff                = function(self) return false end,
        RemoveOnDeath           = function(self) return true end,
        DeclareFunctions        = function(self) return 
            {
            MODIFIER_PROPERTY_HEALTH_BONUS,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
            } end,
    })



function modifier_bloodstained_memory:OnCreated()
    self.healthbonus = self:GetAbility():GetSpecialValueFor("healthbonus")
    self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
    self:StartIntervalThink(0.1)
end

function modifier_bloodstained_memory:OnIntervalThink()
    self:OnCreated()
end

function modifier_bloodstained_memory:OnRefresh()
    self:OnCreated()

end

function modifier_bloodstained_memory:GetModifierIgnoreMovespeedLimit()  
    return 1
end

    function modifier_bloodstained_memory:GetModifierHealthBonus()
        return self.healthbonus * self:GetParent():FindModifierByName("modifier_bloodrage_buff"):GetStackCount()
    end

    function modifier_bloodstained_memory:GetModifierMoveSpeedBonus_Constant()
        return self.movespeed * self:GetParent():FindModifierByName("modifier_bloodrage_buff"):GetStackCount()
    end


