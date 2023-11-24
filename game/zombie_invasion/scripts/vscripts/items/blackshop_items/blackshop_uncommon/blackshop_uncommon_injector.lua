LinkLuaModifier( "modifier_blackshop_uncommon_injector", "items/blackshop_items/blackshop_uncommon/blackshop_uncommon_injector", LUA_MODIFIER_MOTION_NONE )
item_blackshop_uncommon_injector = class({})
function item_blackshop_uncommon_injector:OnSpellStart()
     local caster = self:GetCaster()
     local hItem = self
         caster:EmitSound("DOTA_Item.Cheese.Activate")
         caster:AddNewModifier(caster, self, "modifier_blackshop_uncommon_injector", {})
         if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
            caster:RemoveItem(hItem)
            return
         end
         self:SetStackCount(self:GetStackCount() + 1) 
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end
modifier_blackshop_uncommon_injector = class({})
function modifier_blackshop_uncommon_injector:IsHidden()
    return false
end
function modifier_blackshop_uncommon_injector:IsDebuff()
    return false
end
function modifier_blackshop_uncommon_injector:IsStunDebuff()
    return false
end
function modifier_blackshop_uncommon_injector:IsPurgable()
    return true
end

function modifier_blackshop_uncommon_injector:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_blackshop_uncommon_injector:GetModifierAttackSpeedBonus_Constant()
    return 30
end