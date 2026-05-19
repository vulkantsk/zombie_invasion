slow_zombie_attack = class({})
LinkLuaModifier( "modifier_slow_zombie_attack", "abilities/monsters/slow_zombie_attack",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slow_zombie_attack_stack", "abilities/monsters/slow_zombie_attack",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slow_zombie_attack_enemy", "abilities/monsters/slow_zombie_attack",LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
 
   
function slow_zombie_attack:GetIntrinsicModifierName()
 
	return "modifier_slow_zombie_attack"
	 
end

 
modifier_slow_zombie_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slow_zombie_attack:IsHidden()
	return true
end

function modifier_slow_zombie_attack:IsDebuff()
	return false
end

function modifier_slow_zombie_attack:IsPurgable()
	return false
end

  

--------------------------------------------------------------------------------
-- Initializations
function modifier_slow_zombie_attack:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) -- special value
end

function modifier_slow_zombie_attack:OnRefresh( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) -- special value
end
 

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slow_zombie_attack:DeclareFunctions()
	local funcs = {
       MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
 
 

function modifier_slow_zombie_attack:OnAttackLanded(keys)
    local target = keys.target
    if self:GetCaster() == keys.attacker then
    	if not target:HasModifier("modifier_slow_zombie_attack_enemy") then 
            target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_slow_zombie_attack_enemy",{duration = self.duration} ) 
          end 
             self.modif = target:FindModifierByName("modifier_slow_zombie_attack_enemy")
             local modif_stack = target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_slow_zombie_attack_stack",{duration = self.duration}) 
             
	         modif_stack.parent = self.modif
             self.modif:SetStackCount( self.modif:GetStackCount() + 1 )
             self.modif:SetDuration( self.duration, true )       
       	
    end
end

 
  


modifier_slow_zombie_attack_enemy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slow_zombie_attack_enemy:IsHidden()
	return false
end

function modifier_slow_zombie_attack_enemy:IsDebuff()
	return true
end

function modifier_slow_zombie_attack_enemy:IsPurgable()
	return true
end

  

--------------------------------------------------------------------------------
-- Initializations
function modifier_slow_zombie_attack_enemy:OnCreated( kv )
	-- references
 
 	self.slow_movespeed = self:GetAbility():GetSpecialValueFor( "slow_movespeed" ) -- special value
end

function modifier_slow_zombie_attack_enemy:OnRefresh( kv )
	-- references
 
 	self.slow_movespeed = self:GetAbility():GetSpecialValueFor( "slow_movespeed" ) -- special value
end
 

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slow_zombie_attack_enemy:DeclareFunctions()
	local funcs = {
       MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_slow_zombie_attack_enemy:GetModifierMoveSpeedBonus_Percentage()
	return (self:GetStackCount() * self.slow_movespeed)
end
  
function modifier_slow_zombie_attack_enemy:RemoveStack( value )
	self:SetStackCount( self:GetStackCount() - value )
end

modifier_slow_zombie_attack_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slow_zombie_attack_stack:IsHidden()
	return true
end

function modifier_slow_zombie_attack_stack:IsDebuff()
	return true
end

function modifier_slow_zombie_attack_stack:IsPurgable()
	return true
end

function modifier_slow_zombie_attack_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_slow_zombie_attack_stack:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slow_zombie_attack_stack:OnCreated( kv )

end

function modifier_slow_zombie_attack_stack:OnRefresh( kv )
	
end

function modifier_slow_zombie_attack_stack:OnRemoved()
end

function modifier_slow_zombie_attack_stack:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveStack( 1 )
end

