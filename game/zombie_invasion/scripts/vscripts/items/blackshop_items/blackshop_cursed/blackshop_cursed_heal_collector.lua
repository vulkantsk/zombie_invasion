LinkLuaModifier( "modifier_blackshop_cursed_heal_collector", "items/blackshop_items/blackshop_cursed/blackshop_cursed_heal_collector", LUA_MODIFIER_MOTION_NONE )
item_blackshop_cursed_heal_collector = class({})
function item_blackshop_cursed_heal_collector:OnSpellStart()
    self.caster = self:GetCaster()
    local hItem = self
    local m = self.caster:FindModifierByName("modifier_blackshop_cursed_heal_collector")
    if m then
        m:SetStackCount(m:GetStackCount() + self:GetCurrentCharges())
    else
        self.caster:AddNewModifier(self.caster, nil, "modifier_blackshop_cursed_heal_collector", {}):SetStackCount(self:GetCurrentCharges())
    end

    self.caster:EmitSound("Item.TomeOfKnowledge")
    if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
        UTIL_Remove(hItem)
        return
    end
         hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end


modifier_blackshop_cursed_heal_collector = class({})

function modifier_blackshop_cursed_heal_collector:IsHidden()
    return false
end

function modifier_blackshop_cursed_heal_collector:IsDebuff() 
    return false
end

function modifier_blackshop_cursed_heal_collector:IsPurgable()
    return false
end

function modifier_blackshop_cursed_heal_collector:OnCreated()
    self.radius = 900
    self.heal_to_mana = 0.15 
    self.mana_to_heal = 0.20
end

function modifier_blackshop_cursed_heal_collector:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_HEAL,
        MODIFIER_EVENT_ON_MANA_GAINED,
        MODIFIER_EVENT_ON_HEAL_RECEIVED
    }
end

function modifier_blackshop_cursed_heal_collector:OnHealReceived(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    if not keys.gain then return end
  
    local heal_amount = keys.gain
    local parent = self:GetParent()
    
    -- Проверяем что получено положительное количество хила
    if heal_amount <= 0 then return end
    
    local nearby_allies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _, ally in pairs(nearby_allies) do
        if ally ~= parent then
            -- Проверяем нет ли у союзника такого же предмета
            if not ally:HasModifier("modifier_blackshop_cursed_heal_collector") then
                local heal_amount_to_give = heal_amount * self.heal_to_mana + 0.05 * self:GetStackCount()
                ally:Heal(heal_amount_to_give, self)
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount_to_give, ally:GetPlayerOwner())
            end
        end
    end
end

function modifier_blackshop_cursed_heal_collector:OnManaGained(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    if not keys.gain then return end
    
    local mana_gained = keys.gain
    local parent = self:GetParent()
    
    -- Проверяем что получено положительное количество маны
    if mana_gained <= 0 then return end
    
    local nearby_allies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, ally in pairs(nearby_allies) do
        if ally ~= parent then
            -- Проверяем нет ли у союзника такого же предмета
            if not ally:HasModifier("modifier_blackshop_cursed_heal_collector") then
                local mana_to_give = mana_gained * self.mana_to_heal + 0.05 * self:GetStackCount()
                ally:GiveMana(mana_to_give)
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana_to_give, ally:GetPlayerOwner())
            end
        end
    end
end