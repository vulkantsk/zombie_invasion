LinkLuaModifier( "modifier_demon_buff", "heroes/hero_demonslayer/demon_buff/demon_buff" ,LUA_MODIFIER_MOTION_NONE )

if demon_buff == nil then
    demon_buff = class({})
end

--------------------------------------------------------------------------------

function demon_buff:OnSpellStart()
    local caster = self:GetCaster()

    local duration = self:GetDuration()

    caster:AddNewModifier(caster, self, "modifier_demon_buff", {duration=duration})
    

    local part = "particles/items_fx/manacles_of_power_effect.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, 0, 0 ))
    ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 0, 0, 0 ))
    ParticleManager:SetParticleControl( self.effect_cast, 3, Vector( 0, 0, 0 ))
    ParticleManager:SetParticleControl( self.effect_cast, 0, Vector( 0, 0, 0 ))
end

--------------------------------------------------------------------------------


modifier_demon_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_HEALTH_BONUS,
        }
    end,
    GetAttackSound          = function(self) return "Hero_Antimage.ManaBreak.Attack" end,
    GetHeroEffectName       = function(self) return "" end,
    HeroEffectPriority      = function(self) return 10 end,
    GetStatusEffectName     = function(self) return "" end,
    StatusEffectPriority    = function(self) return 10 end,
})


--------------------------------------------------------------------------------

function modifier_demon_buff:OnRefresh()
    self:OnCreated()
end 

function modifier_demon_buff:OnCreated()
    self.modifier_demon_buff_health = self:GetAbility():GetSpecialValueFor("modifier_demon_buff_health")
    self.GetModifierMoveSpeedBonus_Percentage = self:GetAbility():GetSpecialValueFor("GetModifierMoveSpeedBonus_Percentage")

    if IsServer() then
        if not self.buff_fx then
            self.buff_fx = ParticleManager:CreateParticle( "", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( self.buff_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( self.buff_fx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
            self:AddParticle( self.buff_fx, false, false, -1, false, true )
        end
    end
end

if IsServer() then
function modifier_demon_buff:OnDestroy()
    ParticleManager:DestroyParticle(self.buff_fx, false)
    ParticleManager:ReleaseParticleIndex(self.buff_fx)
end
end

function modifier_demon_buff:GetModifierHealthBonus() return self.modifier_demon_buff_health end
function modifier_demon_buff:GetModifierMoveSpeedBonus_Percentage() return self.GetModifierMoveSpeedBonus_Percentage end