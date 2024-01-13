LinkLuaModifier( "modifier_sf_dead", "abilities/winter/ping/sf_dead", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_sf", "abilities/winter/ping/sf_dead", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_sf_ping", "abilities/winter/ping/sf_dead", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_no_attack", "abilities/winter/ping/sf_dead", LUA_MODIFIER_MOTION_NONE )

sf_dead = {}

function sf_dead:GetIntrinsicModifierName()
    return "modifier_sf_dead"
end

modifier_sf_dead = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_MIN_HEALTH} end,
})


function modifier_sf_dead:OnCreated()
    self.parent = self:GetParent()
end 
function modifier_sf_dead:GetMinHealth()
   return 1
end 

function modifier_sf_dead:OnAttackLanded(data)
    if IsClient() then return end
    if data.target ~= self.parent  then return end
    
    if self.parent:GetHealth() <= self.parent:GetMaxHealth()*0.2 then 
     self.parent:AddNewModifier(self.parent,self,"modifier_invulnerable",{})
     self.parent:AddNewModifier(self.parent,self,"modifier_no_attack",{})
     self:ScenkaGood()
    end
 
end 


function modifier_sf_dead:ScenkaGood()
 Sounds:RemoveGlobalLoopingSound( "christmas_boss_theme" )
local sf_1 = Entities:FindByName(nil, "sf_1"):GetAbsOrigin()--СЮДА
local sf_2 = Entities:FindByName(nil, "sf_2"):GetAbsOrigin()--СЮДА
local sf_3 = Entities:FindByName(nil, "sf_3"):GetAbsOrigin()--СЮДА
local sf_4 = Entities:FindByName(nil, "sf_4"):GetAbsOrigin()--СЮДА

local pingwin_1 = Entities:FindByName(nil, "pingwin_1"):GetAbsOrigin()--СЮДА
local pingwin_2 = Entities:FindByName(nil, "pingwin_2"):GetAbsOrigin()--СЮДА
local pingwin_3 = Entities:FindByName(nil, "pingwin_3"):GetAbsOrigin()--СЮД--СЮДАА
local pingwin_4 = Entities:FindByName(nil, "pingwin_4"):GetAbsOrigin()--СЮДА
local pingwin_5 = Entities:FindByName(nil, "pingwin_5"):GetAbsOrigin()--СЮДА

local penguin_1 = Entities:FindByName(nil, 'penguin_1')   --СЮДА
local penguin_2 = Entities:FindByName(nil, 'penguin_2')    --СЮДА
local penguin_3 = Entities:FindByName(nil, 'penguin_3')  --СЮДА
local penguin_4 = Entities:FindByName(nil, 'penguin_4')   --СЮДА
local ping = Entities:FindByName(nil, 'ping')--СЮДА

local techies_start_point = Entities:FindByName(nil, "techies_start_point"):GetAbsOrigin() --СЮДА

    local jitels = {
    	"crystalka","deny","kunkka","old_men","miner","lina" --СЮДА
    }
 
 


        for index=0 ,HeroList:GetHeroCount() do  
		  		if HeroList:GetHero(index)    then   
			        local hero = HeroList:GetHero(index)   

 			   			 
                    if not hero:IsAlive() then 
                        hero:RespawnHero(false, false) 
                    end 
 		 
                   local ent= Entities:FindByName( nil, "for_brodyagi")--СЮДА

                   local point = ent:GetAbsOrigin()  
                   
     	
                   hero:SetAbsOrigin( point ) 
                   FindClearSpaceForUnit(hero, point, false)  
                   hero:AddNewModifier(self.parent,self:GetAbility(),"modifier_disable_sf",{})
         
                end
        end	

         
 	Timers:CreateTimer(0.1,function()
         GameRules:SendCustomMessage("#sf_eg1", 0, 0) 
 		EmitGlobalSound("Scary")
 		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_THIRST, 1)
 		self.parent:CastPointSkill("intro_rotate_christmas", techies_start_point) 
  
	end) 

 	Timers:CreateTimer(3,function()
        self.parent:SetAbsOrigin(sf_1)
	end) 


 	Timers:CreateTimer(6,function()
        self.parent:CastPointSkill("intro_rotate_christmas", sf_2)
        GameRules:SendCustomMessage("#sf_eg2", 0, 0)  
	end) 


 	Timers:CreateTimer(12,function()
 		MoveToPoint(self.parent, sf_2)
        GameRules:SendCustomMessage("#sf_eg3", 0, 0)  
	end) 

 	Timers:CreateTimer(18,function()
 		  self.parent:RemoveGesture(ACT_DOTA_THIRST) 
 		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_TAUNT, 1)
  		EmitGlobalSound("laught_2")
 		self.parent:Heal(666666,self.parent)
       SendOverheadEventMessage( self.parent, OVERHEAD_ALERT_HEAL, self.parent, 666666, nil )
        GameRules:SendCustomMessage("#sf_eg4", 0, 0)  
	end) 

 	Timers:CreateTimer(24,function()
        self.parent:RemoveGesture(ACT_DOTA_TAUNT) 
        GameRules:SendCustomMessage("#sf_eg5", 0, 0)  
	end) 

 	Timers:CreateTimer(30,function()
        GameRules:SendCustomMessage("#sf_eg6", 0, 0)  
	end) 

 	Timers:CreateTimer(37,function()
        GameRules:SendCustomMessage("#sf_eg7", 0, 0)  
	end) 


 	Timers:CreateTimer(40,function()
 for i,name in ipairs(jitels) do  
    local unit = Entities:FindByName(nil, name)
    if unit then 
         unit:SetAbsOrigin(sf_3)
         FindClearSpaceForUnit(unit, sf_3, false)
         unit:AddNewModifier(self.parent,self:GetAbility(),"modifier_disable_sf",{})
    else
          
    end
 end          
	end) 

 	Timers:CreateTimer(42,function()
        MoveToPoint(self.parent, sf_4)   
	end) 

	Timers:CreateTimer(45,function()
        self.parent:CastSkill("sf_requiem")
	end) 

	Timers:CreateTimer(46.5,function()
    local particle_cast = "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )

		StopGlobalSound("Scary")
         self.parent:AddNewModifier(self.parent,self:GetAbility(),"modifier_disable_sf_ping",{})
         GameRules:SendCustomMessage("#sf_eg8", 0, 0)  
	end) 

	Timers:CreateTimer(49,function()
         GameRules:SendCustomMessage("#sf_eg9", 0, 0)  
	end) 

	Timers:CreateTimer(51,function()
         GameRules:SendCustomMessage("#sf_eg10", 0, 0)  
	end) 

	Timers:CreateTimer(53,function()
        penguin_1:SetAbsOrigin(pingwin_1)    
        penguin_2:SetAbsOrigin(pingwin_2)    
        penguin_3:SetAbsOrigin(pingwin_3)    
        penguin_4:SetAbsOrigin(pingwin_4)    
        ping:SetAbsOrigin(pingwin_5)    
	end) 


	Timers:CreateTimer(56,function()
         GameRules:SendCustomMessage("#pn_eg1", 0, 0)  
	end) 

	Timers:CreateTimer(61,function()
         GameRules:SendCustomMessage("#pn_eg2", 0, 0)  
	end) 
 
 	Timers:CreateTimer(64,function()
         GameRules:SendCustomMessage("#pn_eg3", 0, 0)  
	end) 

 	Timers:CreateTimer(68,function()
         GameRules:SendCustomMessage("#pn_eg4", 0, 0) 
         self.parent:RemoveModifierByName("modifier_invulnerable")
         self.parent:RemoveModifierByName("modifier_disable_sf_ping")
         EmitGlobalSound("sf_no")
         self.parent:ForceKill(false)  
         ParticleManager:DestroyParticle(self.effect_cast, false)
	end) 

 	Timers:CreateTimer(73,function()
  for i,name in ipairs(jitels) do  
    local unit = Entities:FindByName(nil, name)
    if unit then 
         unit:RemoveModifierByName("modifier_disable_sf")
          
    else
          
    end
 end 

        for index=0 ,HeroList:GetHeroCount() do  
		  		if HeroList:GetHero(index)    then   
			        local hero = HeroList:GetHero(index)   
 
                   hero:RemoveModifierByName("modifier_disable_sf")
                end
        end	
        EndGame:ChristmasEnd()
	end)

end 

 
 
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

 
function MoveToPoint(unit, point)
	Timers:CreateTimer(0.1, function()
		ExecuteOrderFromTable({
			UnitIndex = unit:entindex(),		-- индекс кастера
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,				-- тип приказа
			Position = point,	 	-- положение врага
			Queue = false,						-- ждать очереди ?
		})	
	end)	
end

function CDOTA_BaseNPC:CastSkill(skill_name, unit)
	local ability = self:FindAbilityByName(skill_name)
	local order_type = nil

	if ability then
		if unit then
			ExecuteOrderFromTable({
				UnitIndex = self:entindex(),		-- индекс кастера
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,				-- тип приказа
				AbilityIndex = ability:entindex(),	-- индекс способности
				TargetIndex = unit:entindex(), 	-- индекс врага
				Queue = false,						-- ждать очереди ?
			})		
		else
			ExecuteOrderFromTable({
				UnitIndex = self:entindex(),		-- индекс кастера
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,				-- тип приказа
				AbilityIndex = ability:entindex(),	-- индекс способности
				Queue = false,						-- ждать очереди ?
			})		
		end
				
	else
		print("ability "..skill_name.." not found !!!")
	end
	
end

function CDOTA_BaseNPC:CastPointSkill(skill_name, point)
	local ability = self:FindAbilityByName(skill_name)

	if ability then
		ExecuteOrderFromTable({
		UnitIndex = self:entindex(),		-- индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,				-- тип приказа
		AbilityIndex = ability:entindex(),	-- индекс способности
		Position = point,	 	-- положение врага
		Queue = false,						-- ждать очереди ?
		})		

			
	else
		print("ability "..skill_name.." not found !!!")
	end
	
end


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
