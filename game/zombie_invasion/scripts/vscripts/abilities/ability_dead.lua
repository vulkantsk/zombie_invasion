LinkLuaModifier( "modifier_dead", "abilities/ability_dead", LUA_MODIFIER_MOTION_NONE )
kys_spell = class({})

function kys_spell:GetCastAnimation()  
    return ACT_DOTA_CAST_ABILITY_4  
end

function kys_spell:OnSpellStart()
    local hero = self:GetCaster()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dead", {duration = 5 } )
    EmitGlobalSound("deadman.soundtrack")
    EmitSoundOn("sound.heartbreak", self:GetCaster())
    Timers:CreateTimer( 5, function()
        self:GetCaster():ForceKill(false)
        self:PlayEffects()
    end)

end

modifier_dead = class({
        IsHidden                 = function(self) return false end,
        IsPurgable                 = function(self) return false end,
        IsDebuff                 = function(self) return true end,
        GetEffectName           = function(self) return "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_radial_burst_blood.vpcf" end,
        IsBuff                  = function(self) return true end,
        RemoveOnDeath             = function(self) return true end,
        DeclareFunctions        = function(self) end,
        CheckState      = function(self) return 
            {
                [MODIFIER_STATE_STUNNED] = true,
                [MODIFIER_STATE_MUTED] = true,  
                [MODIFIER_STATE_SILENCED] = true,          
            } end,
    })


function modifier_dead:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_radial_burst_blood.vpcf"
 

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )


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