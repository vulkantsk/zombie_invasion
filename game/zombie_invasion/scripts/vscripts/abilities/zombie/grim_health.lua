 
grim_health = class({})









function grim_health:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local ability = self
    local heal = self:GetSpecialValueFor("heal")
 
 
 
     target:Heal(heal, caster)

    SendOverheadEventMessage( target, OVERHEAD_ALERT_HEAL, target, heal, nil )

    local fx = ParticleManager:CreateParticle("particles/econ/items/undying/fall20_undying_head/fall20_undying_soul_rip_heal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)

    ParticleManager:SetParticleControl( fx, 0, target:GetAbsOrigin() )
    ParticleManager:SetParticleControl( fx, 1, Vector( 150, 150, 150 ) )
    ParticleManager:ReleaseParticleIndex(fx)
 
 
 
 
end
 

 