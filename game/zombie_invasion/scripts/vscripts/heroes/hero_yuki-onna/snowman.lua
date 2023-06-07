  

 yuki_snowman = {}

 function yuki_snowman:OnSpellStart()
 	local target = self:GetCursorPosition()
 	local caster = self:GetCaster()

 	local bonus_health = self:GetSpecialValueFor("bonus_health")
 	local max_snowman = self:GetSpecialValueFor("max_snowman")
    if not caster.snowman then 
        caster.snowman = {}
    else 
    for num, man in ipairs(caster.snowman) do
        if not man:IsAlive() then table.remove(caster.snowman, num)  end
    end        
    end
    if #caster.snowman >= max_snowman then 
        caster.snowman[1]:Destroy()
        table.remove(caster.snowman, 1)
    end
     table.insert(caster.snowman, CreateUnitByName("npc_classic_snowman", target, true, nil, nil, DOTA_TEAM_GOODGUYS))
     local unit = caster.snowman[#caster.snowman]
      unit:FindAbilityByName("yuki_snowball"):SetLevel(self:GetLevel())
      unit:SetOwner( caster )
        FindClearSpaceForUnit( unit, target, true )
      unit:SetBaseMaxHealth(bonus_health)
  end
  