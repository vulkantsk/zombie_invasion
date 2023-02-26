LinkLuaModifier("modifier_slow_mobs", "abilities/monsters/slow_mobs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slow_mobs_bonus", "abilities/monsters/slow_mobs", LUA_MODIFIER_MOTION_NONE)
 
slow_mobs = class({})

function slow_mobs:GetIntrinsicModifierName()
   return "modifier_slow_mobs" 
end


modifier_slow_mobs = class({
   IsHidden = function(self) return true end,
   DeclareFunctions = function(self) return {
      MODIFIER_EVENT_ON_ATTACK_LANDED,
   }end,
})

function modifier_slow_mobs:OnAttackLanded(data)
   local attacker = data.attacker
   local target = data.target
   local caster = self:GetCaster()
   local ability = self:GetAbility()
   local sounds = {"Slow_mobs_1","Slow_mobs_2","Slow_mobs_3"}
   local chance = ability:GetSpecialValueFor("chance")
 
   if attacker == caster   and not target:IsBuilding() and ability:IsCooldownReady() then
   
      local victim_angle = target:GetAnglesAsVector().y
      local origin_difference = target:GetAbsOrigin() - caster:GetAbsOrigin()

      -- Get the radian of the origin difference between the attacker and Riki. We use this to figure out at what angle the victim is at relative to Riki.
      local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
      
      -- Convert the radian to degrees.
      origin_difference_radian = origin_difference_radian * 180
      local attacker_angle = origin_difference_radian / math.pi
      -- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
      attacker_angle = attacker_angle + 180.0
      
      -- Finally, get the angle at which the victim is facing Riki.
      local result_angle = attacker_angle - victim_angle
      result_angle = math.abs(result_angle)
      
      
      -- Check for the backstab angle.
      if (result_angle >= (180 - (105 / 2)) and result_angle <= (180 + (105 / 2))) and RollPercentage(chance) and not target:IsMagicImmune() then 
  --        EmitGlobalSound("Slow_mobs_1")   
         EmitSoundOn(sounds[RandomInt(1,#sounds)], target)  
         target:AddNewModifier(caster, ability, "modifier_slow_mobs_bonus", {duration = ability:GetSpecialValueFor("duration")})
         ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))    
      end
   end
end
 

modifier_slow_mobs_bonus = class({
   IsHidden = function(self) return false end,
   IsPurgable = function(self) return true end,
   DeclareFunctions = function(self) return {
      MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
   }end,
    GetEffectName   = function(self) return "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf" end,
 
})

function modifier_slow_mobs_bonus:GetModifierMoveSpeedBonus_Percentage()
   return -self:GetAbility():GetSpecialValueFor("slow_duration")
end

 