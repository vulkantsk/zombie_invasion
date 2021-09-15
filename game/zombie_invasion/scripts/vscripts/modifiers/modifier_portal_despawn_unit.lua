modifier_portal_despawn_unit = {}

function modifier_portal_despawn_unit:IsHidden()
	return true
end

function modifier_portal_despawn_unit:RemoveOnDeath()
    return false
end

function modifier_portal_despawn_unit:DeclareFunctions()
	return 
end

 
function modifier_portal_despawn_unit:OnCreated()
 
 
                      Timers:CreateTimer(9, function()  
              self:PlayEffects()

        end)
     		Timers:CreateTimer(10, function()  
 
 
                 
   self:GetParent():ForceKill(false)
self:GetParent():AddNoDraw()
 
        end)
 
end

 
 
 
function modifier_portal_despawn_unit:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/econ/events/ti10/portal/portal_revealed_nothing_good_1.vpcf"
 

    -- Get Data
    local parent = self:GetParent()

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
    ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( 200, 1, 1 ) )
    ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetDuration(), 0, 0 ) )

    -- buff particle
    self:AddParticle(
        effect_cast,
        false, -- bDestroyImmediately
        false, -- bStatusEffect
        -1, -- iPriority
        false, -- bHeroEffect
        false -- bOverheadEffect
    )
 
end