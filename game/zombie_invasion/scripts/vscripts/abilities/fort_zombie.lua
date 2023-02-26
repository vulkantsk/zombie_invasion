LinkLuaModifier( "modifier_fort_zombie", "abilities/fort_zombie", LUA_MODIFIER_MOTION_NONE )


fort_zombie = class({})
 
 
function fort_zombie:GetIntrinsicModifierName()
    return "modifier_fort_zombie"
end

 
modifier_fort_zombie = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
             MODIFIER_PROPERTY_MODEL_SCALE,
        } end,

})
 

function modifier_fort_zombie:OnCreated()
    self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.model = self:GetAbility():GetSpecialValueFor("bonus_scale")
 
    local effect_cast = ParticleManager:CreateParticle( "particles/dire_fx/bad_ancient_sauron.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetParent(),
        PATTACH_ABSORIGIN_FOLLOW,
        "attach_hitoc",
        self:GetParent():GetOrigin(),
        true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
 
    self:GetCaster():SetRenderColor(26, 17 , 16 )   
    self:StartIntervalThink( 600 )    
end

function modifier_fort_zombie:OnRefresh()
    self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.model = self:GetAbility():GetSpecialValueFor("bonus_scale")
 
    local effect_cast = ParticleManager:CreateParticle( "particles/dire_fx/bad_ancient_sauron.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetParent(),
        PATTACH_ABSORIGIN_FOLLOW,
        "attach_hitoc",
        self:GetParent():GetOrigin(),
        true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
 
    self:GetCaster():SetRenderColor(26, 17 , 16 )   
    self:StartIntervalThink( 600 )    
end

function modifier_fort_zombie:OnIntervalThink()
    local parent = self:GetParent()
       self:IncrementStackCount()    
    parent:SetMaxHealth(parent:GetMaxHealth() + (self.health * self:GetStackCount() ))
    parent:SetHealth(parent:GetMaxHealth())
      
end


function modifier_fort_zombie:GetModifierPhysicalArmorBonus()
    return self.armor * self:GetStackCount()
end
 

function modifier_fort_zombie:GetModifierModelScale()
    return self.model * self:GetStackCount()
end