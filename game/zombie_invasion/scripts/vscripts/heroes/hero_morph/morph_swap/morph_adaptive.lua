LinkLuaModifier("modifier_morph_evolution", "heroes/hero_morph/morph_swap/morph_adaptive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_morph_evolution_base", "heroes/hero_morph/morph_swap/morph_adaptive", LUA_MODIFIER_MOTION_NONE )

morph_adaptive = class({})
function morph_adaptive:OnSpellStart()
    self:GetCaster():RemoveModifierByName("modifier_morph_evolution_base")
    self:GetCaster():RemoveModifierByName("modifier_morph_evolution")
    self:GetCaster():RemoveModifierByName("modifier_morph_agility")
    self:GetCaster():RemoveModifierByName("modifier_morph_strength")
    self:GetCaster():RemoveModifierByName("modifier_morph_intelligence")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_morph_evolution", {})
    

end


modifier_morph_evolution = class({})
function modifier_morph_evolution:GetTexture() return "" end
function modifier_morph_evolution:IsPurgable() return false end
function modifier_morph_evolution:IsHidden() return false end
function modifier_morph_evolution:IsPurgeException() return false end


function modifier_morph_evolution:OnCreated()
    if not IsServer() then return end
        for i = 0, 5 do
            local ability = self:GetCaster():GetAbilityByIndex(i)
            if ability then
                self:GetCaster():RemoveAbility(ability:GetAbilityName())
            end
        end
        self.agility_change = self:GetCaster():AddAbility("morph_agility")
        self.agility_change:SetLevel(1)
        self.agility_change:SetHidden(false)
    
   	    self.strength_change = self:GetCaster():AddAbility("morph_strength")
        self.strength_change:SetLevel(1)
        self.strength_change:SetHidden(false) 

        self.intelligence_change = self:GetCaster():AddAbility("morph_intelligence")
        self.intelligence_change:SetLevel(1)
        self.intelligence_change:SetHidden(false) 

        self.morph_last_evolution = self:GetCaster():AddAbility("morph_last_evolution")
        self.morph_last_evolution:SetLevel(1)
        self.morph_last_evolution:SetHidden(true)
    
        self.intelligence_change:SetActivated(true)
        self.strength_change:SetActivated(true)
        self.agility_change:SetActivated(true)
        self.morph_last_evolution:SetActivated(true)
    
    
        for i = 0, 5 do
            local ability = self:GetCaster():GetAbilityByIndex(i)
            if ability then
                ability:StartCooldown(0.5)
            end
        end
end

modifier_morph_evolution_base = class({})
function modifier_morph_evolution_base:GetTexture() return "" end
function modifier_morph_evolution_base:IsPurgable() return false end
function modifier_morph_evolution_base:IsHidden() return false end
function modifier_morph_evolution_base:IsPurgeException() return false end

morph_evolution_base = class({})
function morph_evolution_base:OnSpellStart()
    self:GetCaster():RemoveModifierByName("modifier_morph_evolution_base")
    self:GetCaster():RemoveModifierByName("modifier_morph_evolution")
    self:GetCaster():RemoveModifierByName("modifier_morph_agility")
    self:GetCaster():RemoveModifierByName("modifier_morph_strength")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_morph_evolution_base", {})
    

end


function modifier_morph_evolution_base:OnCreated()
    if not IsServer() then return end
        for i = 0, 5 do
            local ability = self:GetCaster():GetAbilityByIndex(i)
            if ability then
                self:GetCaster():RemoveAbility(ability:GetAbilityName())
            end
        end   

        self.morph_last_evolution = self:GetCaster():AddAbility("morph_last_evolution")
        self.morph_last_evolution:SetLevel(1)
        self.morph_last_evolution:SetHidden(false)



        self.morph_adaptive = self:GetCaster():AddAbility("morph_adaptive")
        self.morph_adaptive:SetLevel(1)
        self.morph_adaptive:SetHidden(false)
    
        --self.agility_strength = self:GetCaster():AddAbility("ability_demonic_conversion")
        --self.agility_strength:SetLevel(1)
        --self.agility_strength:SetHidden(false) 
    
        self:GetCaster():AddAbility("generic_hidden")
        self:GetCaster():AddAbility("generic_hidden")
    
        self.morph_adaptive:SetActivated(true)
        self.morph_last_evolution:SetActivated(true)
    
        for i = 0, 5 do
            local ability = self:GetCaster():GetAbilityByIndex(i)
            if ability then
                ability:StartCooldown(0.5)
            end
        end
end