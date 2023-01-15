  LinkLuaModifier( "modifier_ability_phantom_assassin_stifling_dagger_debuff", "heroes/hero_phantoma_assasin/stifling_dagger/stifling_dagger" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_phantom_assassin_stifling_dagger_target_debuff", "heroes/hero_phantoma_assasin/stifling_dagger/stifling_dagger" ,LUA_MODIFIER_MOTION_NONE )


 
    ability_phantom_assassin_fan_of_knives = class({})
 

--------------------------------------------------------------------------------

function ability_phantom_assassin_fan_of_knives:OnSpellStart()
    local caster = self:GetCaster()
 local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_assassin_stifling_dagger_triple")
    local min_int = self:GetSpecialValueFor("min_int")
    local max_int = self:GetSpecialValueFor("max_int")
    local times =  self:GetSpecialValueFor("times")
        local caster = self:GetCaster()
        local spell = caster:FindAbilityByName("ability_phantom_assassin_stifling_dagger")
        local count_knife = 0
    Timers:CreateTimer(0.01, function()

         while count_knife < times do
         if not caster:IsAlive() then return end
            count_knife = count_knife + 1

            local units = FindUnitsInRadius(
            caster:GetTeam(),
            caster:GetAbsOrigin(),
            nil,
            self:GetCastRange(caster:GetAbsOrigin(),caster),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+ DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
            FIND_CLOSEST,
            false
        )          
        
      local random_unit = units[ RandomInt( 1, #units ) ] 
      local random_time = RandomFloat(min_int, max_int)

          for k,unit in pairs(units) do 
            if unit == random_unit then 
                table.remove(units,k)
            else 

            end 
          end

      local dag_units = {
        Target = random_unit,
        Source = caster,
        Ability = spell,
        EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
        bDodgeable = true,
        bProvidesVision = true,
        iMoveSpeed = spell:GetSpecialValueFor("dagger_speed"),
        iVisionRadius = 450,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }
    
    if random_unit then 
        ProjectileManager:CreateTrackingProjectile( dag_units )
    end


    if talent:GetLevel() == 1  then
           for i=1, 2 do 

            local random_unit_st = units[ RandomInt( 1, #units ) ] 

           for k,unit in pairs(units) do 
             if unit == random_unit_st then 
                 table.remove(units,k)
             else 
 
             end 
           end
 
           local dager_units = {
             Target = random_unit_st,
             Source = caster,
             Ability = spell,
             EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
             bDodgeable = true,
             bProvidesVision = true,
             iMoveSpeed = spell:GetSpecialValueFor("dagger_speed"),
             iVisionRadius = 450,
             iVisionTeamNumber = caster:GetTeamNumber(),
             iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
         }
    
         if random_unit_st then 
             ProjectileManager:CreateTrackingProjectile( dager_units )
         end

         end

     end
         return random_time
    end 
    return nil
    end)

end

 