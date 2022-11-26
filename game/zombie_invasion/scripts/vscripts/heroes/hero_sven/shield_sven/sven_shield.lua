sven_shield = class({})
LinkLuaModifier('modifier_sven_shield', 'heroes/hero_sven/shield_sven/sven_shield', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_sven_shield_passive', 'heroes/hero_sven/shield_sven/sven_shield', LUA_MODIFIER_MOTION_NONE)
 
function sven_shield:GetIntrinsicModifierName()
    return "modifier_sven_shield_passive"
end

modifier_sven_shield_passive = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
 
})


function modifier_sven_shield_passive:OnCreated(data)
    if IsClient() then return end
        self:StartIntervalThink( 0.2 )
end

function modifier_sven_shield_passive:OnIntervalThink()
    if not self:GetParent():PassivesDisabled() then
      
  
 if not self:GetCaster():HasModifier("modifier_sven_shield") then 
     if self:GetAbility():IsCooldownReady() then
 
             self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_shield", {  })

     end
 end 
    end
end 

modifier_sven_shield = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        }
    end,

    GetModifierIncomingDamage_Percentage = function(self,data) 
        self.absorbAmount = self.absorbAmount + data.damage
        if self.absorbAmount > self:GetAbility():GetSpecialValueFor('damage_absorb') then 
            self:Destroy()
        end 
        print(self.absorbAmount)
        return -100 
    end,
})


 
 
 
 

function modifier_sven_shield:OnCreated(data)
    if IsClient() then return end
    self.absorb = data.absorb
    self.absorbAmount = 0
    self.parent = self:GetParent()
    local shield_size = 70
    self.nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_sven/sven_warcry_buff_shield.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(self.nfx, 1, Vector(shield_size,0,shield_size))
    ParticleManager:SetParticleControl(self.nfx, 2, Vector(shield_size,0,shield_size))
    ParticleManager:SetParticleControl(self.nfx, 4, Vector(shield_size,0,shield_size))
    ParticleManager:SetParticleControl(self.nfx, 5, Vector(shield_size,0,0))
    ParticleManager:SetParticleControlEnt(self.nfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

 
 

function modifier_sven_shield:OnDestroy()
    if IsClient() then return end

    local nfx_2 = ParticleManager:CreateParticle('particles/units/heroes/hero_sven/sven_spell_warcry_wave.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControlEnt(nfx_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(nfx_2)

    local units = FindUnitsInRadius(self:GetCaster():GetTeam(), 
    self:GetParent():GetOrigin(), 
    nil, 
    self:GetAbility():GetSpecialValueFor('radius'),
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    self:GetAbility():GetAbilityTargetType(), 
    self:GetAbility():GetAbilityTargetFlags(),
    FIND_ANY_ORDER, 
    false)

 
    ParticleManager:DestroyParticle(self.nfx , true)
    ParticleManager:ReleaseParticleIndex(self.nfx)

    ParticleManager:SetParticleControl(nfx_2, 1, Vector(shield_size,0,shield_size))
    ParticleManager:SetParticleControl(nfx_2, 2, Vector(shield_size,0,shield_size))
    ParticleManager:SetParticleControl(nfx_2, 4, Vector(shield_size,0,shield_size))
    ParticleManager:SetParticleControl(nfx_2, 5, Vector(shield_size,0,0))
    ParticleManager:SetParticleControlEnt(nfx_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
     self:GetAbility():UseResources(false,false,true)  
end