
item_guardian_greaves_up = item_guardian_greaves_up or class({})
LinkLuaModifier("modifier_item_guardian_greaves_up", "items/bots/item_guardian_greaves_up", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_greaves_up_buff", "items/bots/item_guardian_greaves_up", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_greaves_up_debuff", "items/bots/item_guardian_greaves_up", LUA_MODIFIER_MOTION_NONE)
 
function item_guardian_greaves_up:GetIntrinsicModifierName()
	return "modifier_item_guardian_greaves_up"
end
 

-- Stats modifier (stackable)
modifier_item_guardian_greaves_up = modifier_item_guardian_greaves_up or class({})

function modifier_item_guardian_greaves_up:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_movement = self.ability:GetSpecialValueFor("bonus_movement")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

 
    self.debuff_duration = self.ability:GetSpecialValueFor("debuff_duration")
    self.buff_duration = self.ability:GetSpecialValueFor("buff_duration")
	self.healt_for_use = self.ability:GetSpecialValueFor("healt_for_use")/100
 
 
end

function modifier_item_guardian_greaves_up:IsHidden() return true end
function modifier_item_guardian_greaves_up:IsPurgable() return false end
function modifier_item_guardian_greaves_up:IsDebuff() return false end
function modifier_item_guardian_greaves_up:IsPermanent() return true end
function modifier_item_guardian_greaves_up:RemoveOnDeath() return false end
function modifier_item_guardian_greaves_up:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_guardian_greaves_up:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE}

	return decFuncs
end

function modifier_item_guardian_greaves_up:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_item_guardian_greaves_up:GetModifierHealthBonus()
    return self.bonus_health
end


function modifier_item_guardian_greaves_up:GetModifierMoveSpeedBonus_Special_Boots()
    return self.bonus_movement
end

function modifier_item_guardian_greaves_up:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
             
            if not self.ability:IsCooldownReady() or self:GetParent():HasModifier("modifier_item_guardian_greaves_up_debuff")  then return end 

            if self:GetParent():GetMaxHealth() * self.healt_for_use >= self:GetParent():GetHealth() then
     	         local heal_hp =  self:GetParent():GetMaxHealth() * (self.ability:GetSpecialValueFor("heal_hp")/100) 
			  
				local cast_pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			    ParticleManager:ReleaseParticleIndex(cast_pfx)
                 
                 self:GetParent():EmitSound("Item.GuardianGreaves.Activate")
			     self:GetParent():Purge( false, true, false, true, true )
                 self:GetParent():Heal(heal_hp, self:GetAbility())
                 SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), heal_hp , nil) 

                 self:GetParent():AddNewModifier( self:GetParent(), self.ability, "modifier_item_guardian_greaves_up_buff", {duration = self.buff_duration } )
                 self:GetParent():AddNewModifier( self:GetParent(), self.ability, "modifier_item_guardian_greaves_up_debuff", {duration = self.debuff_duration } )

                 self.ability:StartCooldown(self.ability:GetCooldown( self.ability:GetLevel()))               
            end
        end
    end
end


-- Move speed bonus buff (active)
modifier_item_guardian_greaves_up_buff = modifier_item_guardian_greaves_up_buff or class({})

function modifier_item_guardian_greaves_up_buff:IsHidden() return false end
function modifier_item_guardian_greaves_up_buff:IsPurgable() return true end
function modifier_item_guardian_greaves_up_buff:IsDebuff() return false end

function modifier_item_guardian_greaves_up_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
 
	-- Ability specials
	self.heal_hp_per_second = self.ability:GetSpecialValueFor("heal_hp_per_second")
 
		self:StartIntervalThink(1.0)
 
end

function modifier_item_guardian_greaves_up_buff:OnIntervalThink()
    self:GetParent():Heal(self.heal_hp_per_second, self:GetAbility()) 
end

 
 
modifier_item_guardian_greaves_up_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
 
})


--------------------------------------------------------------------------------
 