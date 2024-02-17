LinkLuaModifier( "modifier_blackshop_cursed_remove_limits", "items/blackshop_items/blackshop_cursed/blackshop_cursed_remove_limits", LUA_MODIFIER_MOTION_NONE )
item_blackshop_cursed_remove_limits = class({})
function item_blackshop_cursed_remove_limits:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_cursed_remove_limits")
     if not m then 
          self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_cursed_remove_limits", {})
        end
    

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        self.caster:RemoveItem(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end
modifier_blackshop_cursed_remove_limits = class({})

function modifier_blackshop_cursed_remove_limits:IsHidden()
    return false
end

function modifier_blackshop_cursed_remove_limits:IsDebuff()
    return false
end

function modifier_blackshop_cursed_remove_limits:IsPurgable()
    return false
end

function modifier_blackshop_cursed_remove_limits:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_blackshop_cursed_remove_limits:IsStunDebuff()
    return false
end

function modifier_blackshop_cursed_remove_limits:RemoveOnDeath()
    return false
end

function modifier_blackshop_cursed_remove_limits:DestroyOnExpire()
    return false
end


function modifier_blackshop_cursed_remove_limits:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
    }
end
function modifier_blackshop_cursed_remove_limits:GetModifierMoveSpeed_Limit()
    return 100000
end


function modifier_blackshop_cursed_remove_limits:GetModifierAttackSpeed_Limit()
    return 1
end

function modifier_blackshop_cursed_remove_limits:GetModifierHPRegenAmplify_Percentage()
    return -100
end


