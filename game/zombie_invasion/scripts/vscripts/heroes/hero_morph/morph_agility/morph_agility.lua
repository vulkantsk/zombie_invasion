LinkLuaModifier("modifier_morph_agility", "heroes/hero_morph/morph_agility/morph_agility", LUA_MODIFIER_MOTION_NONE )
morph_agility = class({})
function morph_agility:OnSpellStart()

	self:GetCaster():Heal(self:GetCaster():GetMaxHealth(), self)
    self:GetCaster():Interrupt()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_morph_agility", {})

end

modifier_morph_agility = class({})
function modifier_morph_agility:IsPurgable() return false end
function modifier_morph_agility:IsPurgeException() return false end

function modifier_morph_agility:OnCreated()


    for i = 0, 5 do
        local ability = self:GetCaster():GetAbilityByIndex(i)
        if ability then
            self:GetCaster():RemoveAbility(ability:GetAbilityName())
        end
    end

    self:GetCaster():RemoveModifierByName("modifier_morph_agility")
    self.agility_form_1 = self:GetCaster():AddAbility("ability_midnight_pulse")
    self.agility_form_1:SetLevel(1)
    self.agility_form_1:SetHidden(false)

    self.morph_adaptive = self:GetCaster():AddAbility("morph_evolution_base")
    self.morph_adaptive:SetLevel(1)
    self.morph_adaptive:SetHidden(false)

    self.morph_last_evolution = self:GetCaster():AddAbility("morph_last_evolution")
    self.morph_last_evolution:SetLevel(1)
    self.morph_last_evolution:SetHidden(true)

    self.morph_last_evolution:SetActivated(true)
    self.morph_adaptive:SetActivated(true)
    self.agility_form_1:SetActivated(true)
    for i = 0, 5 do
        local ability = self:GetCaster():GetAbilityByIndex(i)
        if ability then
            ability:StartCooldown(0.5)
        end
    end
end