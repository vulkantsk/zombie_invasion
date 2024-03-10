LinkLuaModifier( "modifier_dead", "abilities/ability_dead", LUA_MODIFIER_MOTION_NONE )
kys_spell = class({})

function kys_spell:GetCastAnimation()  
    return ACT_DOTA_CAST_ABILITY_4  
end

function kys_spell:OnSpellStart()
    local hero = self:GetCaster()
    hero:BloodOnFace()
    EmitGlobalSound("massive_blood")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dead", {duration = 12 } )
    EmitGlobalSound("deadman.soundtrack")
    EmitSoundOn("sound.heartbreak", self:GetCaster())
    Timers:CreateTimer( 12, function()
        self:GetCaster():ForceKill(false)
        hero:BloodOnFace()
        EmitGlobalSound("massive_blood")
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
