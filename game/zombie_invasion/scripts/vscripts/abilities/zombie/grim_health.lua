 
grim_health = class({})









function grim_health:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local ability = self
    local heal = self:GetSpecialValueFor("heal")
    local heal_ally = (heal/3)
 
 
     target:Heal(heal, caster)
 
     local allies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),   -- int, your team number
        target:GetOrigin(), -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        450, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,    -- int, team filter
        DOTA_UNIT_TARGET_BASIC, -- int, type filter
        0,  -- int, flag filter
        0,  -- int, order filter
        false   -- bool, can grow cache
    )

 

 
   

         for _,ally in pairs(allies) do
          
             ally:Heal(heal_ally, caster)
             SendOverheadEventMessage( ally, OVERHEAD_ALERT_HEAL, ally, heal_ally, nil )

             self:PlayEffects2( ally, ally )
         end
 
     SendOverheadEventMessage( target, OVERHEAD_ALERT_HEAL, target, heal, nil )

     local fx = ParticleManager:CreateParticle("particles/econ/items/undying/fall20_undying_head/fall20_undying_soul_rip_heal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)

     ParticleManager:SetParticleControl( fx, 0, target:GetAbsOrigin() )
     ParticleManager:SetParticleControl( fx, 1, Vector( 150, 150, 150 ) )
     ParticleManager:ReleaseParticleIndex(fx)
 
 
 
 end
 

 
function grim_health:PlayEffects2( origin, target )
    local particle_target = "particles/econ/items/undying/fall20_undying_head/fall20_undying_soul_rip_heal_body.vpcf"
    local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_target,
        0,
        origin,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        origin:GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
        effect_target,
        1,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        target:GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_target )
end