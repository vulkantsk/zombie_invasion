LinkLuaModifier( "modifier_warlock_terror", "abilities/zombie/Boss/warlock_terror", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warlock_terror_stay", "abilities/zombie/Boss/warlock_terror", LUA_MODIFIER_MOTION_NONE )

 
warlock_terror = {}

function warlock_terror:GetIntrinsicModifierName()
    return "modifier_warlock_terror"
end


modifier_warlock_terror = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_MIN_HEALTH} end,
})


function modifier_warlock_terror:OnCreated()
    self.parent = self:GetParent()
end 
function modifier_warlock_terror:GetMinHealth()
   return 1
end 

function modifier_warlock_terror:OnTakeDamage(params)
    if IsClient() then return end
    if params.unit == self:GetParent() then
    
    if self.parent:GetHealth() <= self.parent:GetMaxHealth()*0.25 then 
   --  self.parent:AddNewModifier(self.parent,self,"modifier_invulnerable",{})
  --   self.parent:AddNewModifier(self.parent,self,"modifier_no_attack",{})
       self.parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_warlock_terror_stay",{})
       self.parent:RemoveAbility("warlock_splesh")
       self.parent:SetHealth(self.parent:GetMaxHealth()*0.25)
       GameRules:SendCustomMessage("#warlock_terror", 0, 0)
       self.parent:RemoveModifierByName("modifier_warlock_terror")

    end
    end
 
end 
 

modifier_warlock_terror_stay = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
 
})


function modifier_warlock_terror_stay:OnCreated( kv )
    self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
    self.at_sp = self:GetAbility():GetSpecialValueFor( "at_sp" )

    self.projectile = 900

    if not IsServer() then return end
 
 

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( "Hero_Terrorblade.Metamorphosis", self:GetParent() )
end

function modifier_warlock_terror_stay:OnRefresh( kv )
    self:OnCreated( kv )
end

function modifier_warlock_terror_stay:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    }
end

function modifier_warlock_terror_stay:GetModifierBaseAttackTimeConstant()
    return self.bat
end
 
 function modifier_warlock_terror_stay:GetModifierAttackSpeedBonus_Constant()
    return self.at_sp
end

function modifier_warlock_terror_stay:GetModifierModelChange()
    return "models/items/terrorblade/endless_purgatory_demon/endless_purgatory_demon.vmdl"
end

function modifier_warlock_terror_stay:GetModifierModelScale()
    return 40
end

function modifier_warlock_terror_stay:GetModifierProjectileName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end

function modifier_warlock_terror_stay:GetAttackSound()
    return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_warlock_terror_stay:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_warlock_terror_stay:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 --[[ 

modifier_disable_sf = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    CheckState      = function(self) return 
        {          
            [MODIFIER_STATE_INVULNERABLE] = true, 
            [MODIFIER_STATE_ROOTED] = true, 
            [MODIFIER_STATE_SILENCED] = true, 
            [MODIFIER_STATE_STUNNED] = true, 
            [MODIFIER_STATE_MUTED] = true, 
        } end,
})

function  modifier_disable_sf:OnCreated()
   self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_DISABLED, 1)     
end  


 
function  modifier_disable_sf:OnDestroy()
 self:GetParent():RemoveGesture(ACT_DOTA_DISABLED)   
end  
 


 

modifier_no_attack = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    CheckState      = function(self) return 
        {          
            [MODIFIER_STATE_DISARMED] = true, 
 
        } end,
})

 


 

modifier_disable_sf_ping = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    CheckState      = function(self) return 
        {          
            [MODIFIER_STATE_INVULNERABLE] = true, 
            [MODIFIER_STATE_ROOTED] = true, 
            [MODIFIER_STATE_SILENCED] = true, 
            [MODIFIER_STATE_STUNNED] = true, 
            [MODIFIER_STATE_MUTED] = true, 
        } end,
})

 

 function  modifier_disable_sf_ping:OnCreated()
   self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_DISABLED, 0.00001)     
end  
]]