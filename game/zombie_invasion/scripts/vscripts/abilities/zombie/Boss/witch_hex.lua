LinkLuaModifier( "modifier_witch_hex", "abilities/zombie/Boss/witch_hex", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_witch_hex_active", "abilities/zombie/Boss/witch_hex", LUA_MODIFIER_MOTION_NONE )
witch_hex = class({})

function witch_hex:Precache(context)
	PrecacheAbilityResources({
	}, {
		"Hero_Lion.Voodoo",
	}, context)
end

 

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function witch_hex:GetIntrinsicModifierName()
	return "modifier_witch_hex"
end


modifier_witch_hex = class({})


modifier_witch_hex = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,
 
})


--------------------------------------------------------------------------------
-- Initializations
function modifier_witch_hex:OnCreated()
    self.hex_chance = self:GetAbility():GetSpecialValueFor("hex_chance")
    self.hex_duration = self:GetAbility():GetSpecialValueFor("hex_duration")
end

function modifier_witch_hex:OnRefresh()
    self:OnCreated()
end
 

function modifier_witch_hex:OnAttackLanded(keys)
    local target = keys.target
    if not self:GetAbility():IsCooldownReady() or target:IsMagicImmune() then return nil end
    if self:GetCaster() == keys.attacker then
    	if RollPseudoRandomPercentage(self.hex_chance, 1, self:GetCaster())  then  
            target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_witch_hex_active",{duration = self.hex_duration})        
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	        EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )       
        end   
    end
end


modifier_witch_hex_active = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsPurgeException        = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MODEL_CHANGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        } end,
    CheckState      = function(self) return 
        {
 		[MODIFIER_STATE_MUTED] = true,  
  		[MODIFIER_STATE_SILENCED] = true,            
  		[MODIFIER_STATE_DISARMED] = true,  
        } end,
})

function modifier_witch_hex_active:GetModifierModelChange()  
    return "models/props_gameplay/cold_frog.vmdl"
end

function modifier_witch_hex_active:GetModifierMoveSpeedBonus_Constant()  
    return -400
end