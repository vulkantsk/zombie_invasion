LinkLuaModifier( "modifier_ability_blessed_walking", "heroes/hero_wisp/blessed_walking/blessed_walking" ,LUA_MODIFIER_MOTION_NONE )

if blessed_walking == nil then
    blessed_walking = class({})
end

--------------------------------------------------------------------------------
 
function blessed_walking:GetIntrinsicModifierName()
    return "modifier_ability_blessed_walking"
end
--------------------------------------------------------------------------------


modifier_ability_blessed_walking = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
 
 
 
})


--------------------------------------------------------------------------------

if IsServer() then
function modifier_ability_blessed_walking:OnCreated()
    self:StartIntervalThink(0.2)
 
end

 

function modifier_ability_blessed_walking:OnIntervalThink()
if not self:GetParent():PassivesDisabled() then
    local caster = self:GetCaster()
    local target = self:GetParent()
        
    local newPos = target:GetAbsOrigin()
    if self.oldPos == nil then
        self.oldPos = newPos
    end

   
    local distance = (newPos - self.oldPos):Length2D()
    if distance > 0 and distance < 9999 then
 
                 local  heal = distance / 100 * self:GetAbility():GetSpecialValueFor("movement_damage_pct")
 
               caster:Heal(heal,caster)
  --    SendOverheadEventMessage( caster, OVERHEAD_ALERT_HEAL, caster, heal, nil )

 
      
         end
    
 
    self.oldPos = newPos
 
end
end
end
