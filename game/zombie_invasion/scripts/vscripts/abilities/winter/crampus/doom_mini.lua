-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
doom_mini = class({})
LinkLuaModifier( "modifier_doom_mini", "abilities/winter/crampus/doom_mini", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_doom_mini_death", "abilities/winter/crampus/doom_mini", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
 
function doom_mini:GetIntrinsicModifierName()
    return "modifier_doom_mini"
end

 

modifier_doom_mini = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
 
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,

})
 
local doom = 0 
function modifier_doom_mini:OnTakeDamage( keys )
 if doom == 0 then
    if self:GetCaster():GetHealth() < self:GetCaster():GetMaxHealth() * 0.5  then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        	Timers:CreateTimer(0,function()
 
  		          self:GetCaster():AddNewModifier(self:GetCaster(), nil, 'modifier_doom_mini_death', {}) 
 
	end)  
         	Timers:CreateTimer(2,function()
              for i = 1, 7 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
  	          end

	end)  
                      Timers:CreateTimer(15,function()      
            CreateUnitByName("npc_classic_doom_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
  end)  

 
            Timers:CreateTimer(10,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end)  
 

            Timers:CreateTimer(15,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end) 

            Timers:CreateTimer(20,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end) 

                      Timers:CreateTimer(35,function()      
            CreateUnitByName("npc_classic_doom_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
  end)  
            Timers:CreateTimer(30,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end)  

                      Timers:CreateTimer(45,function()      
                                      for i = 1, 2 do
            CreateUnitByName("npc_classic_doom_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
                          end
  end)  

            Timers:CreateTimer(35,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end)  

              Timers:CreateTimer(45,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end)  

            Timers:CreateTimer(50,function()
              for i = 1, 8 do
            CreateUnitByName("npc_classic_mini_crampus",  self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(50, 300)), true, nil, nil, DOTA_TEAM_BADGUYS)
              end
  end)  

            Timers:CreateTimer(60,function()
          self:GetCaster():RemoveModifierByName('modifier_doom_mini_death') 
  end) 
      doom = doom + 1
 
 
   
    end
 end
end




 modifier_doom_mini_death = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
 
        } end,
    CheckState      = function(self) return 
        {
                  
            [MODIFIER_STATE_INVULNERABLE] = true, 
            [MODIFIER_STATE_ROOTED] = true, 
            [MODIFIER_STATE_DISARMED] = true, 
            [MODIFIER_STATE_STUNNED] = true, 
 
        } end,
})

       function  modifier_doom_mini_death:OnCreated()
        
        self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_TELEPORT, 1)     
 
end  

 

function modifier_doom_mini_death:OnDestroy()
                self:GetCaster():RemoveGesture(ACT_DOTA_TELEPORT) 
 
end

 