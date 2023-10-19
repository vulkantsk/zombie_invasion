LinkLuaModifier("modifier_dragon_gold_deal_buff", "heroes/hero_smaug/dragon_gold_deal/dragon_gold_deal", LUA_MODIFIER_MOTION_NONE)

dragon_gold_deal = class({
    GetIntrinsicModifierName = function() return "modifier_dragon_gold_deal_buff" end
})
modifier_dragon_gold_deal_buff = class({
    isHidden = function() return true end,
    IsPurgable = function() return false end,
    IsBuff = function() return true end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    } end
})


function modifier_dragon_gold_deal_buff:OnCreated()
    self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
    self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
    self.physical_armor = self:GetAbility():GetSpecialValueFor("physical_armor")

    self:OnIntervalThink()
    self:StartIntervalThink(0.1)
end


function modifier_dragon_gold_deal_buff:OnRefresh()
    self:OnCreated()
end

function modifier_dragon_gold_deal_buff:OnIntervalThink()
    local gold = self:GetAbility():GetSpecialValueFor( "gold" ) 
    local price = 0

    for i = 0, 5 do 
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            local item_price = item:GetCost()
            price = price + item_price
        end        
    end

    local stack = price / gold

    self:SetStackCount( stack )

    self:GetCaster():CalculateStatBonus(true)   
end

function modifier_dragon_gold_deal_buff:GetModifierSpellAmplify_Percentage()
    return self.spell_amp * self:GetStackCount()
end

function modifier_dragon_gold_deal_buff:GetModifierHealthBonus()
    return self.health_bonus * self:GetStackCount()
end

function modifier_dragon_gold_deal_buff:GetModifierPhysicalArmorBonus() 
    return self.physical_armor * self:GetStackCount()
end
