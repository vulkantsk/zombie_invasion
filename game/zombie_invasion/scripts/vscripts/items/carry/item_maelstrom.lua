 LinkLuaModifier("modifier_item_imba_chain_lightning", "items/carry/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_chain_lightning_cooldown", "items/carry/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

 

modifier_item_imba_chain_lightning					= modifier_item_imba_chain_lightning or class({})
modifier_item_imba_chain_lightning_cooldown			= modifier_item_imba_chain_lightning_cooldown or class({})
 

LinkLuaModifier("modifier_item_imba_maelstrom", "items/carry/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_maelstrom_2", "items/carry/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_maelstrom_3", "items/carry/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
-- This code will be combining all three items into one class
item_maelstrom_2									= item_maelstrom_2 or class({})
item_maelstrom_3									= item_maelstrom_3 or class({})
item_maelstrom_4									= item_maelstrom_4 or class({})

modifier_item_imba_maelstrom						= modifier_item_imba_maelstrom or class({})

modifier_item_imba_maelstrom_2                      	= modifier_item_imba_maelstrom_2 or class({})
 
modifier_item_imba_maelstrom_3                      	= modifier_item_imba_maelstrom_3 or class({})
 
----------------------------------------
-- MODIFIER_ITEM_IMBA_CHAIN_LIGHTNING --
----------------------------------------

function modifier_item_imba_chain_lightning:IsHidden()		return true end
function modifier_item_imba_chain_lightning:IsPurgable()	return false end
function modifier_item_imba_chain_lightning:RemoveOnDeath()	return false end
function modifier_item_imba_chain_lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_chain_lightning:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
 
	if self:GetAbility() then
		self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.chain_damage	= self:GetAbility():GetSpecialValueFor("chain_damage")
 		self.chain_damage_self	= self:GetAbility():GetSpecialValueFor("chain_damage_self")
		self.chain_strikes	= self:GetAbility():GetSpecialValueFor("chain_strikes")
		self.chain_radius	= self:GetAbility():GetSpecialValueFor("chain_radius")
		self.chain_delay	= self:GetAbility():GetSpecialValueFor("chain_delay")

	else
		self.bonus_damage	= 0
		self.chain_damage	= 0
		self.chain_damage_self = 0
		self.chain_strikes	= 0
		self.chain_radius	= 0
		self.chain_delay	= 0
	end
	
	self.starting_unit_entindex	= keys.starting_unit_entindex
	
	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	else
		self:Destroy()
		return
	end

	self.units_affected			= {}
	self.unit_counter			= 0
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.chain_delay)
end

function modifier_item_imba_chain_lightning:OnIntervalThink()
	self.zapped = false
    local caster = self:GetCaster()
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.chain_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		if not self.units_affected[enemy] then
			enemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			
			self.zap_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit) 
			
			if self.unit_counter == 0 then
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			end
			
			ParticleManager:SetParticleControlEnt(self.zap_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.zap_particle, 2, Vector(1, 1, 1))
			ParticleManager:ReleaseParticleIndex(self.zap_particle)
		
			self.unit_counter						= self.unit_counter + 1
			self.current_unit						= enemy
			self.units_affected[self.current_unit]	= true
			self.zapped								= true
			
 
			ApplyDamage({
				victim 			= enemy,
				damage 			= (caster:GetAverageTrueAttackDamage(caster) * (self.chain_damage_self/100)) + self.chain_damage  ,  
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
 
			break
		end
	end
	
	if (self.unit_counter >= self.chain_strikes and self.chain_strikes > 0) or not self.zapped then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

 
-------------------------
-- ITEM_IMBA_MAELSTROM --
-------------------------

function item_maelstrom_2:GetIntrinsicModifierName()
	return "modifier_item_imba_maelstrom"
end
 
function item_maelstrom_3:GetIntrinsicModifierName()
	return "modifier_item_imba_maelstrom_2"
end
 
function item_maelstrom_4:GetIntrinsicModifierName()
	return "modifier_item_imba_maelstrom_3"
end 

----------------------------------
-- MODIFIER_ITEM_IMBA_MAELSTROM --
----------------------------------

function modifier_item_imba_maelstrom:IsHidden()		return true end
function modifier_item_imba_maelstrom:IsPurgable()		return false end
function modifier_item_imba_maelstrom:RemoveOnDeath()	return false end
function modifier_item_imba_maelstrom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_maelstrom:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if self:GetAbility() then
		self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
 
		
		self.chain_chance	= self:GetAbility():GetSpecialValueFor("chain_chance")
		self.chain_cooldown	= self:GetAbility():GetSpecialValueFor("chain_cooldown")
		
 
	else
		self.bonus_damage		= 0
 
		
		self.chain_chance	= 0
		self.chain_cooldown	= 0
		
 
	end
	
	self.bChainCooldown = false
	
	if not IsServer() then return end
	
 
 
end

function modifier_item_imba_maelstrom:OnDestroy()
    if not IsServer() then return end
    
 
	
 
end

function modifier_item_imba_maelstrom:OnIntervalThink()
	self.bChainCooldown = false
	self:StartIntervalThink(-1)
end

function modifier_item_imba_maelstrom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
 
 
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_item_imba_maelstrom:GetModifierPreAttack_BonusDamage(keys)
 
		return self.bonus_damage
 
end

 
 
 

 

function modifier_item_imba_maelstrom:OnAttackLanded(keys)
	-- Chain Lightning Logic
	if keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.bChainCooldown and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RollPseudoRandom(self.chain_chance, self:GetAbility()) then
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- if self:GetCaster():HasModifier("modifier_item_imba_chain_lightning_cooldown") then return end
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
		
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning_cooldown", {duration = self.chain_cooldown})
	end
	
 
end


function modifier_item_imba_maelstrom_2:IsHidden()		return true end
function modifier_item_imba_maelstrom_2:IsPurgable()		return false end
function modifier_item_imba_maelstrom_2:RemoveOnDeath()	return false end
function modifier_item_imba_maelstrom_2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_maelstrom_2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if self:GetAbility() then
		self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
 
		 self.bonus_attack_speed	= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
		self.chain_chance	= self:GetAbility():GetSpecialValueFor("chain_chance")
		self.chain_cooldown	= self:GetAbility():GetSpecialValueFor("chain_cooldown")
		
 
	else
		self.bonus_damage		= 0
 
		self.bonus_attack_speed = 0
		self.chain_chance	= 0
		self.chain_cooldown	= 0
		
 
	end
	
	self.bChainCooldown = false
	
	if not IsServer() then return end
	
 
 
end

function modifier_item_imba_maelstrom_2:OnDestroy()
    if not IsServer() then return end
    
 
	
 
end

function modifier_item_imba_maelstrom_2:OnIntervalThink()
	self.bChainCooldown = false
	self:StartIntervalThink(-1)
end

function modifier_item_imba_maelstrom_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_item_imba_maelstrom_2:GetModifierPreAttack_BonusDamage(keys)
 
		return self.bonus_damage
 
end


function modifier_item_imba_maelstrom_2:GetModifierAttackSpeedBonus_Constant(keys)
 
		return self.bonus_attack_speed
 
end

  
 
 

 

function modifier_item_imba_maelstrom_2:OnAttackLanded(keys)
	-- Chain Lightning Logic
	if keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.bChainCooldown and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RollPseudoRandom(self.chain_chance, self:GetAbility()) then
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- if self:GetCaster():HasModifier("modifier_item_imba_chain_lightning_cooldown") then return end
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
		
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning_cooldown", {duration = self.chain_cooldown})
	end
	
 
end


function modifier_item_imba_maelstrom_3:IsHidden()		return true end
function modifier_item_imba_maelstrom_3:IsPurgable()		return false end
function modifier_item_imba_maelstrom_3:RemoveOnDeath()	return false end
function modifier_item_imba_maelstrom_3:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_maelstrom_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if self:GetAbility() then
		self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
 
		 self.bonus_attack_speed	= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
		self.chain_chance	= self:GetAbility():GetSpecialValueFor("chain_chance")
		self.chain_cooldown	= self:GetAbility():GetSpecialValueFor("chain_cooldown")
		
 
	else
		self.bonus_damage		= 0
 
		self.bonus_attack_speed = 0
		self.chain_chance	= 0
		self.chain_cooldown	= 0
		
 
	end
	
	self.bChainCooldown = false
	
	if not IsServer() then return end
	
 
 
end

function modifier_item_imba_maelstrom_3:OnDestroy()
    if not IsServer() then return end
    
 
	
 
end

function modifier_item_imba_maelstrom_3:OnIntervalThink()
	self.bChainCooldown = false
	self:StartIntervalThink(-1)
end

function modifier_item_imba_maelstrom_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_item_imba_maelstrom_3:GetModifierPreAttack_BonusDamage(keys)
 
		return self.bonus_damage
 
end


function modifier_item_imba_maelstrom_3:GetModifierAttackSpeedBonus_Constant(keys)
 
		return self.bonus_attack_speed
 
end

  
 
 

 

function modifier_item_imba_maelstrom_3:OnAttackLanded(keys)
	-- Chain Lightning Logic
	if keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.bChainCooldown and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RollPseudoRandom(self.chain_chance, self:GetAbility()) then
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- if self:GetCaster():HasModifier("modifier_item_imba_chain_lightning_cooldown") then return end
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
		
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning_cooldown", {duration = self.chain_cooldown})
	end
	
 
end