 

 
    ability_phantom_assassin_togle_knife = class({})
    ability_phantom_assassin_togle_crit = class({})

--------------------------------------------------------------------------------

function ability_phantom_assassin_togle_knife:OnSpellStart()
    local caster = self:GetCaster()
    local ability = caster:FindAbilityByName("ability_phantom_assassin_togle_knife")

    if ability then 
        caster:RemoveAbility("ability_phantom_assassin_togle_knife")
        caster:AddAbility("ability_phantom_assassin_togle_crit")
        local ability_2 = caster:FindAbilityByName("ability_phantom_assassin_togle_crit")
        ability_2:SetLevel(1)
        ability_2:StartCooldown( ability_2:GetCooldown( ability_2:GetLevel() ) )
    end

end

function ability_phantom_assassin_togle_crit:OnSpellStart()
    local caster = self:GetCaster()
    local ability = caster:FindAbilityByName("ability_phantom_assassin_togle_crit")


    if ability then 
        caster:RemoveAbility("ability_phantom_assassin_togle_crit")
        caster:AddAbility("ability_phantom_assassin_togle_knife")
        local ability_2 = caster:FindAbilityByName("ability_phantom_assassin_togle_knife")
        ability_2:SetLevel(1)
        ability_2:StartCooldown(ability_2:GetCooldown(ability_2:GetLevel()))
    end

end
 